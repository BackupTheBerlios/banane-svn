<HTML> 
<head>
  <title>View banane routine</title>
  <link rel="stylesheet" href="bananestyle.css">
</head>

<body>
<DIV class='dynamic'>  

<?php

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

#echo "argv: ".$argv[0]."<BR>";

#$argplusval = explode("=", $argv[0]);
$rname=$_GET["routine"];
#echo "GET: ".$_GET["routine"];

$querystring= "SELECT * FROM routines WHERE name LIKE '%".$rname."%'";
$routines = mysql_query($querystring,$db); 
$num_rows = mysql_num_rows($routines);

# echo "$num_rows Rows\n";

switch ($num_rows) {
 case 0:
   echo "No matches found.";
   break;
 case 1:
   $row = mysql_fetch_array($routines);
   $exactname = $row["name"];
#   echo $exactname."<BR>";
   $anchor=$webpath."Documentation/PHP/viewroutine.php?routine=".$exactname;
#   echo $anchor."<BR>";
   include $anchor;
   break;
 default:
   echo "<H1>Search results<H1>";
   echo "<TABLE>";
   while($row = mysql_fetch_array($routines))
     { $rname=$row["name"];
       $anchor=$webpath."Documentation/PHP/viewroutine.php?routine=".$rname;
       echo "<TD VALIGN=TOP><A TARGET='dynamic' HREF='".$anchor."'>".$rname."</A>";
       echo "<TD VALIGN=TOP>".$row["aim"]."</TR>";
     }
   echo "</TABLE>";
}
?>
</DIV>
</BODY>
