<!-- mitte.php defines the horizontal frame structure 
of the webpage, which consists of frames that are filled by the separate 
files links.php, intro.html and rechts.php. links.php displays the contents 
   of the navigation bar, intro.html prints the welcome text into the large
   main frame (called 'dynamic' on the right of the page, and rechts.php 
displays the righthandside border of the page -->


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title>middle part of the banane webpage</title>
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
echo "<frame src='".$phppath."rechts.php' scrolling='no' noresize>";
echo "<frame src='".$phppath."leer.htm' scrolling='no' noresize>";
echo "</frameset>";
echo "<noframes><body>";
echo "</body></noframes>";

?>

</html>
