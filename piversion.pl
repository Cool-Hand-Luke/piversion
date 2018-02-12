#!/usr/bin/perl -w

use strict;

my $hardware;
my $revision;
my $serial;

my %pitable = (
  'Beta'   => { 'rd' => 'Q1 2012',  'model' => 'B (Beta)',                    'rev' => '?',   'mem' => '256 MB',          'notes' => 'Beta board' },
  '0002'   => { 'rd' => 'Q1 2012',  'model' => 'B',                           'rev' => '1.0', 'mem' => '256 MB',          'notes' => '' },
  '0003'   => { 'rd' => 'Q3 2012',  'model' => 'B (ECN0001)',                 'rev' => '1.0', 'mem' => '256 MB',          'notes' => 'Fused mod and D14 remove' },
  '0004'   => { 'rd' => 'Q3 2012',  'model' => 'B',                           'rev' => '2.0', 'mem' => '256 MB',          'notes' => 'Manufactued by Sony' },
  '0005'   => { 'rd' => 'Q4 2012',  'model' => 'B',                           'rev' => '2.0', 'mem' => '256 MB',          'notes' => 'Manufactued by Qisda' },
  '0006'   => { 'rd' => 'Q1 2013',  'model' => 'B',                           'rev' => '2.0', 'mem' => '256 MB',          'notes' => 'Manufactued by Egoman' },
  '0007'   => { 'rd' => 'Q1 2013',  'model' => 'A',                           'rev' => '2.0', 'mem' => '256 MB',          'notes' => 'Manufactued by Egoman' },
  '0008'   => { 'rd' => 'Q1 2013',  'model' => 'A',                           'rev' => '2.0', 'mem' => '256 MB',          'notes' => 'Manufactued by Sony' },
  '0009'   => { 'rd' => 'Q1 2013',  'model' => 'A',                           'rev' => '2.0', 'mem' => '256 MB',          'notes' => 'Manufactued by Qisda' },
  '000d'   => { 'rd' => 'Q4 2012',  'model' => 'B',                           'rev' => '2.0', 'mem' => '512 MB',          'notes' => 'Manufactued by Egoman' },
  '000e'   => { 'rd' => 'Q4 2012',  'model' => 'B',                           'rev' => '2.0', 'mem' => '512 MB',          'notes' => 'Manufactued by Sony' },
  '000f'   => { 'rd' => 'Q4 2012',  'model' => 'B',                           'rev' => '2.0', 'mem' => '512 MB',          'notes' => 'Manufactued by Qisda' },
  '0010'   => { 'rd' => 'Q3 2014',  'model' => 'B+',                          'rev' => '1.0', 'mem' => '512 MB',          'notes' => 'Manufactued by Sony' },
  '0011'   => { 'rd' => 'Q2 2014',  'model' => 'Compute Module 1',            'rev' => '1.0', 'mem' => '512 MB',          'notes' => 'Manufactued by Sony' },
  '0012'   => { 'rd' => 'Q4 2014',  'model' => 'A+',                          'rev' => '1.1', 'mem' => '256 MB',          'notes' => 'Manufactued by Sony' },
  '0013'   => { 'rd' => 'Q1 2015',  'model' => 'B+',                          'rev' => '1.2', 'mem' => '512 MB',          'notes' => 'Manufactued by ?' },
  '0014'   => { 'rd' => 'Q2 2014',  'model' => 'Compute Module 1',            'rev' => '1.0', 'mem' => '512 MB',          'notes' => 'Manufactued by Embest' },
  '0015'   => { 'rd' => '?',        'model' => 'A+',                          'rev' => '1.1', 'mem' => '256 MB / 512 MB', 'notes' => 'Manufactued by Embest' },
  'a01040' => { 'rd' => 'unknown',  'model' => '2 Model B',                   'rev' => '1.0', 'mem' => '1 GB',            'notes' => 'Manufactued by Sony' },
  'a01041' => { 'rd' => 'Q1 2015',  'model' => '2 Model B',                   'rev' => '1.1', 'mem' => '1 GB',            'notes' => 'Manufactued by Sony' },
  'a21041' => { 'rd' => 'Q1 2015',  'model' => '2 Model B',                   'rev' => '1.1', 'mem' => '1 GB',            'notes' => 'Manufactued by Embest' },
  'a22042' => { 'rd' => 'Q3 2016',  'model' => '2 Model B (with BCM2837)',    'rev' => '1.2', 'mem' => '1 GB',            'notes' => 'Manufactued by Embest' },
  '900021' => { 'rd' => 'Q3 2016',  'model' => 'A+',                          'rev' => '1.1', 'mem' => '512 MB',          'notes' => 'Manufactued by Sony' },
  '900032' => { 'rd' => 'Q2 2016?', 'model' => 'B+',                          'rev' => '1.2', 'mem' => '512 MB',          'notes' => 'Manufactued by Sony' },
  '900092' => { 'rd' => 'Q4 2015',  'model' => 'Zero',                        'rev' => '1.2', 'mem' => '512 MB',          'notes' => 'Manufactued by Sony' },
  '900093' => { 'rd' => 'Q4 2016',  'model' => 'Zero',                        'rev' => '1.3', 'mem' => '512 MB',          'notes' => 'Manufactued by Sony' },
  '920093' => { 'rd' => 'Q4 2016?', 'model' => 'Zero',                        'rev' => '1.3', 'mem' => '512 MB',          'notes' => 'Manufactued by Embest' },
  '9000c1' => { 'rd' => 'Q1 2017',  'model' => 'Zero W',                      'rev' => '1.1', 'mem' => '512 MB',          'notes' => 'Manufactued by Sony' },
  'a02082' => { 'rd' => 'Q1 2016',  'model' => '3 Model B',                   'rev' => '1.2', 'mem' => '1 GB',            'notes' => 'Manufactued by Sony' },
  'a020a0' => { 'rd' => 'Q1 2017',  'model' => 'Compute Module 3 & CM3 Lite', 'rev' => '1.0', 'mem' => '1 GB',            'notes' => 'Manufactued by Sony' },
  'a22082' => { 'rd' => 'Q1 2016',  'model' => '3 Model B',                   'rev' => '1.2', 'mem' => '1 GB',            'notes' => 'Manufactued by Embest' },
  'a32082' => { 'rd' => 'Q4 2016',  'model' => '3 Model B',                   'rev' => '1.2', 'mem' => '1 GB',            'notes' => 'Manufactued by Sony' },
);

# Get info about our Pi
open INP, "/proc/cpuinfo";
while (<INP>)
{
  if ( /Hardware\s+:\s+(.*)/ )
  {
    $hardware = $1;
  }
  elsif ( /Revision\s+:\s+(.*)/ )
  {
    $revision = $1;
  }
  elsif ( /Serial\s+:\s+(.*)/ )
  {
    $serial = $1;
  }
}
close INP;

my %board = %{$pitable{$revision}};

printf "%15s: %s\n%15s: %s\n%15s: %s\n%15s: %s\n%15s: %s\n%15s: %s\n",
  "Revision", $revision, "Release Date", $board{'rd'},
  "Model", $board{'model'}, "PCB Revision", $board{'rev'},
  "Memory", $board{'mem'}, "Notes", $board{'notes'};
