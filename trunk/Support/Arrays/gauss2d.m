%+
% NAME:
%  gauss2d()
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
%  Support Routines<BR>
%  Arrays
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
%  <A>rffitting</A>, <A>fitgauss2d</A>. 
%-


function result=gauss2d(width,height,xpeak,ypeak,xsigma,ysigma)

  if (~exist('ysigma'))
    ysigma=xsigma
  end
  
  xgrid=repmat((1:width)-xpeak,height,1);
  ygrid=repmat((1:height)'-ypeak,1,width);

  result=exp(-(xgrid.^2/(2.*xsigma^2)+ygrid.^2/(2.*ysigma^2)));
  
  end
  