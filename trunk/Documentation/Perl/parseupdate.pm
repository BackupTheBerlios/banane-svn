package parseupdate;

use lib '/etc/perl/CPAN/';
use Parse::RecDescent;

sub parse {

$Parse::RecDescent::skip='';

$grammar =

  q{update : files revision {$return=$item{files}}

    files : (fileline{\@item})(s?)

    fileline: (dirline|fileline2)

    dirline : action /\ +/ file nl {print "dir: $item{file}\n";}
    fileline2 : ...!dirline
               action /\ +/ file "." extension nl
               {print "file: $item{file}\n"; my($comb)=$item{file}.".".$item{extension};
                $return = $comb}
    revision : ...!fileline2
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
