#!/usr/bin/env perl
# Sweeps text files for trailing whitespace and EOF newline issues, with an
# optional line-ending / tab normalization pass. Dry-run (check) by default.
use strict;
use warnings;
use Getopt::Long qw(GetOptions);

sub usage {
    print STDERR <<'USAGE';
usage: perl whitespace_sweep.pl [--apply] [--eol=lf|crlf] [--tabs=N] FILE...

Default (no --apply): reports what would change and exits 1 if any file
needs fixing, 0 if everything is already clean -- safe to use as a check.

  --apply        write the fixes to disk
  --eol=lf|crlf  force every line ending in touched files to this style
                 (default: keep whichever style is already dominant in
                 each file, so untouched files are never re-encoded)
  --tabs=N       expand tabs to N spaces (default: leave tabs alone)

Always applied, regardless of flags:
  - strip trailing whitespace at the end of each line
  - collapse trailing blank lines and ensure exactly one final newline

Files that look binary are skipped untouched.
USAGE
    exit 2;
}

my $apply = 0;
my $eol;
my $tabs;
GetOptions(
    'apply'  => \$apply,
    'eol=s'  => \$eol,
    'tabs=i' => \$tabs,
) or usage();

usage() if !@ARGV;
if (defined $eol && $eol ne 'lf' && $eol ne 'crlf') {
    print STDERR "ERROR: --eol must be 'lf' or 'crlf'\n";
    exit 2;
}

my $any_dirty      = 0;
my $any_error      = 0;
my $files_changed  = 0;

for my $path (@ARGV) {
    unless (-e $path) {
        print STDERR "SKIP (not found): $path\n";
        $any_error = 1;
        next;
    }
    next if -d $path;
    next if -B $path;   # binary, leave untouched

    open(my $fh, '<:raw', $path) or do {
        print STDERR "SKIP (cannot read): $path: $!\n";
        $any_error = 1;
        next;
    };
    my $orig = do { local $/; <$fh> };
    close $fh;
    next unless defined $orig && $orig ne '';

    my $crlf_count = () = $orig =~ /\r\n/g;
    my $lf_count   = () = $orig =~ /(?<!\r)\n/g;
    my $sep = $eol
        ? ($eol eq 'crlf' ? "\r\n" : "\n")
        : ($crlf_count > 0 && $crlf_count >= $lf_count ? "\r\n" : "\n");

    # split()'s default limit drops trailing empty fields, which is exactly
    # "collapse trailing blank lines" for free.
    my @lines = split /\r\n|\n/, $orig;

    my $trailing_ws_fixed = 0;
    for my $line (@lines) {
        $trailing_ws_fixed++ if $line =~ s/[ \t]+\z//;
        if (defined $tabs) {
            my $spaces = ' ' x $tabs;
            $line =~ s/\t/$spaces/g;
        }
    }
    my $rebuilt = @lines ? join($sep, @lines) . $sep : '';

    next if $rebuilt eq $orig;

    $any_dirty = 1;
    my @notes;
    push @notes, "$trailing_ws_fixed line(s) with trailing whitespace" if $trailing_ws_fixed;
    push @notes, "eol normalized to $eol" if $eol;
    push @notes, "tabs expanded to $tabs spaces" if defined $tabs;
    push @notes, "trailing blank lines / final newline normalized" unless @notes;
    my $note_str = join(', ', @notes);

    if ($apply) {
        open(my $out, '>:raw', $path) or do {
            print STDERR "FAILED to write $path: $!\n";
            $any_error = 1;
            next;
        };
        print $out $rebuilt;
        close $out;
        $files_changed++;
        print "FIXED: $path ($note_str)\n";
    } else {
        print "WOULD FIX: $path ($note_str)\n";
    }
}

exit 1 if $any_error;

if ($apply) {
    print "\nDone: fixed $files_changed file(s).\n";
    exit 0;
}

if ($any_dirty) {
    print "\nDry run: issues found above. Re-run with --apply to fix.\n";
    exit 1;
}

print "Clean: no whitespace issues found.\n";
exit 0;
