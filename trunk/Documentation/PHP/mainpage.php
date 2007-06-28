<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" 
    "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>

<meta http-equiv="content-type" content="text/html;charset=ISO-8859-1">

<title>webpage of the banane project</title>

<link rel="stylesheet" href="bananestyle.css">
<link rel="SHORTCUT ICON" href="Pics/minibanane.ico">

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


<div class="bottom">
webpage by 
<a target="_blank" href="http://www.staff.uni-oldenburg.de/andreas.thiel/">andreas thiel</a> 
& <a target="_blank" href="http://www.staff.uni-oldenburg.de/m.ahlers/">malte ahlers</a> 2007 &middot; 
hosted by
<a style='vertical-align:-4px;' target="_blank" href="http://developer.berlios.de" title="BerliOS Developer"> <img src="./Pics/berlios.gif" border="0" alt="BerliOS Developer Logo"></a>
</div>

</div>

</body>
</html>