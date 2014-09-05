#!/usr/bin/perl -w
use warnings;
use strict;

my $dir = '/var/net-snmp/mib_indexes/';

opendir DIR, $dir or die "Can't open directory $dir: $!\n";

while (my $file = readdir DIR) {
    next unless $file =~ /^\d+$/;
    open INDEXFILE, $dir.'/'.$file or die "Can't open $file for reading: $!\n";
    my $valid_file = 0;
    while (my $line = <INDEXFILE>) {
        if ($line =~ /^DIR \.\/([\w\-]+)$/) {
            my $is_for = $1;
            printf("Found MIB index file %s for dir %s\n", $file, $is_for);
            my $newfile = sprintf("./%s/.index", $is_for);
            open NEWINDEX, '>'.$newfile or die "Can't open $newfile for writing: $!\n";
            $valid_file = 1;
        } elsif ($valid_file) {
            print NEWINDEX $line;
        }
    }
    close INDEXFILE;
    close NEWINDEX if $valid_file;
}


### Hint to strip TC information from snmptranslate -Tt:
# snmptranslate -Tt | sed -re 's/ tc=[0-9]+//g'
# For good comparison, "anonymous#<something>" should be fixed too

