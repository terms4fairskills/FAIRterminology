#/usr/bin/perl -w

# Single-use script (May 2021) for mapping initial set of IRIs to a
# consistent naming and numbering scheme.
#
# Example: perl scripts/mapping.pl < build/t4fsIRIs-list.csv > build/mapping.csv
#
# Use scripts/t4fsIRIs-list.sparql to create build/t4fsIRIs-list.csv
# Output of this perl script can be passed to robot rename, e.g.
# java -jar build/robot.jar rename --input t4fs.owl --mappings build/mapping.csv --add-prefix "t4fs: http://terms4FAIRskills.org/FAIRterminology" --output build/t4fs.owl
#
# Created by Allyson Lister

use strict;
use warnings;

my $initialValue = 0;

while ( my $line = <> ) {
    chomp $line ;
    $line =~s/\s+//g;

    my $nextnumber = sprintf("%07d", $initialValue);
    $initialValue++;

    print "$line,https://github.com/terms4fairskills/FAIRterminology/T4FS_$nextnumber\n";
}
