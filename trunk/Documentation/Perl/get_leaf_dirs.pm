#!/usr/bin/perl -w

### this function reads the Banane directory structure and 
### returns information about the directory names and their 
### parent folders. it is used by "updatetree.pl"

sub get_leaf_dirs {
  
  # arguments
  my($dir)=$_[0];
  my($mother)=$_[1];
  my($topdir)=$_[2];
    
  # list of directories not to be shown
  # must be converted to hash for easier element searching via "exists"
  @exclude=(".", "..", ".svn", "PHP", "Perl", "Scripts");
  my %hash;
  @hash{@exclude}=();

  # init result array
  my(@array)=();

  opendir(DIRHANDLE, $dir) || die "Cannot opendir /some/path: $!";

  my(@entries)=readdir(DIRHANDLE);

  closedir(DIRHANDLE);

  foreach my $entry (@entries) {

    if (!exists($hash{$entry})){

      my($fullpath) = $dir.'/'.$entry;
	  
      if (-d $fullpath){ # check for directory
	      
	$index++;      

	my($relpath)=$fullpath;
	$relpath=~s/$topdir//;
	$relpath=~s/^\///;

	my(%info) = (fullpath=>$fullpath
		     , relpath=>$relpath
		     , name=>$entry
		     , mother=>$mother);

	push(@array,\%info);

	my(@subdirs) = get_leaf_dirs($fullpath,$entry,$topdir);

	if (@subdirs) {push(@array, @subdirs);}
      
      }
    }
  }


  return @array;

}

1; # return value of perl module
