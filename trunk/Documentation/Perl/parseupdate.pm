package parseupdate;

use lib '/etc/perl/CPAN/';
use Parse::RecDescent;

sub parse {

$Parse::RecDescent::skip='';

$grammar =

  q{update : (line{\@item})(s)

    line : (file|dir|rev)

    dir : action /\ +/ name nl {$return="I_$item{name}"}
    file : ...!dir
               action /\ +/ name "." ext nl
               { my($comb)=$item{action}."_".$item{name}.".".$item{ext};
                 # print "file: $comb\n";
                 $return = $comb}
    rev : ...!file
          ...!dir
              /.+/ {$return="I_$item{__PATTERN1__}"}

    action : ("U"|"A")

    name : /[^\.\n]+/

    ext : "m"

    nl : /\ *\n/ # allow arbitrary spaces before newline
  };
$parse = new Parse::RecDescent ($grammar);

$result=$parse->update($_[0]);

#print "$result->[2]->[1]\n";

return $result;

}

1; # return value of perl module
