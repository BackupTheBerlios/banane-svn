<HTML> 
<?php
function anchorreplace($original){
  $also=$original;
  $pattern="/(<(A|a)[^>]*>)(.*)(<\/\\2>)/";
  preg_match_all($pattern, $also, $matches, PREG_SET_ORDER);
  foreach ($matches as $val) {
    $search="/(<(A|a)[^>]*>)".$val[3]."/";
    $replace="<A href='".$webpath."Documentation/PHP/viewroutine.php?".$val[3]."'>".$val[3];
    $also = preg_replace($search, $replace, $also);    
  }
  return $also;
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


$rname=($argv[0]);

$querystring= "SELECT * FROM routines WHERE name='".$rname."'";
$routine = mysql_query($querystring,$db); 
$querystring= "SELECT * FROM inputs WHERE name='".$rname."'";
$inputs = mysql_query($querystring,$db); 
$querystring= "SELECT * FROM optinputs WHERE name='".$rname."'";
$optinputs = mysql_query($querystring,$db); 
$querystring= "SELECT * FROM outputs WHERE name='".$rname."'";
$outputs = mysql_query($querystring,$db); 
$rrow = mysql_fetch_array($routine);  
echo "<TABLE>"; 
echo "<TR><TD VALIGN=TOP><B>Name</B>";
echo "<TD VALIGN=TOP>".$rrow["name"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Full path</B>";
echo "<TD VALIGN=TOP>".$rrow["fullpath"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Version</B>";
echo "<TD VALIGN=TOP>".$rrow["version"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Author</B>";
echo "<TD VALIGN=TOP>".$rrow["author"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Date created</B>";
echo "<TD VALIGN=TOP>".$rrow["date"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Aim</B>";
echo "<TD VALIGN=TOP>".$rrow["aim"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Description</B>"; 
echo "<TD VALIGN=TOP>".$rrow["description"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Category</B>"; 
echo "<TD VALIGN=TOP>".$rrow["category"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Syntax</B>"; 
echo "<TD VALIGN=TOP>".$rrow["syntax"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Inputs</B><TD VALIGN=TOP>"; 
echo "<TABLE>";
while($irow = mysql_fetch_array($inputs)) 
{ 
  echo "<TR><TD VALIGN=TOP><VAR>".$irow["argument"].": </VAR>";
  echo "<TD VALIGN=TOP>".$irow["description"];
  echo "</TR>";
 }  
echo "</TABLE>";
echo "</TR>"; 
echo "<TR><TD VALIGN=TOP><B>Optional inputs</B><TD VALIGN=TOP>"; 
echo "<TABLE>";
while($oirow = mysql_fetch_array($optinputs)) 
{ 
  echo "<TR><TD VALIGN=TOP><VAR>".$oirow["argument"].": </VAR>";
  echo "<TD VALIGN=TOP>".$oirow["description"];
  echo "</TR>";
 }  
echo "</TABLE>";
echo "</TR>"; 
echo "<TR><TD VALIGN=TOP><B>Outputs</B><TD VALIGN=TOP>"; 
echo "<TABLE>";
while($orow = mysql_fetch_array($outputs)) 
{ 
  echo "<TR><TD VALIGN=TOP><VAR>".$orow["argument"].": </VAR>";
  echo "<TD VALIGN=TOP>".$orow["description"];
  echo "</TR>";
 }  
echo "</TABLE>";
echo "</TR>";

# skip optional section 'restrictions' if table entry is NULL
if($rrow["restrictions"]!="NULL") 
{ 
  echo "<TR><TD VALIGN=TOP><B>Restrictions</B>"; 
  echo "<TD VALIGN=TOP>".$rrow["restrictions"]."</TR>";
 }
echo "<TR><TD VALIGN=TOP><B>Procedure</B>"; 
echo "<TD VALIGN=TOP>".$rrow["proc"]."</TR>";
echo "<TR><TD VALIGN=TOP><B>Example</B>"; 
echo "<TD VALIGN=TOP>".$rrow["example"]."</TR>";

# skip optional section 'see also' if table entry is NULL
if($rrow["also"]!="NULL") 
{ 
//   $also=$rrow["also"];
//   $pattern="/(<(A|a)[^>]*>)(.*)(<\/\\2>)/";
//   preg_match_all($pattern, $also, $matches, PREG_SET_ORDER);
//   foreach ($matches as $val) {
//     $search="/(<(A|a)[^>]*>)".$val[3]."/";
//     $replace="<A href='".$webpath."Documentation/PHP/viewroutine.php?".$val[3]."'>".$val[3];
//     $also = preg_replace($search, $replace, $also);
//   }
  echo "<TR><TD VALIGN=TOP><B>See also</B>"; 
  echo "<TD VALIGN=TOP>".anchorreplace($rrow["also"])."</TR>";
 }
echo "</TABLE>"; 
?> 
</HTML>