<!-- viewroutine.php displays the information 
contained in a routines header in a table. it obtains its 
information from the routines database. argument passing is
possible in the form viewroutine.php?routine=foobar. viewroutine
will then search the database for a routine named foobar and will 
display its header information in a formatted manner. -->

<HTML> 
<head>
  <title>View banane routine</title>
  <link rel="stylesheet" href="bananestyle.css">
</head>

<body>
<?php

## support function to search simplified anchors <A>routine</A> 
## and replace them with with proper hyperrefs
function anchorreplace($original,$path){
  $pattern="/(<(A|a)[^>]*>)(.*)(<\/\\2>)/";
  preg_match_all($pattern, $original, $matches, PREG_SET_ORDER);
  foreach ($matches as $val) {
    $search="/(<(A|a)[^>]*>)".$val[3]."/";
    $replace="<A href='".$path."Documentation/PHP/viewroutine.php?routine=".$val[3]."'>".$val[3];
    $original = preg_replace($search, $replace, $original);    
  }
  return $original;
}


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

$querystring= "SELECT * FROM routines WHERE name='".$rname."'";
$routine = mysql_query($querystring,$db); 
$querystring= "SELECT * FROM inputs WHERE name='".$rname."' ORDER BY count";
$inputs = mysql_query($querystring,$db); 
$querystring= "SELECT * FROM optinputs WHERE name='".$rname."' ORDER BY count";
$optinputs = mysql_query($querystring,$db); 
$querystring= "SELECT * FROM outputs WHERE name='".$rname."' ORDER BY count";
$outputs = mysql_query($querystring,$db); 
$rrow = mysql_fetch_array($routine);  
echo "<TABLE>"; 
#echo "<TR><TD VALIGN=TOP><SPAN class="header">Name</SPAN>";
echo "<TR><TD VALIGN=TOP>Name";
echo "<TD VALIGN=TOP>".$rrow["name"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Path</B>";
echo "<TD VALIGN=TOP>\$BANANEPATH/".$rrow["relativepath"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Version</B>";
echo "<TD VALIGN=TOP>".$rrow["version"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Author</B>";
echo "<TD VALIGN=TOP>".$rrow["author"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Date created</B>";
echo "<TD VALIGN=TOP>".$rrow["date"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Aim</B>";
echo "<TD VALIGN=TOP>".$rrow["aim"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Description</B>"; 
echo "<TD VALIGN=TOP>".anchorreplace($rrow["description"],$webpath)."</TR>";
echo "<TR><TD VALIGN=TOP><B>Category</B>"; 
echo "<TD VALIGN=TOP>".$rrow["category"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Syntax</B>"; 
echo "<TD VALIGN=TOP>".$rrow["syntax"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Inputs</B><TD VALIGN=TOP>"; 
echo "<TABLE>";
while($irow = mysql_fetch_array($inputs)) 
{ 
  echo "<TR><TD VALIGN=TOP><VAR>".$irow["argument"].": </VAR>";
  echo "<TD VALIGN=TOP>".anchorreplace($irow["description"],$webpath);
  echo "</TR>";
 }  
echo "</TABLE>";
echo "</TR>"; 
echo "<TR><TD VALIGN=TOP><B>Optional inputs</B><TD VALIGN=TOP>"; 
echo "<TABLE>";
while($oirow = mysql_fetch_array($optinputs)) 
{ 
  echo "<TR><TD VALIGN=TOP><VAR>".$oirow["argument"].": </VAR>";
  echo "<TD VALIGN=TOP>".anchorreplace($oirow["description"],$webpath);
  echo "</TR>";
 }  
echo "</TABLE>";
echo "</TR>"; 
echo "<TR><TD VALIGN=TOP><B>Outputs</B><TD VALIGN=TOP>"; 
echo "<TABLE>";
while($orow = mysql_fetch_array($outputs)) 
{ 
  echo "<TR><TD VALIGN=TOP><VAR>".$orow["argument"].": </VAR>";
  echo "<TD VALIGN=TOP>".anchorreplace($orow["description"],$webpath);
  echo "</TR>";
 }  
echo "</TABLE>";
echo "</TR>";

# skip optional section 'restrictions' if table entry is NULL
if($rrow["restrictions"]!="NULL") 
{ 
  echo "<TR><TD VALIGN=TOP><B>Restrictions</B>"; 
  echo "<TD VALIGN=TOP>".anchorreplace($rrow["restrictions"],$webpath)."</TR>";
 }
echo "<TR><TD VALIGN=TOP><B>Procedure</B>"; 
echo "<TD VALIGN=TOP>".anchorreplace($rrow["proc"],$webpath)."</TR>";
echo "<TR><TD VALIGN=TOP><B>Example</B>"; 
echo "<TD VALIGN=TOP>".anchorreplace($rrow["example"],$webpath)."</TR>";

# skip optional section 'see also' if table entry is NULL
if($rrow["also"]!="NULL") 
{ 
  echo "<TR><TD VALIGN=TOP><B>See also</B>"; 
  echo "<TD VALIGN=TOP>".anchorreplace($rrow["also"],$webpath)."</TR>";
 }
echo "</TABLE>"; 
?> 

<body>


</HTML>