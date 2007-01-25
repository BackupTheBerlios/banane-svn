#!/usr/bin/perl -w

$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";
#$bananepath="/home/athiel/MATLAB/Sources/Banane/";

# path in lib must be known at compile time, therefore, no 
# concatenation with $bananepath ist possible and it is 
# given here explicitely
use lib "/home/groups/banane/htdocs/wwwcopy/Banane/Documentation/Perl/";
#use lib "/home/athiel/MATLAB/Sources/Banane/Documentation/Perl/";
# use strict;
use DBI;
use parseupdate;
use parseheader;

# gather standard input, ie output of svn update, in variable $in
$in=join'',<>;

# parse lines of svn update and extract the filenames of 
# routines that have been modified
$file=parseupdate::parse($in);

print "Successfully parsed filenames.\n" if $file->[0];
#print "$result->[0]->[1]\n";#"$result\n";
#print "$value[3]->[0]\n";
#print"$value->[3]->[3]->[1]\n";


if ($file->[0]) {

  # get info about mysql database from the config script
  $conscr=$bananepath."Documentation/Scripts/wwwdocu_conf.scr db";
  $allout=`$conscr`;
  @out=split("\n",$allout);
  $dbserver=$out[0];
  $dbname=$out[1];
  $dbuser=$out[2];
  $dbpasswd=$out[3];

  $dsn="DBI:mysql:".$dbname.":".$dbserver;

  my $dbh = DBI->connect($dsn, $dbuser, $dbpasswd)
    or die "Couldn't connect to database: " . DBI->errstr;

  # prepare databse querys
  my $routines_replacehandle = $dbh->prepare_cached("REPLACE INTO routines (name,fullpath,relativepath,version,author,date,aim,description,category,syntax,restrictions,proc,example,also) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
  die "Couldn't prepare query; aborting"
    unless defined $routines_replacehandle;

  my $inputs_removehandle = $dbh->prepare_cached("DELETE FROM inputs WHERE name=\"?\")");
  die "Couldn't prepare query; aborting"
    unless defined $inputs_removehandle;

  my $inputs_replacehandle = $dbh->prepare_cached("INSERT INTO inputs (name,argument,description) VALUES (?,?,?)");
  die "Couldn't prepare query; aborting"
    unless defined $inputs_replacehandle;

  my $optinputs_replacehandle = $dbh->prepare_cached("REPLACE INTO optinputs (name,argument,description) VALUES (?,?,?)");
  die "Couldn't prepare query; aborting"
    unless defined $optinputs_replacehandle;

  my $outputs_replacehandle = $dbh->prepare_cached("REPLACE INTO outputs (name,argument,description) VALUES (?,?,?)");
  die "Couldn't prepare query; aborting"
    unless defined $outputs_replacehandle;


  foreach (@{$file}) {

    # read complete file
    $filename=$_->[1];
    print "Processing: $filename\n";

    $relpath=$filename;
    $relpath=~s/$bananepath//;

    open(DAT, $filename) || die("Could not open file!");
    $rawdata=join'',<DAT>;
    close(DAT);

    # parse file text
    %head=parseheader::parse($rawdata);

    # insert header information into the database tables "routines", 
    # "inputs", "optinputs" and "outputs" 
    my $success = 1;
    $success &&= $routines_replacehandle->execute($head{name},$filename,$relpath,$head{version},$head{author},$head{date},$head{aim},$head{description},$head{category},$head{syntax},$head{restrictions},$head{proc},$head{example},$head{also});

    my $success = 1;
    $success &&= $inputs_removehandle->execute($head{name});

    # There may be multiple inputs, thus use loop here
    foreach (@{$head{inputs}->[0]}) {
      my($arg)=$_->[0];
      my($desc)=$_->[1];
      # print "$arg :: $desc\n";
      my $success = 1;
      $success &&= $inputs_replacehandle->execute($head{name},$arg,$desc);
    }

    foreach (@{$head{optinputs}->[0]}) {
      my($arg)=$_->[0];
      my($desc)=$_->[1];
      #      print "$arg :: $desc\n";
      my $success = 1;
      $success &&= $optinputs_replacehandle->execute($head{name},$arg,$desc);
    }

    foreach (@{$head{outputs}->[0]}) {
      my($arg)=$_->[0];
      my($desc)=$_->[1];
#      print "$arg :: $desc\n";
      my $success = 1;
      $success &&= $outputs_replacehandle->execute($head{name},$arg,$desc);
    }

  }

  #### Now, disconnect from the database
  $dbh->disconnect
    or warn "Disconnection failed: $DBI::errstr\n";

}

else

  # parsing of filenames failed
  {print "Nothing to be done.\n";}
