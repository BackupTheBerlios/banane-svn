<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>lower border of banane webpage</title>
<link rel="stylesheet" href="bananestyle.css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<?php 

$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";

## get info from config script.
$confscr=$bananepath."Documentation/Scripts/wwwdocu_conf.scr";

$webscr=$confscr." web";
$allout=`$webscr`;
$out=explode("\n",$allout);
$webpath=$out[0];

$picpath=$webpath."Documentation/PHP/Pics/";

echo "<div align='center'>";
echo "<img src='".$picpath."u02.gif' width='910' height='24'>";
echo "<br>";
echo "<font size=1>";
echo "created march 2007";
echo " - programming: <a target='_blank'
	  href='http://www.staff.uni-oldenburg.de/andreas.thiel/'>athiel</a>";
echo " - design: <a target='_blank'
	  href='http://www.mtahlers.de/'>mtahlers</a>"; 
echo "</font>";
echo "</div>";

?>
</body>
</html>
