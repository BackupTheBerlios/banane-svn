%+
% NAME:
%  repel()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  6/2007
%
% AIM:
%  Replicate elements of column or line vectors.
%
% DESCRIPTION:
%  repel() replicates the elements of one dimensional array, i.e. a
%  row or a column vector, a constant number of times. The routine was
%  adopted from Peter J. Acklam's "MATLAB array manipulation tips and
%  tricks".
%
% CATEGORY:
%  Support Routines<BR>
%  Arrays
%
% SYNTAX:
%* result = repel(vec, n); 
%
% INPUTS:
%  vec:: The vector to be expanded.
%  n:: Specifies how often each element in <VAR>vec</VAR> is to be
%  repeated.
%
% OPTIONAL INPUTS:
%  bla
%
% OUTPUTS:
%  result:: In the vector returned by the routine, each element of the
%  original vector will be repeated <VAR>n</VAR> times. The output vector
%  is organized like the input vector, either as a row or a column. 
%
% PROCEDURE:
%  Intelligent indexing and transposing.
%
% EXAMPLE:
%* i=(1:3);
%* data=repel(in,4)
%*> data =
%*>  1     1     1     1     2     2     2     2     3     3     3     3
%
%-

function out=repel(in,times)
  
  if (size(in,1)>1)
    b = in(:,ones(1,times)).';
    out = b(:);
  else
    b = in(ones(1,times),:);
    out=b(:).';
  end
  
end
  