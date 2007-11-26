%+
% NAME:
%  ind2subvec()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  10/2007
%
% AIM:
%  Short description of the routine in a single line.
%
% DESCRIPTION:
%  ind2subvec() is used to determine the equivalent subscript values
%  corresponding to a given single index into an array. It works analogous
%  to MATLAB's own ind2sub() routine, with the difference that the resulting
%  subscripts are returned within a single vector instead of multiple
%  output variables. This enables a more flexible handling of matrixes
%  with dimensions that are unknown at the time of programming.
%
% CATEGORY:
%  Support Routines<BR>
%  Arrays
%
% SYNTAX:
%* out = ind2subvec(siz,ndx); 
%
% INPUTS:
%  siz:: The dimension information about the
%  matrix. <VAR>sizeinfo</VAR> is an n-element vector that specifies the
%  size of each array dimension, as returned by MATLAB's size() function.
%  ndx:: The linear index into the matrix.
%
% OUTPUTS:
%  result:: A row vector containing the equivalent n-dimensional array
%  subscripts 
%   equivalent to <VAR>ndx</VAR> for an array of size <VAR>siz</VAR>.
%
% RESTRICTIONS:
%  Presently, the routine can only convert a single index. This may be
%  improved to handle also a list of indices.
%
% PROCEDURE:
%  Same as MATLAB's ind2sub() with a different output format.
%
% EXAMPLE:
%* >> m=rand(4,3);
%* >> sm=size(m);
%* >> s=ind2subvec(sm,5)
%* s =
%*     1     2
%* >> m(5)
%* ans =
%*     0.9355
%* >> m(s(1),s(2))
%* ans =
%*     0.9355
%
% SEE ALSO:
%  <A>sub2indvec</A>, MATLAB's ind2sub and sub2ind. 
%-

function out = ind2subvec(siz,ndx)

  n = length(siz);
  k = [1 cumprod(siz(1:end-1))];
  ndx = ndx - 1;
  out=zeros(1,n);
  for i = n:-1:1,
    v = floor(ndx/k(i))+1;  
    out(i) = v; 
    ndx = rem(ndx,k(i));
  end % for
