%+
% NAME:
%  kill()
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
%  Remove data item from a classic list data structure.
%
% DESCRIPTION:
%  The kill() function removes a data item at a specified position from a
%  list data structure.
%
% CATEGORY:
%  Support routines<BR>
%  Classes
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
%  <A>list</A>, <A>insert</A>, <A>retrieve</A>.
%
%-

function l=kill(l,position)
  
  switch position
   case 'last'
    new=l.hook(1:end-1);
    l.hook=new;
   case 'first'
    new=l.hook(2:end);
    l.hook=new;
   otherwise
    error('Unknown position parameter.')
  end % switch