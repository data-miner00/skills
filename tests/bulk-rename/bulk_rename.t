#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use File::Temp qw(tempdir);
use File::Spec;
use FindBin qw($RealBin);
use lib "$RealBin/../lib";
use SkillTestUtil qw(run_script touch_file);

my $script = File::Spec->catfile($RealBin, '..', '..', 'skills', 'bulk-rename', 'scripts', 'bulk_rename.pl');
ok(-f $script, "bulk_rename.pl exists at $script") or BAIL_OUT('script not found');

subtest 'dry run: reports the plan without renaming anything' => sub {
    my $dir = tempdir(CLEANUP => 1);
    my $old = File::Spec->catfile($dir, 'IMG_001.png');
    touch_file($old);

    my ($out, $exit) = run_script($script, 's/^IMG_(\d+)/photo-$1/', $old);

    is($exit, 0, 'exits 0');
    like($out, qr/WOULD RENAME/, 'reports would-rename');
    ok(-e $old, 'original file untouched');
    ok(!-e File::Spec->catfile($dir, 'photo-001.png'), 'target not created');
};

subtest 'collision: target already exists aborts the whole batch' => sub {
    my $dir = tempdir(CLEANUP => 1);
    my $old      = File::Spec->catfile($dir, 'IMG_002.png');
    my $existing = File::Spec->catfile($dir, 'photo-002.png');
    touch_file($old);
    touch_file($existing);

    my ($out, $exit) = run_script($script, 's/^IMG_(\d+)/photo-$1/', $old);

    is($exit, 1, 'exits 1');
    like($out, qr/COLLISION/, 'reports collision');
    ok(-e $old, 'source untouched after abort');
};

subtest 'collision: two sources map to the same target' => sub {
    my $dir = tempdir(CLEANUP => 1);
    my $a = File::Spec->catfile($dir, 'a_1.txt');
    my $b = File::Spec->catfile($dir, 'b_1.txt');
    touch_file($a);
    touch_file($b);

    my ($out, $exit) = run_script($script, 's/^[ab]_/x_/', $a, $b);

    is($exit, 1, 'exits 1');
    like($out, qr/COLLISION/, 'reports collision');
    ok(-e $a && -e $b, 'both sources untouched after abort');
};

subtest 'apply: renames files on disk' => sub {
    my $dir = tempdir(CLEANUP => 1);
    my $old = File::Spec->catfile($dir, 'IMG_003.png');
    touch_file($old);

    my ($out, $exit) = run_script($script, '--apply', 's/^IMG_(\d+)/photo-$1/', $old);

    is($exit, 0, 'exits 0');
    like($out, qr/RENAMED/, 'reports renamed');
    ok(!-e $old, 'old name gone');
    ok(-e File::Spec->catfile($dir, 'photo-003.png'), 'new name exists');
};

subtest 'no matching files: reports nothing to rename' => sub {
    my $dir = tempdir(CLEANUP => 1);
    my $old = File::Spec->catfile($dir, 'already-clean.txt');
    touch_file($old);

    my ($out, $exit) = run_script($script, 's/^IMG_(\d+)/photo-$1/', $old);

    is($exit, 0, 'exits 0');
    like($out, qr/Nothing to rename/, 'reports nothing to rename');
};

subtest 'usage errors exit 2' => sub {
    my (undef, $exit1) = run_script($script);
    is($exit1, 2, 'no args exits 2');

    my $dir  = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($dir, 'x.txt');
    touch_file($file);
    my (undef, $exit2) = run_script($script, 'not-a-substitution', $file);
    is($exit2, 2, 'non s/// expression exits 2');
};

done_testing();
