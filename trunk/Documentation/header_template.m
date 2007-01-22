%+
% NAME:
%  example_function()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  J. R. Hacker
%
% DATE CREATED:
%  9/2002
%
% AIM:
%  Short description of the routine in a single line.
%
% DESCRIPTION:
%  Detailed description of the routine. May contain small HTML tags like
%  for example <BR> linebreaks. 
%
% CATEGORY:
%  At present, there are three possibilities:<BR>
%   - Documentation<BR>
%   - NEV Tools<BR>
%   - Support routines<BR>
%  Others may be invented.
%
% SYNTAX:
%* result = example_function(arg1, arg2,[, optarg1][, optarg2]); 
%
% INPUTS:
%  arg1:: First argument of the function call. Indicate variable type and
%  function.
%  arg2:: Second argument of the function call.
%
% OPTIONAL INPUTS:
%  optarg1:: An optional input argument.
%  optarg2:: Another optional input argument.
%
% OUTPUTS:
%  result:: The result of the routine.
%
% RESTRICTIONS:
%  Is there anything known that could cause problems?
%
% PROCEDURE:
%  Short description of the alogorithm.
%
% EXAMPLE:
%  Indicate example lines with * 
%* data=example_function(23,5)
%  
%  Indicate matlab output with *>
%*> ans =
%*>   28
%
% SEE ALSO:
%  Related files. Banane routines may be refenced as anchors <A>foobar</A>. 
%-



function result = funcname(arg1,arg2);
  
  result = arg1+arg2;
