<!-- mainpage.php is the starting point for webpage displaying the 
banane online documentation. It defines the vertical frame structure 
of the webpage, which consists of frames that are filled by the separate 
files oben.php, mitte.php and unten.php. oben.php and unten.php merely 
display the pictures showing the top and bottom parts of the outer border. 
mitte.php defines the horizontal frame structure --> 

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
echo "<frame src='".$phppath."mitte.php'>";
echo "<frame src='".$phppath."unten.php' scrolling='no' noresize>";
echo "</FRAMESET>";
echo "<NOFRAMES><body>";
echo "</body></NOFRAMES>";
echo "</FRAMESET>";

?>

</HTML>