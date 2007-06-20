<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Strict//EN">

<html>
<head>
<meta http-equiv="content-type" content="text/html;charset=ISO-8859-1">
<title>webpage of the banane project</title>

<style type="text/css" media="screen">

body {
   text-align: center;
   background: #e6e7e9;
   color: #737373;
   font-family: helvetica, arial, sans-serif;
   font-size: 9pt;
}

a:link, a:visited, a:active {
  text-decoration: none ;
  color: #737373;
}
a:hover {
  text-decoration: underline; 
  color: #737373;
}

div.content {
 position: relative;
 top:22px;
 width:823px;
 height:704px;
 margin:0 auto;
  text-align:left;
  background-image:url('Pics/frame.gif');
    background-repeat:no-repeat;
}

div.content h1 {
  font-size:100%;  
  font-weight:bold;
}


a#linkhome {
 position: absolute;
 top: 36px;
 left: 41px;
 height: 44px;
 width: 162px;
}


div.headline {
 position: absolute;
 top: 121px;
 left: 204px;
 bottom: 560px;
 right: 274px;
 padding: 0px;
  text-align:left;
  word-spacing:1.2em; 
  font-weight:bold; 
}

div.search {
 position: absolute;
 top: 118px;
 left: 618px;
 bottom: 560px;
 right: 69px;
 padding: 0px;
  text-align:right;
  font-weight:bold;
}

.search input
{
color: black;
background: #f9f9f9;
border: 1px solid #5c5c5c;
width:75px;
padding: 0px;
  vertical-align: baseline;
}


div.navigation_head {
 position: absolute;
 top: 121px;
 left: 68px;
 bottom: 560px;
 right: 625px;
 padding: 0px;
  text-transform: lowercase;
}

div.navigation {
 position: absolute;
 top: 151px;
 left: 64px;
 bottom: 64px;
 right: 625px;
 padding: 0px;
  text-transform: lowercase;
 overflow: auto; 
  padding-bottom: 15px;
  line-height:160%;
}

div.berlios {
 position: absolute;
 top: 525px;
 left: 0;
 bottom: 0px;
 right: 600px;
 padding: 0px;
<!--  background:lightgray;-->
 border:thin solid white;
}

div.bottom {
 position: absolute;
 top: 687px;
 left: 430px;
 bottom: 0px;
 right: 37px;
 padding: 0px;
  text-align: right;
  font-size: 85%; 
}

div.main {
 position: absolute;
 top: 153px;
 left: 204px;
 bottom: 64px;
 right: 52px;
 padding-right: 15px;
 padding-bottom: 15px;
 overflow: auto;
 border: thin black solid;
}

div.main h1 {
  margin-top: 0px;
  margin-bottom: 0px;
}

.main a:link, .main a:visited, .main a:active {
  font-weight: normal ;
  text-decoration: underline ;
}

.main a:hover {
  font-weight: normal ;
  text-decoration: underline; 
  color: #000000;
}


code {
  font-family: courier,serif;
  white-space: pre } /*make CODE environment respect whitespace to enable verbatim printing of code snippets in starred header lines*/


/* style for header sections like NAME, AIM, SYNTAX and so on */
.head sec { font-weight: bold }

</style>

</head>


<body>

<?php
$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";

include $bananepath."Documentation/PHP/dyntree.php";
include $bananepath."Documentation/PHP/viewfunctions.php";
include $bananepath."Documentation/PHP/introfunction.php";

## get info from config script.
$confscr=$bananepath."Documentation/Scripts/wwwdocu_conf.scr";

$webscr=$confscr." web";
$allout=`$webscr`;
$out=explode("\n",$allout);
$webpath=$out[0];

$phppath=$webpath."Documentation/PHP/";
$picpath=$phppath."Pics/";

$dbscr=$confscr." db";
$allout=`$dbscr`;
$out=explode("\n",$allout);

$Myqsl["Server"]=$out[0];
$Myqsl["User"]=$out[2];
$Myqsl["Pass"]=$out[3];
$Myqsl["DB"]=$out[1];
$Myqsl["Table"]="dirtreetable";

$treeout=MakeTree($Page,$Name,$Myqsl);

if (isset($dir))
  {$mainout=viewdir($Myqsl,$Page,$dir);}
else
  {
    if (isset($routine))
      {$mainout=viewroutine($Myqsl,$routine);}
    else
      {
	if (isset($search))
	  {$mainout=viewsearch($Myqsl,$search);}
	else
	  {$mainout=introtext();}
      }
  }
?>

<div class="content">

<? echo "<a id='linkhome' href='".$phppath."mainpage.php'</a>"; ?>

<div class="headline">
<? echo "<a href='".$phppath."mainpage.php'>about</a> "; ?>
<a target='_blank' href='http://project-banane.blogspot.com'>weblog</a>
<a target='_blank' href='http://developer.berlios.de/projects/banane/'>summary</a>
<a>members</a>
</div>
<div class="search">
<?php
echo "<form name='input' style='display:inline;' action='".$phppath."mainpage.php' method='get'>";
echo "search <input type='text' name='search'>";
echo "</form>";
?>
</div>
<!--
<div class="logo">
project <span style="color:gold">banane</span>
</div>
-->
<div class="navigation_head">
<span style="font-weight:bold;">directories</span>
</div>
<div class="navigation">
<?php
echo $treeout;
?>
</div>
<div class="main">
<?php
echo $mainout;
?>
</div>
<!--
<div class="berlios">
hosted by<BR>
<a target="_blank" href="http://developer.berlios.de" title="BerliOS Developer"> <img src="http://developer.berlios.de/bslogo.php?group_id=7706" width="124px" height="32px" border="0" alt="BerliOS Developer Logo"></a>
</div>
-->
<div class="bottom">
webpage by <a target="_blank" href="http://www.staff.uni-oldenburg.de/andreas.thiel/">andreas thiel</a> & <a target="_blank" href="http://www.staff.uni-oldenburg.de/m.ahlers/">malte ahlers</a> 2007 &middot; hosted by
<a style='vertical-align:-4px;' target="_blank" href="http://developer.berlios.de" title="BerliOS Developer"> <img src="./Pics/berlios.gif" border="0" alt="BerliOS Developer Logo"></a>
</div>
</div>
</body>
</html>