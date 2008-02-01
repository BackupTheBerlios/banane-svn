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
%  Detailed description of the routine. The text may contain small HTML
%  tags like for example <BR> linebreaks or <VAR>variable name
%  typesetting</VAR>. Simple anchors to other banane routines are
%  also allowed, eg <A>kwextract</A>.
%
% CATEGORY:
%  At present, there are the following possibilities:<BR>
%   - DataStructures<BR>
%   - Documentation<BR>
%   - NEV Tools<BR>
%   - Support Routines<BR>
%   - Arrays<BR>
%   - Classes<BR>
%   - Misc<BR>
%   - Strings<BR>
%   - Receptive Fields<BR>
%   - Signals<BR>
%   - Statistics<BR>
%  Others may be invented, with corresponding subdirectories in the
%  BANANE directory tree. For example:<BR>
%   - DataStorage<BR>
%   - Demonstration<BR>
%   - Graphic<BR>
%   - Help<BR>
%   - Simulation<BR>
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
%  Optional section: Mention related or required files here. Banane routines may be refenced as anchors <A>loadNEV</A>. 
%-




% NAME:
%  cog()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  M. T. Ahlers
%
% DATE CREATED:
%  1/2008
%
% AIM:
%  Compute center of gravity of two-dimensional array.
%
% DESCRIPTION:
%  This routine computes the center of gravity of a two-dimensional
%  array, with the array values interpreted as the masses.
%
% CATEGORY:
%  Support Routines<BR>
%  Arrays
%
% SYNTAX:
%* [row,col] = cog(image); 
%
% INPUTS:
%  image:: Two-dimensional numerical array.
%
% OUTPUTS:
%  row:: The vertical coordinate of the center of gravity.
%  col:: The horizontal coordinate of the center of gravity.
%
% PROCEDURE:
%  Sums and vector multiplications.
%
% EXAMPLE:
%* >> hill=gauss2d(25,25,5,7);
%* >> [y,x]=cog(hill)
%* y =
%*     5.2014
%* x =
%*     7.0328
%
% SEE ALSO:
%  <A>gauss2d</A>. 


function [row,col] = cog(im)
  [m,n]=size(im);
  r_sum=sum(im,2); 
  c_sum=sum(im,1);
  all_sum=sum(c_sum);
  
  if (all_sum~=0)
    row=(r_sum'*[1:m]')/all_sum;
    col=(c_sum*[1:n]')/all_sum;
  else
    warning('Sum of array is zero. Returning origin position as COG.')
    row=1;
    col=1;
  end