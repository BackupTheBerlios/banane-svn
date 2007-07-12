#!/usr/bin/perl -w

$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";
#$bananepath="/home/athiel/MATLAB/Sources/Banane/";

# path in lib must be known at compile time, therefore, no 
# concatenation with $bananepath is possible and it is 
# given here explicitely
use lib "/home/groups/banane/htdocs/wwwcopy/Banane/Documentation/Perl/";
#use lib "/home/athiel/MATLAB/Sources/Banane/Documentation/Perl/";
# use strict;
use DBI;
use parseupdate;
use parseheader;
use File::Find;

print "Are you sure? ";

chomp ( $answer = <> );

if ($answer =~ /(Y|y)es/ || $answer =~ /(Y|y)/ ) {

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

  my $hdl_drop_support = $dbh->prepare_cached("DROP TABLE inputs, outputs, optinputs");
  die "Couldn't prepare query; aborting"
    unless defined $hdl_drop_support;

  my $hdl_drop_routines = $dbh->prepare_cached("DROP TABLE routines");
  die "Couldn't prepare query; aborting"
    unless defined $hdl_drop_routines;


  print "Dropping tables.\n";

  my $success = 1;
  $success &&= $hdl_drop_support->execute();
  
  my $success = 1;
  $success &&= $hdl_drop_routines->execute();


  my $hdl_init_routines = $dbh->prepare_cached("CREATE TABLE routines (
   name VARCHAR(128), 
   fullpath VARCHAR(128), 
   relativepath VARCHAR(128), 
   version VARCHAR(128), 
   author VARCHAR(128), 
   date VARCHAR(128), 
   aim VARCHAR(128), 
   description VARCHAR(1024), 
   category VARCHAR(512), 
   syntax VARCHAR(1024), 
   restrictions VARCHAR(512), 
   proc VARCHAR(512), 
   example VARCHAR(1024), 
   also VARCHAR(128), PRIMARY KEY(name))");
  die "Couldn't prepare query; aborting"
    unless defined $hdl_init_routines;

  my $hdl_init_in = $dbh->prepare_cached("CREATE TABLE inputs (name VARCHAR(128), count TINYINT UNSIGNED, argument VARCHAR(128),description VARCHAR(1024))");
  die "Couldn't prepare query; aborting"
    unless defined $hdl_init_in;

  my $hdl_init_optin = $dbh->prepare_cached("CREATE TABLE optinputs (name VARCHAR(128), count TINYINT UNSIGNED, argument VARCHAR(128),description VARCHAR(1024))");
  die "Couldn't prepare query; aborting"
    unless defined $hdl_init_optin;

  my $hdl_init_out = $dbh->prepare_cached("CREATE TABLE outputs (name VARCHAR(128), count TINYINT UNSIGNED, argument VARCHAR(128),description VARCHAR(1024))");
  die "Couldn't prepare query; aborting"
    unless defined $hdl_init_out;

  print "Initializing tables.\n";

  my $success = 1;
  $success &&= $hdl_init_routines->execute();
  my $success = 1;
  $success &&= $hdl_init_in->execute();
  my $success = 1;
  $success &&= $hdl_init_optin->execute();
  my $success = 1;
  $success &&= $hdl_init_out->execute();

  $routines_replacehandle = $dbh->prepare_cached("REPLACE INTO routines (name,fullpath,relativepath,version,author,date,aim,description,category,syntax,restrictions,proc,example,also) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
  die "Couldn't prepare query; aborting"
    unless defined $routines_replacehandle;

  $inputs_replacehandle = $dbh->prepare_cached("INSERT INTO inputs (name,count,argument,description) VALUES (?,?,?,?)");
  die "Couldn't prepare query; aborting"
    unless defined $inputs_replacehandle;

  $optinputs_replacehandle = $dbh->prepare_cached("INSERT INTO optinputs (name,count,argument,description) VALUES (?,?,?,?)");
  die "Couldn't prepare query; aborting"
    unless defined $optinputs_replacehandle;

  $outputs_replacehandle = $dbh->prepare_cached("INSERT INTO outputs (name,count,argument,description) VALUES (?,?,?,?)");
  die "Couldn't prepare query; aborting"
    unless defined $outputs_replacehandle;

  print "Filling tables.\n";

  find(
       sub 
       {
	 $filename=$File::Find::name;
	 
	 if ($filename =~ m/\.m$/) {
	   print"Processing file: $filename\n";
	   
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
	   
	   ## There may be multiple inputs, thus use loop here
	   ## count is needed to ensure correct order when arguments are 
	   ## displayed later
	   $count = 1;
	   foreach (@{$head{inputs}->[0]}) {
	     my($arg)=$_->[0];
	     my($desc)=$_->[1];
	     my $success = 1;
	     $success &&= $inputs_replacehandle->execute($head{name},$count,$arg,$desc);
	     $count++;
	   }

	   $count = 1;
	   foreach (@{$head{optinputs}->[0]}) {
	     my($arg)=$_->[0];
	     my($desc)=$_->[1];
	     my $success = 1;
	     $success &&= $optinputs_replacehandle->execute($head{name},$count,$arg,$desc);
	     $count++;
	   }

	   $count = 1;
	   foreach (@{$head{outputs}->[0]}) {
	     my($arg)=$_->[0];
	     my($desc)=$_->[1];
	     my $success = 1;
	     $success &&= $outputs_replacehandle->execute($head{name},$count,$arg,$desc);
	     $count++;
	   }
	 }
	 
       } ### end of find subroutine
       , $bananepath);
  
  
  #### Now, disconnect from the database
  $dbh->disconnect
    or warn "Disconnection failed: $DBI::errstr\n";

  print "Updating directory tree information.\n";
  system("updatetree") == 0
	 or die "updatetree failed: $?"

  print "Reset finished.\n";

} ## end of "are you sure?"
