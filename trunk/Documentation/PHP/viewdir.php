<!-- viewdir.php displays the routines in a particular 
banane directory and its subdirectories. it is called from 
viewtree.php. its argument is the relative path to the directory
to be displayed. if it is called without argument, it displays all 
routines in the banane tree. only files contained in the routine
database are show, i.e. only matlab source files. viewdir.php generates
a table with routine name and its short description. the name is made to 
link to viewroutine.php, which displays the complete header. -->

<!-- <HTML> 
<head>
  <title>View contents of banane dierctory</title>
  <link rel="stylesheet" href="bananestyle.css">
</head>

<body>
<DIV class='dynamic'> -->
<?php

function viewdir($dirname);

## needed to call configuration script that knows everything else:
$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";

## get info from config script.
$confscr=$bananepath."Documentation/Scripts/wwwdocu_conf.scr";

$dbscr=$confscr." db";
$allout=`$dbscr`;
$out=explode("\n",$allout);
$dbserver=$out[0];
$dbname=$out[1];
$dbuser=$out[2];
$dbpasswd=$out[3];
$db = mysql_connect($dbserver, $dbuser, $dbpasswd); 
mysql_select_db($dbname,$db);

$webscr=$confscr." web";
$allout=`$webscr`;
$out=explode("\n",$allout);
$webpath=$out[0];

## use the first argument to the script as the directory to display.
#$dirname=($argv[0]);

## select all routines in respective directory and in its subdirs.
## % in database query is the wildcard character.
if (isset($dirname)) {
  $querystring= "SELECT name,aim FROM routines WHERE relativepath LIKE '".$dirname."%'";
 } else {$querystring= "SELECT name,aim FROM routines";}

$routines = mysql_query($querystring,$db); 

## display table with name and aim column. make the name a link to the
## viewroutine script with the routine name as the argument
echo "<H1>Contents of directory <I>\$BANANEPATH/".$dirname."</I></H1>";
echo "<TABLE>";
while($rrow = mysql_fetch_array($routines))
  { $rname=$rrow["name"];
    $anchor=$webpath."Documentation/PHP/viewroutine.php?routine=".$rname;
    echo "<TD VALIGN=TOP><A TARGET='dynamic' HREF='".$anchor."'>".$rname."</A>";
    echo "<TD VALIGN=TOP>".$rrow["aim"]."</TR>";
  }
echo "</TABLE>";
?> 
<!-- </DIV>
</BODY>
</HTML> --> 
