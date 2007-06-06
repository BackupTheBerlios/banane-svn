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
<DIV class='dynamic'>  

<?php

## support function to search simplified anchors <A>routine</A> 
## and replace them with with proper hyperrefs
function anchorreplace($original,$path){
#  $pattern="/(<(A|a)[^>]*>)(.*)(<\/\\2>)/";
#  $pattern="/(<(A|a)[^>])/";
  $pattern="/(<([\w]+)[^>]*>)([^\/])(<\/\\2>)/";
  preg_match_all($pattern, $original, $matches, PREG_SET_ORDER);
#  echo "matches: ";
  print_r($matches);
  foreach ($matches as $val) {
    echo "matched: " . $val[0] . "\n";
    echo "part 1: " . $val[1] . "\n";
    echo "part 2: " . $val[3] . "\n";
    echo "part 3: " . $val[4] . "\n\n";
    $search="/(<(A|a)[^>]*>)".$val[3]."/";
#    echo "search: ".$search."\n";
    $replace="<A href='".$path."Documentation/PHP/viewroutine.php?routine=".$val[3]."'>".$val[3];
    $original = preg_replace($search, $replace, $original); 
##    $echo "original: ".$original."\n";
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
echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Name</SPAN>";
echo "<TD VALIGN=TOP>".$rrow["name"]."</TR>";
echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Path</SPAN>";
echo "<TD VALIGN=TOP>\$BANANEPATH/".$rrow["relativepath"]."</TR>";
echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Version</SPAN>";
echo "<TD VALIGN=TOP>".$rrow["version"]."</TR>";
echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Author</SPAN>";
echo "<TD VALIGN=TOP>".$rrow["author"]."</TR>";
echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Date created</SPAN>";
echo "<TD VALIGN=TOP>".$rrow["date"]."</TR>";
echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Aim</SPAN>";
echo "<TD VALIGN=TOP>".$rrow["aim"]."</TR>";
echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Description</SPAN>"; 
echo "<TD VALIGN=TOP>".anchorreplace($rrow["description"],$webpath)."</TR>";
echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Category</SPAN>"; 
echo "<TD VALIGN=TOP>".$rrow["category"]."</TR>";
echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Syntax</SPAN>"; 
echo "<TD VALIGN=TOP>".$rrow["syntax"]."</TR>";

echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Inputs</SPAN><TD VALIGN=TOP>";echo "<TABLE>";
while($irow = mysql_fetch_array($inputs)) 
{ 
  echo "<TR><TD VALIGN=TOP><VAR>".$irow["argument"].": </VAR>";
  echo "<TD VALIGN=TOP>".anchorreplace($irow["description"],$webpath);
  echo "</TR>";
 }  
echo "</TABLE>";
echo "</TR>"; 

# fetch first entry of optional section 'optinputs'.
# skip whole table entry if result is NULL.
# otherwise, enter subtable and display all optinputs in 
# a separate subtable. do-while is needed since the first 
# entry is already read by initial while loop.
while($oirow = mysql_fetch_array($optinputs)) 
  { 
    echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Optional inputs</SPAN><TD VALIGN=TOP>"; 
    echo "<TABLE>";
    do { 
      echo "<TR><TD VALIGN=TOP><VAR>".$oirow["argument"].": </VAR>";
      echo "<TD VALIGN=TOP>".anchorreplace($oirow["description"],$webpath);
      echo "</TR>";
    } while($oirow = mysql_fetch_array($optinputs));   
    echo "</TABLE>";
    echo "</TR>";
  }
 
echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Outputs</SPAN><TD VALIGN=TOP>"; 
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
  echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Restrictions</SPAN>"; 
  echo "<TD VALIGN=TOP>".anchorreplace($rrow["restrictions"],$webpath)."</TR>";
 }

echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Procedure</SPAN>"; 
echo "<TD VALIGN=TOP>".anchorreplace($rrow["proc"],$webpath)."</TR>";
echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>Example</SPAN>"; 
echo "<TD VALIGN=TOP>".anchorreplace($rrow["example"],$webpath)."</TR>";

# skip optional section 'see also' if table entry is NULL
if($rrow["also"]!="NULL") 
{ 
  echo "<TR><TD VALIGN=TOP><SPAN class='head'><SEC>See also</SPAN>"; 
  echo "<TD VALIGN=TOP>".anchorreplace($rrow["also"],$webpath)."</TR>";
 }
echo "</TABLE>";
?> 

</DIV>
<body>


</HTML>