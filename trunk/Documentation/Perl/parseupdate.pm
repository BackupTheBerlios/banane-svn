package parseupdate;

use lib '/etc/perl/CPAN/';
use Parse::RecDescent;

sub parse {

$Parse::RecDescent::skip='';

$grammar =

  q{update : files revision {$return=$item{files}}

    files : (fileline{\@item} | dirline)(s?)

    dirline : action /\ +/ file nl {print "$item{file}\n";}
    fileline : ...!dirline
               action /\ +/ file "." extension nl
               {print "$item{file}\n"; my($comb)=$item{file}.".".$item{extension};
                $return = $comb}
    revision : ...!fileline
               ...!dirline
              /.+/

    action : ("U"|"A")

    file : /[^\.\n]+/

    extension : "m"

    nl : /\ *\n/ # allow arbitrary spaces before newline
  };

$parse = new Parse::RecDescent ($grammar);

$result=$parse->update($_[0]);

print "$result->[0]\n";

return $result;

}

1; # return value of perl module
