#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use File::Temp qw(tempdir);
use File::Spec;
use FindBin qw($RealBin);
use lib "$RealBin/../lib";
use SkillTestUtil qw(run_script touch_file read_file);

my $script = File::Spec->catfile($RealBin, '..', '..', 'skills', 'whitespace-sweep', 'scripts', 'whitespace_sweep.pl');
ok(-f $script, "whitespace_sweep.pl exists at $script") or BAIL_OUT('script not found');

subtest 'check mode: dirty file is reported and left untouched' => sub {
    my $dir  = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($dir, 'dirty.txt');
    touch_file($file, "hello   \nworld\t\n\n\n");
    my $before = read_file($file);

    my ($out, $exit) = run_script($script, $file);

    is($exit, 1, 'exits 1 (dirty)');
    like($out, qr/WOULD FIX/, 'reports would-fix');
    is(read_file($file), $before, 'file left untouched in check mode');
};

subtest 'check mode: clean file exits 0' => sub {
    my $dir  = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($dir, 'clean.txt');
    touch_file($file, "hello\nworld\n");

    my ($out, $exit) = run_script($script, $file);

    is($exit, 0, 'exits 0 (clean)');
    like($out, qr/Clean/, 'reports clean');
};

subtest 'apply: strips trailing whitespace and collapses trailing blank lines' => sub {
    my $dir  = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($dir, 'dirty.txt');
    touch_file($file, "hello   \nworld\t\n\n\n");

    my ($out, $exit) = run_script($script, '--apply', $file);

    is($exit, 0, 'exits 0');
    like($out, qr/FIXED/, 'reports fixed');
    is(read_file($file), "hello\nworld\n", 'trailing ws stripped, blank lines collapsed');
};

subtest 'apply: CRLF file keeps CRLF by default, tabs left alone' => sub {
    my $dir  = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($dir, 'crlfy.txt');
    touch_file($file, "crlf\tline  \r\nsecond\r\n\r\n");

    run_script($script, '--apply', $file);

    is(read_file($file), "crlf\tline\r\nsecond\r\n", 'CRLF preserved, tab untouched');
};

subtest '--eol=lf forces line-ending normalization' => sub {
    my $dir  = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($dir, 'crlfy.txt');
    touch_file($file, "a  \r\nb\r\n");

    run_script($script, '--apply', '--eol=lf', $file);

    is(read_file($file), "a\nb\n", 'CRLF converted to LF');
};

subtest '--tabs=N expands tabs to spaces' => sub {
    my $dir  = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($dir, 'tabby.txt');
    touch_file($file, "a\tb\n");

    run_script($script, '--apply', '--tabs=2', $file);

    is(read_file($file), "a  b\n", 'tab expanded to 2 spaces');
};

subtest 'binary files are skipped untouched' => sub {
    my $dir  = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($dir, 'bin.dat');
    touch_file($file, "\x00binary\x01data");
    my $before = read_file($file);

    my ($out, $exit) = run_script($script, '--apply', $file);

    is($exit, 0, 'exits 0 (nothing to fix)');
    is(read_file($file), $before, 'binary content unchanged');
};

subtest 'idempotent: re-running after apply reports clean' => sub {
    my $dir  = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($dir, 'dirty.txt');
    touch_file($file, "hello   \nworld\t\n\n\n");
    run_script($script, '--apply', $file);

    my ($out, $exit) = run_script($script, $file);

    is($exit, 0, 'second run exits 0');
    like($out, qr/Clean/, 'second run reports clean');
};

subtest 'usage errors exit 2' => sub {
    my (undef, $exit1) = run_script($script);
    is($exit1, 2, 'no args exits 2');

    my $dir  = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($dir, 'x.txt');
    touch_file($file, "a\n");
    my (undef, $exit2) = run_script($script, '--eol=bogus', $file);
    is($exit2, 2, 'bad --eol value exits 2');
};

done_testing();
