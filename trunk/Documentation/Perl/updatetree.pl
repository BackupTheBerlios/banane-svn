### this script reads the Banane directory structure and 
### updates the database table that is used to display the 
### folders on the web page



#!/usr/bin/perl -w

$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";
#$bananepath="/home/athiel/MATLAB/Sources/Banane/";

# path in lib must be known at compile time, therefore, no 
# concatenation with $bananepath ist possible and it is 
# given here explicitely
use lib "/home/groups/banane/htdocs/wwwcopy/Banane/Documentation/Perl/";
#use lib "/home/athiel/MATLAB/Sources/Banane/Documentation/Perl/";

use DBI;

use get_leaf_dirs;

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

my $hdl_drop_treetable = $dbh->prepare_cached("DROP TABLE IF EXISTS dirtreetable");
die "Couldn't prepare query; aborting"
  unless defined $hdl_drop_treetable;

# print "Dropping table.\n";

my $success = 1;
$success &&= $hdl_drop_treetable->execute();

my $hdl_init_treetable = $dbh->prepare_cached("CREATE TABLE IF NOT EXISTS dirtreetable (
ID bigint(20) NOT NULL auto_increment,
Name varchar(255) NOT NULL default '', 
Description text NOT NULL, 
CreateUser bigint(20) NOT NULL default '0',
CreateDate datetime NOT NULL default '0000-00-00 00:00:00',
ModifyDate datetime NOT NULL default '0000-00-00 00:00:00',
LastVisit datetime NOT NULL default '0000-00-00 00:00:00',
Parent bigint(20) NOT NULL default '0',
PublicUse tinyint(1) NOT NULL default '0', PRIMARY KEY (ID))");

die "Couldn't prepare query; aborting"
  unless defined $hdl_init_treetable;

# print "Initializing dir tree table.\n";

$success = 1;
$success &&= $hdl_init_treetable->execute();

my  $CreateUser=""; 
my  $CreateDate=""; 
my  $ModifyDate=""; 
my  $LastVisit=""; 
my  $PublicUse=0;

$tree_inserthandle = $dbh->prepare_cached("INSERT INTO dirtreetable (ID,Name,Description,CreateUser,CreateDate,ModifyDate,LastVisit,Parent,PublicUse) VALUES (?,?,?,?,?,?,?,?,?)");
die "Couldn't prepare query; aborting"
  unless defined $tree_inserthandle;


my(@res)=get_leaf_dirs($bananepath,"Banane",$bananepath);
  
my($i)=0;

my(%allmums)=();

foreach my $entry (@res){

    my($name)=$entry->{"name"};
    my($mum)=$entry->{"mother"};
    my($Description)=$entry->{"relpath"};

    if (!exists $allmums{$mum}){$allmums{$mum}=$i;}

    $parcat=$allmums{$mum};

    $success = 1;
    $success &&= $tree_inserthandle->execute(NULL,$name,$Description,$CreateUser,$CreateDate,$ModifyDate,$LastVisit,$parcat,$PublicUse); 

    $i++;

  };

print "Created Tree with ".$i." entries\n";


#### Now, disconnect from the database
$dbh->disconnect
  or warn "Disconnection failed: $DBI::errstr\n";
