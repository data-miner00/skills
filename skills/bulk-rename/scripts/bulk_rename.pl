#!/usr/bin/env perl
# Regex-driven batch file rename with a dry-run plan and collision detection.
use strict;
use warnings;
use File::Basename qw(basename dirname);
use File::Spec;
use Getopt::Long qw(GetOptions);

sub usage {
    print STDERR <<'USAGE';
usage: perl bulk_rename.pl [--apply] 's/PATTERN/REPLACEMENT/FLAGS' PATH...

Dry-run by default: prints the rename plan without touching the filesystem.
Pass --apply to actually perform the renames, but only after the whole
batch validates clean (no collisions, no missing files).

The substitution is applied to each file's basename only, never its
directory, and is evaluated as Perl -- pass an expression you trust,
same as you would to the classic `rename` utility. Avoid the /r flag
(it would leave every file unchanged).

Examples:
  perl bulk_rename.pl 's/\.jpeg$/.jpg/' photos/*.jpeg
  perl bulk_rename.pl --apply 's/^IMG_(\d+)/photo-$1/' *.png
USAGE
    exit 2;
}

my $apply = 0;
GetOptions('apply' => \$apply) or usage();

my $expr = shift @ARGV;
usage() unless defined $expr && @ARGV;

# Only allow s/// substitutions -- refuse anything that isn't shaped like one.
usage() unless $expr =~ m{^s(.).*\1.*\1[a-zA-Z]*$};

my %planned;   # new_path => old_path, for collision detection
my @plan;      # ordered [old, new] pairs actually going to change
my $unchanged = 0;
my $had_error = 0;

for my $old (@ARGV) {
    unless (-e $old) {
        print STDERR "SKIP (not found): $old\n";
        $had_error = 1;
        next;
    }

    my $dir  = dirname($old);
    my $base = basename($old);
    my $new_base = $base;

    my $ok = eval "\$new_base =~ $expr; 1";
    unless ($ok) {
        print STDERR "ERROR: invalid substitution expression: $@";
        exit 2;
    }

    if ($new_base eq $base) {
        $unchanged++;
        next;
    }

    my $new = File::Spec->catfile($dir, $new_base);

    if (exists $planned{$new}) {
        print STDERR "COLLISION: '$old' and '$planned{$new}' both rename to '$new'\n";
        $had_error = 1;
        next;
    }
    if (-e $new) {
        print STDERR "COLLISION: target already exists: '$new' (from '$old')\n";
        $had_error = 1;
        next;
    }

    $planned{$new} = $old;
    push @plan, [$old, $new];
}

if ($had_error) {
    print STDERR "\nAborting: fix the problems above before re-running.\n";
    exit 1;
}

if (!@plan) {
    print "Nothing to rename ($unchanged file(s) already match).\n";
    exit 0;
}

for my $pair (@plan) {
    my ($old, $new) = @$pair;
    print(($apply ? "RENAMED: " : "WOULD RENAME: ") . "$old -> $new\n");
}

if ($apply) {
    for my $pair (@plan) {
        my ($old, $new) = @$pair;
        rename($old, $new) or do {
            print STDERR "FAILED to rename '$old' -> '$new': $!\n";
            exit 1;
        };
    }
    print "\nDone: renamed " . scalar(@plan) . " file(s).\n";
} else {
    print "\nDry run only -- re-run with --apply to perform these " . scalar(@plan) . " rename(s).\n";
}

exit 0;
