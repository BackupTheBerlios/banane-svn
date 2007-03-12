<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>upper border of banane webpage</title>
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

echo "<div align='center'><img src='".$picpath."o02.gif' width='910'
      height='16'>";
echo "</div>";

?>

</body>
</html>
