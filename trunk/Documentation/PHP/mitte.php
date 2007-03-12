<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title>Unbenanntes Dokument</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<?php 

$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";

## get info from config script.
$confscr=$bananepath."Documentation/Scripts/wwwdocu_conf.scr";

$webscr=$confscr." web";
$allout=`$webscr`;
$out=explode("\n",$allout);
$webpath=$out[0];

$phppath=$webpath."Documentation/PHP/";

echo "<frameset rows='*' cols='*,166,728,16,*' framespacing='0' frameborder='no' border='0'>";
echo "<frame src='".$phppath."leer.htm' scrolling='no' noresize>";
echo "<frame src='".$phppath."links.php' scrolling='no' noresize>";
echo "<frame name='dynamic' src='".$phppath."intro.html' noresize>";
echo "<frame src='".$phppath."rechts.htm' scrolling='no' noresize>";
echo "<frame src='".$phppath."leer.htm' scrolling='no' noresize>";
echo "</frameset>";
echo "<noframes><body>";
echo "</body></noframes>";

?>

</html>
