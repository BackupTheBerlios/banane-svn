<?php

function MakeTree(&$Page,&$Name,$Myqsl){
  $MyqslTable=$Myqsl["Table"];
  @mysql_connect($Myqsl["Server"],$Myqsl["User"],$Myqsl["Pass"]) or Die ("<div align=center><font color='red'><b>Error! <br>Cannot make MySQL server  connection.</b></font></div>");
  mysql_select_db($Myqsl["DB"]);
  $usage="PublicUse=0 Or PublicUse=1";
  $result=mysql_query("SELECT * FROM ".$MyqslTable." WHERE ".$usage." Order by Name");
  if(@mysql_num_rows($result)==0 )
    {return "<div align=center>No Folders Available</div><br><br>";}

  while($Folder0=list($ID,$Name,$Description,$CreateUser,$CreateDate,$ModifyDate,$LastVisit,$Parent,$PublicUse)=mysql_fetch_array($result))
    {$table[$Parent][$ID]=$Name; 
     $partable[$ID]=$Parent;  
     $Folder[$ID]=$Folder0; };
 
  unset($Folder0);

  //  echo"page: $Page<BR>";

  $levels=TreeLevels(0,$table,0);
  if(!isset($Folder[$Page]["Name"]))
    {$Folder[$Page]["Name"]="Home";}
  $Name=$Folder[$Page]["Name"];

  if($Page==0)
    {
      if(!isset($_SESSION["expandtree"])) {$_SESSION["expandtree"]=-1;}
      //  $_SESSION["expandtree"]=-$_SESSION["expandtree"];
      $_SESSION["expandtree"]=$_SESSION["expandtree"];
      
      if($_SESSION["expandtree"]<0) 
	{ $levelexpand=1; } 
      else 
	{ $levelexpand=100000; }
    
//      $results="<img src='folderopen.gif' width='20' height='20'><span style='height: 20px; font: 11px Arial, Helvetica;  font-weight:bold;'>&nbsp;<a href='?Page=0'>Home</a></span><br>";
//      $results="";
      $results=TreeExpand(0,$table,$partable,$Folder,$Page,0,$levelexpand);
    }
  else
    {
      //      $results="<img src='folder.gif' width=20 height=20><span style='height: 20px; font: 11px Arial, Helvetica;'>&nbsp;<a href='?Page=0'>Home</a></span><br>";
      $ID=$Page;
      $results=TreeNodes($ID,$table,$partable,$Folder,$Page,$levels);
      $_SESSION["expandtree"]=1;
    }
  return $results."<br><br>";
}



function  TreeLevels($Parent,$table,$level){
  $_SESSION["levels"][$Parent]=$level;
  while(list($key,$val)=each($table[$Parent]))
    {if (isset($table[$key])){TreeLevels($key,$table,$level+1); } }
  return $_SESSION["levels"];
}



function TreeNodes($ID,$table,$partable,$Folder0,$Page,$levels){
  $rez0="";
  //  $imgfolder0="<img src='./Pics/folder.gif' alt='' width='20' height='20'>&nbsp;<span style='height: 20px; font: 11px; '>";
  //  $imgfolder1="<img src='./Pics/folderopen.gif' alt='' width='20' height='20'>&nbsp;<span style='height: 20px; font: 11px; font-weight:bold;'>";
  $imgfolder0="<img style='border: thin solid black;' src='./Pics/folder.gif'><span style='vertical-align:5px;'>&nbsp;";
  $imgfolder1="<img style='border: thin solid black;' src='./Pics/folderopen.gif'><span style='font-weight:bold; vertical-align:5px;'>&nbsp;";
  if(isset($table[$ID])) {
    //$imgwidth="<img src='./Pics/tr.gif' width='".(($levels[$ID])*10)."' height='1' alt=''>";
    $imgwidth="";
    $lisd=$table[$ID];
    $ID0=$ID; $fiplevel=$levels[$ID];
    while(list($key,$val)=each($lisd)){
      if($Page==$key){
// 		$rez0.=$imgwidth.$imgfolder1."<a href='?Page=".$Folder0[$key]["ID"]."'>".$Folder0[$key]["Name"]."</a></span><br>";
// 	      } else {
// 		$rez0.=$imgwidth.$imgfolder0."<a href='?Page=".$Folder0[$key]["ID"]."'>".$Folder0[$key]["Name"]."</a></span><br>";


//	$rez0.=$imgwidth.$imgfolder1."<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Name"]."'>".$Folder0[$key]["Name"]."</a></span><br>";
//      } else {
//	$rez0.=$imgwidth.$imgfolder0."<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Name"]."'>".$Folder0[$key]["Name"]."</a></span><br>";
	$rez0.=$imgwidth.$imgfolder1."<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Description"]."'>".$Folder0[$key]["Name"]."</a></span><br>";
      } else {
	$rez0.=$imgwidth.$imgfolder0."<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Description"]."'>".$Folder0[$key]["Name"]."</a></span><br>";

      }}}
  $res="";
  while ($ID!=0) {
    $fip=$partable[$ID];
    $fiplevel=$levels[$fip];
    $fiplist=$table[$fip];
    //    $imgwidth="<img src='./Pics/tr.gif' width='".(($fiplevel)*10)."' height='1' alt=''>";
    $imgwidth="";
    $rez="";
    while(list($key,$val)=each($fiplist)){
      if($Page==$key){
	//	$rez.=$imgwidth.$imgfolder1."<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Name"]."'>".$Folder0[$key]["Name"]."</a></span><br>".$rez0;
	//      } else {
	//	$rez.=$imgwidth.$imgfolder0."<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Name"]."'>".$Folder0[$key]["Name"]."</a></span><br>";
	$rez.=$imgwidth.$imgfolder1."<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Description"]."'>".$Folder0[$key]["Name"]."</a></span><br>".$rez0;
      } else {
	$rez.=$imgwidth.$imgfolder0."<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Description"]."'>".$Folder0[$key]["Name"]."</a></span><br>";
      }
      if($ID==$key) { $rez.=$res; $res="";}
    }
    $res.=$rez;
    $ID=$partable[$ID];
  }
  return $rez;
}



function TreeExpand($Parent,$table,$partable,$Folder0,$Page,$level,$levelexpand){
  $list=$table[$Parent]; 
  $width=($level+0)*10; 
  $result='';
  while(list($key,$val)=each($list)){
    if($level<$levelexpand)
      { 
	//	$result.="<img src='./Pics/tr.gif' width='".$width."' height='1'><img src='./Pics/folder.gif'><span style='height: 20px; font: 11px;'>&nbsp;<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Name"]."'>".$Folder0[$key]["Name"]."</a></span><br>"; 
	//	$result.="<img src='./Pics/tr.gif' width='".$width."' height='1'><img src='./Pics/folder.gif'><span style='height: 20px; font: 11px;'>&nbsp;<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Description"]."'>".$Folder0[$key]["Name"]."</a></span><br>"; 
	//	$result.="<img src='./Pics/tr.gif' width='".$width."' height='1'><img src='./Pics/folder.gif'>&nbsp;<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Description"]."'>".$Folder0[$key]["Name"]."</a><br>"; 
	$result.="<img style='border: thin solid black;' src='./Pics/folder.gif'><span style='vertical-align:5px;'>&nbsp;<a href='?Page=".$Folder0[$key]["ID"]."&dir=".$Folder0[$key]["Description"]."'>".$Folder0[$key]["Name"]."</a></span><br>"; 
      }
    if (isset($table[$key])){ $result.=TreeExpand($key,$table,$partable,$Folder0,$Page,$level+1,$levelexpand); }
  }
  return $result;
}

?>