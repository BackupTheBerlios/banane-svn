<HTML> 
<head>
  <title>View banane directories</title>
  <link rel="stylesheet" href="bananestyle.css">
</head>

<body>
<?php

/*------------------------------------------------------------------------------
|
|                             PHParadise source code
|
|-------------------------------------------------------------------------------
|
| file:             directory structure to list
| category:         directories
|
| last modified:    Mon, 14 Nov 2005 19:33:15 GMT
| downloaded:       Mon, 29 Jan 2007 15:58:51 GMT as text file
|
| code URL:
| http://phparadise.de/php-code/directories/directory-structure-to-list/
|
| description:
| this PHP function displays any given directory structure as recursive list. it
| even outputs nice HTML markup code with indenting.
|
------------------------------------------------------------------------------*/



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
echo "<h1>Banane directories</h1>";

echo directory_to_list('/home/groups/banane/htdocs/wwwcopy/Banane',TRUE);

?>