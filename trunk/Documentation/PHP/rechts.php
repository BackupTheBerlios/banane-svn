<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>right border of the banane webpage</title>
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

echo "<img src='".$picpath."r02.gif' width='16' height='604'>

?>
 
</body>
</html>
