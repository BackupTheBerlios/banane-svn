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