%+
% NAME:
%  fitgauss2d()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  5/2007
%
% AIM:
%  Short description of the routine in a single line.
%
% DESCRIPTION:
%  Detailed description of the routine. The text may contain small HTML
%  tags like for example <BR> linebreaks or <VAR>variable name
%  typesetting</VAR>. Simple anchors to other banane routines are
%  also allowed, eg <A>kwextract</A>.
%
% CATEGORY:
%   Support Routines<BR>
%   Fitting
%
% SYNTAX:
%* result = example_function(arg1, arg2 [,'optarg1',value][,'optarg2',value]); 
%
% INPUTS:
%  arg1:: First argument of the function call. Indicate variable type and
%  function.
%  arg2:: Second argument of the function call.
%
% OPTIONAL INPUTS:
%  optarg1:: An optional input argument.
%  optarg2:: Another optional input argument. Of course, the whole
%  section is optional, too.
%
% OUTPUTS:
%  result:: The result of the routine.
%
% RESTRICTIONS:
%  Optional section: Is there anything known that could cause problems?
%
% PROCEDURE:
%  Short description of the algorithm.
%
% EXAMPLE:
%  Indicate example lines with * as the first character. These lines
%  will be typeset in a fixed width font. Indicate user input with >>. 
%* >> data=example_function(23,5)
%* ans =
%*   28
%
% SEE ALSO:
%  <A>rffitting</A>, <A>gauss2d</A>. 
%-

function err = fitgauss2d(p,rf)
  
  [m,n] = size(rf);

  if ((p(1) < 1) | (p(1) > n) | (p(2) < 1) | (p(2) > m) | (p(4) <= .1) | ...
      (p(5) <= .1) | (max(rf(:))==0))
    
    err=inf;
    
  else
  
    fin=p(3)*gauss2d(m,n,p(2),p(1),p(4),p(5));
       
    diff=rf-fin;

    err=sum(abs(diff(:)))/max(rf(:));
       
  end % if
  
  end
  