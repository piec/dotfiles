#!/usr/bin/perl

my $blanked = 0;
open (IN, "xscreensaver-command -watch |");
while (<IN>) {
   if (m/^(BLANK|LOCK)/) {
       if (!$blanked) {
           print "lock\n";
           system "weechat_away.sh 1";
           $blanked = 1;
       }
   } elsif (m/^UNBLANK/) {
       print "unlock\n";
       system "weechat_away.sh 0";
       $blanked = 0;
   }
}

