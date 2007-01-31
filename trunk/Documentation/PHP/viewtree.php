<!-- viewtree.php displays the banane directory structure.
it is called from mainpage.php. the code has been modified from
the routine "directory structure to list" obtained from PHParadise
code URL was 
http://phparadise.de/php-code/directories/directory-structure-to-list/ 
modification include the exclusion of hidden directories and the call of
the script viewdir.php -->

<HTML> 
<head>
  <title>View banane directory tree</title>
  <link rel="stylesheet" href="bananestyle.css">
</head>

<body>
<?php

function entab($num)
{
  return "\n".str_repeat("\t",$num);
}


function directory_to_list($dir,$onlydirs=FALSE,$sub=FALSE)
{
  $bananepath="/home/groups/banane/htdocs/wwwcopy/Banane/";

  $levels = explode('/',$dir);
  $subtab = (count($levels) > 2 ? count($levels)-2 : 0);
  $t = count($levels)+($sub !== false ? 1+$subtab : 0);
  $output = entab($t).'<ul>';
  $dirlist = opendir($dir);
  while ($file = readdir ($dirlist))
    {
      if ($file != '.' && $file != '..' && $file != '.DS_Store' && preg_match('/^\./', $file) == 0)
	{
	  $newpath = $dir.'/'.$file;    
	  $relpath=str_replace($bananepath, "", $newpath);
	  $level = explode('/',$newpath);
	  $tabs = count($level)+($sub !== false ? 1+$subtab : 0);
	  $output .= (($onlydirs == TRUE && is_dir($newpath)) || $onlydirs == FALSE ? 
#				entab($tabs).'<li><a href="'.$newpath.'">'.$file.'</a>'.(is_dir($newpath) ? 
		      entab($tabs).'<li><a target="dynamic" href="viewdir.php?'.$relpath.'">'.$file.'</a>'.(is_dir($newpath) ? 
													    directory_to_list($newpath,$onlydirs,TRUE).entab($tabs) : 
													    '').'</li>' : 
		      '');
	}
    }
  closedir($dirlist); 
  $output .= entab($t).'</ul>';
  if($onlydirs == TRUE)
    $output = preg_replace('/\n([\t]+)<ul>\n([\t]+)<\/ul>\n([\t]+)/','',$output);
  return $output;
}

// demo of directory to list

//echo directory_to_list('.');

// if you want to list directories only, use
echo "<h1>banane directories</h1>";

echo directory_to_list('/home/groups/banane/htdocs/wwwcopy/Banane',TRUE);

?>