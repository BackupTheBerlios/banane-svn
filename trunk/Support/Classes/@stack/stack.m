%+
% NAME:
%  stack()
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
%  Constructor method for a simple stack data type.
%
% DESCRIPTION:
%  Detailed description.
%
% CATEGORY:
%   Support routines<BR>
%   Classes
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
%  Optional section: Is there anything known that could cause problems?
%
% PROCEDURE:
%  Short description of the algorithm.
%
% EXAMPLE:
%  Indicate example lines with * as the first character. These lines
%  will be typeset in a fixed width font. 
%* data=example_function(23,5)
%  
%  Indicate matlab output with *>
%*> ans =
%*>   28
%
% SEE ALSO:
%  <A>push</A>.
%-

function s = stack(varargin)
  
  switch nargin
   case 0
    s.list = list();
    s = class(s,'stack');
   case 1
    if (isa(varargin{1},'stack'))
        l = varargin{1};
    else
      s.list = list(varargin{1});
      s = class(s,'stack');
    end
   otherwise
    error('Wrong number of input arguments')
  end

