<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
   "http://www.w3.org/TR/html4/frameset.dtd">
<HTML>

<HEAD>
<TITLE>main webpage of the banane project</TITLE>
</HEAD>

<?php 

$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";

## get info from config script.
$confscr=$bananepath."Documentation/Scripts/wwwdocu_conf.scr";

$webscr=$confscr." web";
$allout=`$webscr`;
$out=explode("\n",$allout);
$webpath=$out[0];

$phppath=$webpath."Documentation/PHP/";

echo "<FRAMESET cols='250, *'>";
echo "<FRAMESET rows='140, 140, 80, 75'>";
echo "<FRAME name='logo' frameborder='0' src='".$phppath."logo.html'>";
echo "<FRAME name='tree' frameborder='0' src='".$phppath."viewtree.php'>";
echo "<FRAME name='search' frameborder='0' src='".$phppath."searchform.html'>";
echo "<FRAME name='berlios' frameborder='0' src='".$phppath."berlioslogo.html'>";
echo "</FRAMESET>";
echo "<FRAME name='dynamic' frameborder='0' src='".$phppath."intro.html'>";
echo "<NOFRAMES>";
echo "<P>This frameset document contains nothing";
echo "</NOFRAMES>";
echo "</FRAMESET>";

?>

</HTML>