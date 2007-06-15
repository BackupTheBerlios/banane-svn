<?php

## intro displays a welcome text with some basic information
## about the banane project. it is called from mainpage.php

function introtext()
{

  $output="<H1>Welcome to the banane online documentation.</H1>";

  $output.="<P>The recursive acronym &quot;banane&quot; stands for<BR>";
  $output.="<B>b</B>anane<BR>";
  $output.="<B>a</B>ids<BR>";
  $output.="<B>n</B>euroscientists<BR>";
  $output.="<B>a</B>nalysing<BR>";
  $output.="<B>n</B>europhysiological<BR>";
  $output.="<B>e</B>xperiments.<BR>";
      
  $output.="<P>The banane project is a collection of <A HREF='http://www.mathworks.com/products/matlab/' TARGET='_blank'>MATLAB</A> routines for processing, analysis and visualization of neurophysiological data, in particular multiple sequences of action potentials, as are commonly recorded with multielectrode arrays.";

  $output.="<P>Click on the directory names on the left to view a list of routines contained in the respective directory. You may also search for the name of a routine.";

  $output.="<P>Here is a short german <A HREF='http://project-banane.blogspot.com/2007/01/mein-erstes-banane-checkout.html' TARGET='_blank'>manual</A> on how to obtain your own banane working copy via <A HREF='http://en.wikipedia.org/wiki/Subversion_(software)' TARGET='_blank'>subversion</A>.";
  
  $output.="<P>Presently, the collection of routines is incomplete and under construction, so be sure to check back frequently. For the latest information, visit the <A HREF='http://www.project-banane.blogspot.com/' TARGET='_blank'>banane weblog</A>.";

  return $output;

}

?>