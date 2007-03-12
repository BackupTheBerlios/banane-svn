<!-- mainpage.php defines the overall frame structure of the banane
online docu and includes all parts as separate source files: the banane 
logo, the directory tree, the search form, the berlios logo and the intro
text --> 

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

echo "<frameset rows='*,16,604,*' cols='*' framespacing='0' frameborder='no' border='0'>";
echo "<frame src='".$phppath."leer.htm'>";
echo "<frame src='".$phppath."oben.php' scrolling='no' noresize>";
echo "<frame src='".$phppath."mitte.htm'>";
echo "<frame src='".$phppath."unten.htm' scrolling='no' noresize>";
echo "</FRAMESET>";
echo "<NOFRAMES><body>";
echo "</body></NOFRAMES>";
echo "</FRAMESET>";

?>

</HTML>