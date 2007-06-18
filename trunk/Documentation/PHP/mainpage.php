<!DOCTYPE html PUBLIC "-//W3C//DTD html 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
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
   font-size: 10pt;
 }
	
div.content {
 position: relative;
 top:20px;
 width:880px;
 height:776px;
 margin:0 auto;
  text-align:left;
  background-image:url('Pics/frame.gif')
}

div.content h1 {
  font-size:100%;  
  font-weight:bold;
}

div.headline {
 position: absolute;
 top: 134px;
 left: 217px;
 bottom: 200px;
 right: 41px;
 padding: 0px;
 border:thin solid black;
  text-align:left;
}

div.logo {
 position: absolute;
 top: 0;
 left: 0;
 bottom: 550px;
 right: 600px;
 padding: 10px;
  text-align:left;
  font-size:140%
}

div.navigation {
 position: absolute;
 top: 134px;
 left: 68px;
 bottom: 42px;
 right: 600px;
 padding: 0px;
  text-transform: lowercase;
 overflow: auto;
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

div.main {
 position: absolute;
 top: 177px;
 left: 217px;
 bottom: 42px;
 right: 74px;
 padding: 0px;
 overflow: auto;
}

div.main h1 {
  margin-top: 0px;
  margin-bottom: 0px;
}


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
<div class="headline">
<span style="word-spacing:1.2em;">
<? echo "<a href='".$phppath."mainpage.php'>about</a> "; ?>
<a target='_blank' href='http://project-banane.blogspot.com'>weblog</a>
<a target='_blank' href='http://developer.berlios.de/projects/banane/'>summary</a>
<a>members</a>
search</span>
<?php
echo "<form name='input' style='display:inline;' action='".$phppath."mainpage.php' method='get'>";
echo "<input style='width:12%;' name='search'>";
echo "</form>";
?>
</div>
<!--
<div class="logo">
project <span style="color:gold">banane</span>
</div>
-->
<div class="navigation">
<p style="font-weight:bold;">directories</p>
<?php
echo $treeout;
?>
</div>
<div class="main">
<?php
echo $mainout;
?>
</div>
<div class="berlios">
hosted by<BR>
<a target="_blank" href="http://developer.berlios.de" title="BerliOS Developer"> <img src="http://developer.berlios.de/bslogo.php?group_id=7706" width="124px" height="32px" border="0" alt="BerliOS Developer Logo"></a>
</div>
</div>
</body>
</html>