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
             author 
             emptyline(s?) 
             date 
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
                            $item{author},
                            $item{date},
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
                          $return = \@list }

    body : bodyline(s)

    headerstart : "%+" nl { print "Found headerstart... "; }
    headerstop : "%-" nl { print "and headerstop.\n"; }

    name : "%" /\ */ "NAME:" nl nameline {$return=$item{nameline}}

    version : "%" /\ */ "VERSION:" nl headerline {$return=$item{headerline}}

    author : "%" /\ */ "AUTHOR:" nl headerline {$return=$item{headerline}}

    date : "%" /\ */ "DATE CREATED:" nl headerline {$return=$item{headerline}}

    aim : "%" /\ */ "AIM:" nl headerline {$return=$item{headerline}}

    description : "%" /\ */ "DESCRIPTION:" nl (headerline{\@item})(s)
     {print join("---",${$item[-1]}[0])."\n";}

    category : "%" /\ */ "CATEGORY:" nl (headerline{\@item})(s)

    syntax : "%" /\ */ "SYNTAX:" nl (headerline{\@item})(s)

    inputs : "%" /\ */ "INPUTS:" nl argument(s) 
     { $return=$item[5] }

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
                ...!author
                ...!date
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
                print"argument with no additional headerline.\n";
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
                ...!author
                ...!date
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
foreach (@{$result->[5]}) {$descr=$descr." ".$_->[1];}

my $cat="";
foreach (@{$result->[6]}) {$cat=$cat.$_->[1];}

my $syn="";
foreach (@{$result->[7]}) {$syn=$syn."<BR>".$_->[1];}

## need an additional level of derefernce here, possibly due to the 
## fact that 'restrictions' is an optional section. The same is true 
## for 'see also'. 
my $restr="";
foreach (@{$result->[11]->[0]}) {$restr=$restr." ".$_->[1];}

my $proc="";
foreach (@{$result->[12]}) {$proc=$proc." ".$_->[1];}

my $exa="";
foreach (@{$result->[13]}) {$exa=$exa."<BR>".$_->[1];}

my $al="";
foreach (@{$result->[14]->[0]}) {$al=$al.$_->[1];}

return ("name"=>$$result[0],
        "version"=>$$result[1],
	"author"=>$$result[2],
	"date"=>$$result[3],
	"aim"=>$$result[4],
	"description"=>$descr,
	"category"=>$cat,
	"syntax"=>$syn,
        "inputs"=>$$result[8],
        "optinputs"=>$$result[9],
        "outputs"=>$$result[10],
        "restrictions"=>$restr,
        "proc"=>$proc,
        "example"=>$exa,
        "also"=>$al);
}

1; # return value of perl module
