package parseupdate;

use lib '/etc/perl/CPAN/';
use Parse::RecDescent;

sub parse {

#$Parse::RecDescent::skip='';

$grammar =

  q{update : files revision {$return=$item{files}}

    files : (fileline{\@item}|dirline)(s?)

    fileline : ...!dirline
               action /\ +/ file "." extension
               {my($comb)=$item{file}.".".$item{extension};
                $return = $comb}
    dirline : action /\ +[^\.]/
    revision : ...!fileline
               ...!dirline
              /.+/

    action : ("U"|"A")

    file : /[^\.]+/

    extension : "m"

#    nl : /\ *\n/ # allow arbitrary spaces before newline
  };

$parse = new Parse::RecDescent ($grammar);

$result=$parse->update($_[0]);

#print "$result->[0]\n";

return $result;

}

1; # return value of perl module
