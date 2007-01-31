## index.php calls the mainpage script that actually 
## displays the banane homepage. copy index.php to the 
## initial directory where the browser looks for it.
## be shure to correctly modify the $bananepath.

<?php

$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";

## get info from config script.
$confscr=$bananepath."Documentation/Scripts/wwwdocu_conf.scr";

$webscr=$confscr." web";
$allout=`$webscr`;
$out=explode("\n",$allout);
$webpath=$out[0];

$anchor=$webpath."Documentation/PHP/mainpage.php";
include $anchor;

?>