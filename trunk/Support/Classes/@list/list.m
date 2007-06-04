%+
% NAME:
%  list()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  6/2007
%
% AIM:
%  Constructor method for classic list data structure.
%
% DESCRIPTION:
%  Detailed description of the routine. The text may contain small HTML
%  tags like for example <BR> linebreaks or <VAR>variable name
%  typesetting</VAR>. Simple anchors to other banane routines are
%  also allowed, eg <A>kwextract</A>.
%
% CATEGORY:
%   Support Routines<BR>
%   Classes
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
%  will be typeset in a fixed width font. 
%* data=example_function(23,5)
%  
%  Indicate matlab output with *>
%*> ans =
%*>   28
%
% SEE ALSO:
%  <A>insert</A>, <A>retrieve</A>, <A>kill</A>, <A>stack</A>. 
%
%-



function l = list(varargin)
  
  switch nargin
   case 0
    ca=cell(1);
    l.hook = ca;
    l = class(l,'list');
   case 1
    if (isa(varargin{1},'list'))
        l = varargin{1};
    else
      ca=num2cell(varargin{1});
      l.hook = ca;
      l = class(l,'list');
    end
   otherwise
    error('Wrong number of input arguments')
  end

