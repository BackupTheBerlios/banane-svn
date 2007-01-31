<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
   "http://www.w3.org/TR/html4/frameset.dtd">
<HTML>
<HEAD>
<TITLE>Main Webpage of the Banane project</TITLE>
<?php 
$bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";

## get info from config script.
$confscr=$bananepath."Documentation/Scripts/wwwdocu_conf.scr";

$webscr=$confscr." web";
$allout=`$webscr`;
$out=explode("\n",$allout);
$webpath=$out[0];

$phppath=$webpath."Documentation/PHP/";
?>
</HEAD>

<FRAMESET cols="250, *">
  <FRAMESET rows="125, 150, 80, 75">
      <FRAME name="logo" frameborder="0" src=$phppath."logo.html">
      <FRAME name="tree" frameborder="0" src=$phppath."viewtree.php">
      <FRAME name="search" frameborder="0" src=$phppath."searchform.html">
      <FRAME name="berlios" frameborder="0" src=$phppath."berlioslogo.html">
  </FRAMESET>
  <FRAME name="dynamic" frameborder="0" src=$phppath."viewdir.php">
  <NOFRAMES>
      <P>This frameset document contains:
      <UL>
         <LI><A href="contents_of_frame1.html">Some neat contents</A>
         <LI><IMG src="contents_of_frame2.gif" alt="A neat image">
         <LI><A href="contents_of_frame3.html">Some other neat contents</A>
      </UL>
  </NOFRAMES>
</FRAMESET>
</HTML>