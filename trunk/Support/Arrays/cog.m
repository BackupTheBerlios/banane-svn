%+
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
%-

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