package parseheader;

#use lib '/etc/perl/CPAN/';
use Parse::RecDescent;

sub parse {

$Parse::RecDescent::skip='';

$grammar =

  q{code : header body { $return=$item{header} }

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
             headerstop 
     { my(@list) = ($item{name}, 
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

    headerstart : "%+" nl 
     { print "Found headerstart... "; }
    headerstop : "%-" nl 
     { print "and headerstop.\n"; }

    name : "%" /\ */ "NAME:" nl nameline 
     { $return=$item{nameline} }

    version : "%" /\ */ "VERSION:" nl headerline 
     { $return=$item{headerline} }

    author : "%" /\ */ "AUTHOR:" nl headerline 
     { $return=$item{headerline} }

    date : "%" /\ */ "DATE CREATED:" nl headerline
     { $return=$item{headerline} }

    aim : "%" /\ */ "AIM:" nl headerline 
     { $return=$item{headerline} }

    description : "%" /\ */ "DESCRIPTION:" nl headerline(s)
     { # join multiple headerlines in single string
       $return=join(" ",@{$item[-1]}) }

    category : "%" /\ */ "CATEGORY:" nl headerline(s)
     { $return=join(" ",@{$item[-1]}) }

    syntax : "%" /\ */ "SYNTAX:" nl headerline(s)
     { my($jojo)=join(" ",@{$item[-1]}); 
       $jojo =~ s/<\/CODE><BR> <BR><CODE>/<BR>/g;
print"$jojo\n";
       $jojo =~ s/^<BR>//;
print"$jojo\n";
       $return=$jojo}

    inputs : "%" /\ */ "INPUTS:" nl argument(s) 
     { $return=$item[5] }

    optinputs : "%" /\ */ "OPTIONAL INPUTS:" nl argument(s) 
     { $return=$item[5] }

    outputs : "%" /\ */ "OUTPUTS:" nl argument(s) 
     { $return=$item[5] }

    restrictions : "%" /\ */ "RESTRICTIONS:" nl headerline(s) 
     { $return=join(" ",@{$item[-1]}) }

    procedure : "%" /\ */ "PROCEDURE:" nl headerline(s)
     { $return=join(" ",@{$item[-1]}) }

    example : "%" /\ */ "EXAMPLE:" nl headerline(s)
     {}

    also : "%" /\ */ "SEE ALSO:" nl headerline(s)
     { $return=join(" ",@{$item[-1]}) }

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
                normalline | codeline

    codeline: "%*" /\ */ /.*/ /\ */ nl
                   { $return = "<BR><CODE>".$item{__PATTERN2__}."</CODE><BR>" }

    normalline: ...!codeline
                 "%" /\ */ /.*/ /\ */ nl
                   { $return = $item{__PATTERN2__} }

    argument : argumentline headerline(s?)
     { if (defined ($item[-1])) {
          my($total)=unshift(@{$item[-1]}, $item{argumentline}[1]);
          my(@list) = ($item{argumentline}[0],join(" ",@{$item[-1]}));
          $return=\@list}
       else {
          print"argument with no additional headerline.\n";
          my(@list) = (@{$item{argumentline}});
          $return=\@list} }


    argumentline : "%" /\ */ /[a-zA-Z0-9,\ ]*/ "::" /.*/ nl
     { my(@list) = ($item{__PATTERN2__}, 
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


## need an additional level of dereference here, possibly due to the 
## fact that 'restrictions' is an optional section. The same is true 
## for 'see also'. 
my($restr)=${@{$result->[11]}}[0];
my($al)=${@{$result->[14]}}[0];


## care for cases when optional sections are missing
if (!(defined $restr)) {$restr="NULL";}
if (!(defined $al)) {$al="NULL";}


## generate hash as return structrue, since its easier 
## to access single tags by name
return ("name"=>$$result[0],
        "version"=>$$result[1],
	"author"=>$$result[2],
	"date"=>$$result[3],
	"aim"=>$$result[4],
	"description"=>$$result[5],
	"category"=>$$result[6],
	"syntax"=>$$result[7],
        "inputs"=>$$result[8],
        "optinputs"=>$$result[9],
        "outputs"=>$$result[10],
        "restrictions"=>$restr,
        "proc"=>$$result[12],
        "example"=>$$result[13], #$exa,
        "also"=>$al);
}

1; # return value of perl module
