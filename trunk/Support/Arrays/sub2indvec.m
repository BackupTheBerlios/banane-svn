%+
% NAME:
%  sub2indvec()
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
%  Convert multi dimensional matrix subscripts to linear index.
%
% DESCRIPTION:
%  This routine converts a row vector of multi dimensional matrix
%  subscripts to a single linear index depending on the size of the
%  matrix. It is an addition to MATLAB's own sub2ind routine, with the
%  difference that the subscripts are passed to the routine as a vector
%  instead of separate arguments. This enables a more flexible handling
%  of matrixes 
%  with dimensions that are unknown at the time of programming.
%
% CATEGORY:
%  Support Routines<BR>
%   Arrays
%
% SYNTAX:
%* i=sub2indvec(sizeinfo,subvec); 
%
% INPUTS:
%  sizeinfo:: The dimension information about the
%  matrix. <VAR>sizeinfo</VAR> is an n-element vector that specifies the
%  size of each array dimension, as returned by MATLAB's size() function.
%  subvec:: A row vector consisting of multidimensional subscripts.
%
% OUTPUTS:
%  i:: The linear index equivalent to the set of subscripts <VAR>subvec</VAR>
%  for an array of size <VAR>sizeinfo</VAR>.
%
% RESTRICTIONS:
%  Only row vectors are allowed as input, corresponding to the conversion
%  of a single set of subscripts. A future version should be able to
%  convert multiple sets with a single function call. 
%
% PROCEDURE:
%  See source code of MATLAB's sub2ind routine.
%
% EXAMPLE:
%* >> m=rand(4,3);
%* >> sm=size(m);
%* >> i=sub2indvec(sm,[2,3])
%* i =
%*     10
%* >> m(i)
%* ans =
%*     0.3529
%* >> m(2,3)
%* ans =
%*     0.3529
%
% SEE ALSO:
%  <A>ind2subvec</A>, MATLAB's sub2ind and ind2sub. 
%-


function i=sub2indvec(sizeinfo,subvec)
  
  svec=size(subvec);
  
  if (length(svec)>2)||(svec(1)>1)
    error('In this version, only row vectors are allowed as input.')
  end
  
  if (numel(sizeinfo)~=numel(subvec))
    error('Number of dimensions in sizeinfo and subscript vector must agree.')
  end
  
  k=[1 cumprod(sizeinfo(1:end-1))].';
  
  subvec(2:end)=subvec(2:end)-1;
  
  i=subvec*k;