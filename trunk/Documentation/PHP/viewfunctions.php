<?php
# viewfunctions.php
# $Id$
#
# a collection of multiple PHP functions that return strings
# which are used by the mainpage to display the
# website contents.



#####
## support function to search simplified anchors <A>routine</A> 
## and replace them with with proper hyperrefs
## to resolve ambiguous filenames, the routine uses the same 
## mechanism that also displays the results of a search for
## a routine name, ie display a list of matches or in case of a single
## match (which sould happen most of the time) display the header directly
function anchorreplace($original,$path)
{
  $pattern="/(<(A|a)[^>]*>)(.*)(<\/\\2>)/U";
  preg_match_all($pattern, $original, $matches, PREG_SET_ORDER);
  foreach ($matches as $val) {
    $search="/(<(A|a)[^>]*>)".$val[3]."/";
    $replace="<A href='?search=".$val[3]."'>".$val[3];
    $original = preg_replace($search, $replace, $original); 
  }
  return $original;
}
##### 




#####
## support function 
function nameaimtable($routines)
{
  $outstr="<TABLE>";
  while($row = mysql_fetch_array($routines))
    { $rname=$row["name"];
      if (!empty($rname)) {
	$fullname=$row["fullpath"];
	$anchor="?Page=".$page."&routine=".$fullname;
	$outstr.="<TR>";
	$outstr.="<TD class='left' VALIGN=TOP><A HREF='".$anchor."'>".$rname."</A>";
	$outstr.="<TD VALIGN=TOP>".anchorreplace($row["aim"],$webpath);
	$outstr.="</TR>";
      }
    }
  $outstr.="</TABLE>";
  return $outstr;
}




##### displays table with routines in given directory
function viewdir($myqsl,$page,$dirname)
{

  ## needed to call configuration script that knows everything else:
  $bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";

  ## get info from config script.
  $confscr=$bananepath."Documentation/Scripts/wwwdocu_conf.scr";

  $db = mysql_connect($myqsl["Server"], $myqsl["User"], $myqsl["Pass"]); 
  mysql_select_db($myqsl["DB"],$db);

  $webscr=$confscr." web";
  $allout=`$webscr`;
  $out=explode("\n",$allout);
  $webpath=$out[0];

  ## select all routines in respective directory and in its subdirs.
  ## % in database query is the wildcard character.
  if (isset($dirname)) {
    $querystring= "SELECT name,fullpath,aim FROM routines WHERE relativepath LIKE '".$dirname."%'";
  } else {$querystring= "SELECT name,fullpath,aim FROM routines";}

  $routines = mysql_query($querystring,$db); 

  ## display table with name and aim column. make the name a link to the
  ## viewroutine script with the routine name as the argument
  $output="";
  $output.="<H1>contents of <I>\$BANANEPATH/".$dirname."</I></H1>";
  $output.=nameaimtable($routines);

  return $output;
}
#####



##### displays search results, either a list of matches
##### with the same style as viewdir.php or a single
##### routine by diretcly calling viewroutine.php
function viewsearch($myqsl,$rname)
{
$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";

## get info from config script.
$confscr=$bananepath."Documentation/Scripts/wwwdocu_conf.scr";

$db = mysql_connect($myqsl["Server"], $myqsl["User"], $myqsl["Pass"]); 
mysql_select_db($myqsl["DB"],$db);

$webscr=$confscr." web";
$allout=`$webscr`;
$out=explode("\n",$allout);
$webpath=$out[0];

$querystring= "SELECT * FROM routines WHERE name LIKE '%".$rname."%'";
$routines = mysql_query($querystring,$db); 
$num_rows = mysql_num_rows($routines);

$output="";

switch ($num_rows) {
 case 0:
   $output.="No matches found.";
   break;
 case 1:
   $row = mysql_fetch_array($routines);
   $exactname = $row["fullpath"];
   $output.=viewroutine($myqsl,$exactname);
   break;
 default:
   $output.="<H1>search results</H1>";
   $output.=nameaimtable($routines);
}

 return $output;

}
#####



##### displays header info for given routine as a table
function viewroutine($myqsl,$rname)
{

$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";

## get info from config script.
$confscr=$bananepath."Documentation/Scripts/wwwdocu_conf.scr";

 $db = mysql_connect($myqsl["Server"], $myqsl["User"], $myqsl["Pass"]); 
 mysql_select_db($myqsl["DB"],$db);

$webscr=$confscr." web";
$allout=`$webscr`;
$out=explode("\n",$allout);
$webpath=$out[0];

$querystring= "SELECT * FROM routines WHERE fullpath='".$rname."'";
$routine = mysql_query($querystring,$db); 
$querystring= "SELECT * FROM inputs WHERE fullpath='".$rname."' ORDER BY count";
$inputs = mysql_query($querystring,$db); 
$querystring= "SELECT * FROM optinputs WHERE fullpath='".$rname."' ORDER BY count";
$optinputs = mysql_query($querystring,$db); 
$querystring= "SELECT * FROM outputs WHERE fullpath='".$rname."' ORDER BY count";
$outputs = mysql_query($querystring,$db); 
$rrow = mysql_fetch_array($routine);

$output="";

$output.="<TABLE>"; 
$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Name</SPAN>";
$output.="<TD VALIGN=TOP>".$rrow["name"]."</TR>";
$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Path</SPAN>";
$output.="<TD VALIGN=TOP>\$BANANEPATH/".$rrow["relativepath"]."</TR>";
$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Version</SPAN>";
$output.="<TD VALIGN=TOP>".$rrow["version"]."</TR>";
$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Author</SPAN>";
$output.="<TD VALIGN=TOP>".$rrow["author"]."</TR>";
$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Date&nbsp;created</SPAN>";
$output.="<TD VALIGN=TOP>".$rrow["date"]."</TR>";
$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Aim</SPAN>";
$output.="<TD VALIGN=TOP>".anchorreplace($rrow["aim"],$webpath)."</TR>";
$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Description</SPAN>"; 
$output.="<TD VALIGN=TOP>".anchorreplace($rrow["description"],$webpath)."</TR>";
$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Category</SPAN>"; 
$output.="<TD VALIGN=TOP>".$rrow["category"]."</TR>";
$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Syntax</SPAN>"; 
$output.="<TD VALIGN=TOP>".$rrow["syntax"]."</TR>";

# fetch first entry of optional section 'inputs'.
# skip whole table entry if result is NULL.
# otherwise, enter subtable and display all optinputs in 
# a separate subtable. do-while is needed since the first 
# entry is already read by initial while loop.
while($irow = mysql_fetch_array($inputs)) 
  { 
    $output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Inputs</SPAN><TD VALIGN=TOP>";
    $output.="<TABLE>";
    do { 
      $output.="<TR><TD class='left' VALIGN=TOP><VAR>".$irow["argument"].": </VAR>";
      $output.="<TD VALIGN=TOP>".anchorreplace($irow["description"],$webpath);
      $output.="</TR>";
    } while($irow = mysql_fetch_array($inputs)); 
      $output.="</TABLE>";
    $output.="</TR>"; 
  }

# fetch first entry of optional section 'optinputs'.
# skip whole table entry if result is NULL.
# otherwise, enter subtable and display all optinputs in 
# a separate subtable. do-while is needed since the first 
# entry is already read by initial while loop.
while($oirow = mysql_fetch_array($optinputs)) 
  { 
    $output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Optional&nbsp;inputs</SPAN><TD VALIGN=TOP>"; 
    $output.="<TABLE>";
    do { 
      $output.="<TR><TD class='left' VALIGN=TOP><VAR>".$oirow["argument"].": </VAR>";
      $output.="<TD VALIGN=TOP>".anchorreplace($oirow["description"],$webpath);
      $output.="</TR>";
    } while($oirow = mysql_fetch_array($optinputs));   
    $output.="</TABLE>";
    $output.="</TR>";
  }
 
$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Outputs</SPAN><TD VALIGN=TOP>"; 
$output.="<TABLE>";
while($orow = mysql_fetch_array($outputs)) 
{ 
  $output.="<TR><TD class='left' VALIGN=TOP><VAR>".$orow["argument"].": </VAR>";
  $output.="<TD VALIGN=TOP>".anchorreplace($orow["description"],$webpath);
  $output.="</TR>";
 }  
$output.="</TABLE>";
$output.="</TR>";

# skip optional section 'restrictions' if table entry is NULL
if($rrow["restrictions"]!="NULL") 
{ 
  $output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Restrictions</SPAN>"; 
  $output.="<TD VALIGN=TOP>".anchorreplace($rrow["restrictions"],$webpath)."</TR>";
 }

$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Procedure</SPAN>"; 
$output.="<TD VALIGN=TOP>".anchorreplace($rrow["proc"],$webpath)."</TR>";
$output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>Example</SPAN>"; 
$output.="<TD VALIGN=TOP>".anchorreplace($rrow["example"],$webpath)."</TR>";

# skip optional section 'see also' if table entry is NULL
if($rrow["also"]!="NULL") 
{ 
  $output.="<TR><TD class='left' VALIGN=TOP><SPAN class='head'><SEC>See&nbsp;also</SPAN>"; 
  $output.="<TD VALIGN=TOP>".anchorreplace($rrow["also"],$webpath)."</TR>";
 }
$output.="</TABLE>";

 return $output;
}

?>