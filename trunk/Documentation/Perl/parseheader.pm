package parseheader;

#use lib '/etc/perl/CPAN/';
use Parse::RecDescent;

sub parse {

$Parse::RecDescent::skip='';

$grammar =

  q{code : header body {#print "$item[1]->[6]->[0]->[0]->[1]\n";
$return=$item{header}}

    header : headerstart 
             name
             emptyline(s?) 
             version 
             emptyline(s?) 
             aim 
             emptyline(s?) 
             description 
             emptyline(s?) 
             category
             emptyline(s?) 
             syntax
             emptyline(s?) 
             inputs(?)
             emptyline(s?) 
             optinputs(?)
             emptyline(s?) 
             outputs(?)
             emptyline(s?) 
             restrictions(?)
             emptyline(s?) 
             procedure 
             emptyline(s?) 
             example 
             emptyline(s?) 
             also(?)
             emptyline(s?) 
             headerstop { my(@list) = 
                           ($item{name}, 
                            $item{version}, 
                            $item{aim},
                            $item{description},
                            $item{category},
                            $item{syntax},
                            $item{inputs},
                            $item{optinputs},
                            $item{outputs},
                            $item{restrictions},
                            $item{procedure},
                            $item{example},
                            $item{also});
#print "$item[14]->[0]->[0]->[1]\n";
print "$item{also}\n";
                          $return = \@list }

    body : bodyline(s)

    headerstart : "%+" nl { print "Found headerstart\n"; }
    headerstop : "%-" nl { print "Found headerstop\n"; }

    name : "%" /\ */ "NAME:" nl nameline {$return=$item{nameline}}

    version : "%" /\ */ "VERSION:" nl headerline {$return=$item{headerline}}

    aim : "%" /\ */ "AIM:" nl headerline {$return=$item{headerline}}

    description : "%" /\ */ "DESCRIPTION:" nl (headerline{\@item})(s)
    
    category : "%" /\ */ "CATEGORY:" nl (headerline{\@item})(s)

    syntax : "%" /\ */ "SYNTAX:" nl (headerline{\@item})(s)

    inputs : "%" /\ */ "INPUTS:" nl argument(s) {
#print "$item[5]->[0]->[1]\n"; 
$return=$item[5] }

    optinputs : "%" /\ */ "OPTIONAL INPUTS:" nl argument(s) 
     { $return=$item[5] }

    outputs : "%" /\ */ "OUTPUTS:" nl argument(s) 
     { $return=$item[5] }

    restrictions : "%" /\ */ "RESTRICTIONS:" nl (headerline{\@item})(s)
 
    procedure : "%" /\ */ "PROCEDURE:" nl (headerline{\@item})(s)

    example : "%" /\ */ "EXAMPLE:" nl (headerline{\@item})(s)

    also : "%" /\ */ "SEE ALSO:" nl (headerline{\@item})(s)

    headerline: ...!headerstart
                ...!headerstop
                ...!name
                ...!version
                ...!aim
                ...!description
                ...!category
                ...!syntax
                ...!inputs
                ...!optinputs
                ...!outputs
                ...!restrictions
                ...!procedure
                ...!example
                ...!also
                ...!argumentline
                "%" /\ */ /.*/ /\ */ nl
                   { $return = $item{__PATTERN2__} }

    argument : argumentline headerline(s?)
                {if (defined ($item[-1])) {
                 my($total)=unshift(@{$item[-1]}, $item{argumentline}[1]);
#                 print join("---",@{$item[-1]})."\n";
                 my(@list) = ($item{argumentline}[0],join(" ",@{$item[-1]}));
# print $list[0]."\n".$list[1]."\n";
                $return=\@list}
                else
                {
                print"undefined!!!\n";
                 my(@list) = (@{$item{argumentline}});
                $return=\@list
                }
                }


    argumentline : "%" /\ */ /[a-z0-9,\ ]*/ "::" /.*/ nl
                 { my(@list) = 
                           ($item{__PATTERN2__}, 
                            $item{__PATTERN3__});
                   $return = \@list }

    ### special rule for name of routine
    nameline: ...!headerstart
              ...!headerstop
              ...!name
              ...!version
                ...!aim
                ...!description
                ...!category
                ...!syntax
                ...!inputs
                ...!optinputs
                ...!outputs
                ...!restrictions
                ...!procedure
                ...!example
                ...!also
              "%" /\ */ /[A-Za-z_][A-Za-z0-9_]*/ /(\(\))?/ nl
                { $return = $item{__PATTERN2__} }

    emptyline : "%" nl


    bodyline : /.*\n/ # { print "Found a bodyline\n"; }

    nl : /\ *\n/ # allow arbitrary spaces before newline
  };

$parse = new Parse::RecDescent ($grammar);

$result=$parse->code($_[0]);

#print "$result->[6]->[0]->[0]->[1]\n";
#print "$$result[6]->[0]->[0]->[1]\n";
#print "$result->[6]\n";

# concatenate single lines from multiline entries
my $descr="";
foreach (@{$result->[3]}) {$descr=$descr." ".$_->[1];}

my $cat="";
foreach (@{$result->[4]}) {$cat=$cat.$_->[1];}

my $syn="";
foreach (@{$result->[5]}) {$syn=$syn."<BR>".$_->[1];}

my $restr="";
foreach (@{$result->[9]->[0]}) {$restr=$restr." ".$_->[1];}

my $proc="";
foreach (@{$result->[10]}) {$proc=$proc." ".$_->[1];}

my $exa="";
foreach (@{$result->[11]}) {$exa=$exa."<BR>".$_->[1];}

my $al="";
foreach (@{$result->[12]->[0]}) {$al=$al.$_->[1];}

return ("name"=>$$result[0],
        "version"=>$$result[1],
	"aim"=>$$result[2],
	"description"=>$descr,
	"category"=>$cat,
	"syntax"=>$syn,
        "inputs"=>$$result[6],
        "optinputs"=>$$result[7],
        "outputs"=>$$result[8],
        "restrictions"=>$restr,
        "proc"=>$proc,
        "example"=>$exa,
        "also"=>$al);
}

1; # return value of perl module
