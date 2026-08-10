package SkillTestUtil;
# Shared harness for testing skill scripts as black-box subprocesses.
use strict;
use warnings;
use Exporter 'import';
use IPC::Open3;
use Symbol 'gensym';

our @EXPORT_OK = qw(run_script touch_file read_file);

# Runs `perl $script @args`, bypassing the shell (so args with $, quotes,
# backslashes -- like regex substitutions -- never need escaping). Returns
# (combined stdout+stderr, exit code).
sub run_script {
    my ($script, @args) = @_;
    my $err = gensym;
    my $pid = open3(my $in, my $out, $err, $^X, $script, @args);
    close $in;
    local $/;
    my $stdout = <$out>;
    my $stderr = <$err>;
    close $out;
    close $err;
    waitpid($pid, 0);
    my $exit = $? >> 8;
    return (($stdout // '') . ($stderr // ''), $exit);
}

sub touch_file {
    my ($path, $content) = @_;
    open(my $fh, '>:raw', $path) or die "cannot create $path: $!";
    print $fh $content if defined $content;
    close $fh;
}

sub read_file {
    my ($path) = @_;
    open(my $fh, '<:raw', $path) or die "cannot read $path: $!";
    local $/;
    return <$fh>;
}

1;
