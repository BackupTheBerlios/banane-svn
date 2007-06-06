%+
% NAME:
%  list()
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
%  Constructor method for classic list data structure.
%
% DESCRIPTION:
%  Use this command to create a MATLAB object representing a list data
%  structure. The list is able to hold an ordered series of data items of
%  miscellaneous type. Easy access to the items is provided by the
%  <A>insert</A> and <A>retrieve</A> commands. The list functionality is
%  not fully implemented yet but rather provides the basis for the
%  <A>stack</A> object. 
%
% CATEGORY:
%   Support Routines<BR>
%   Classes
%
% SYNTAX:
%* l = list([arg]); 
%
% OPTIONAL INPUTS:
%  arg:: Data that is inserted into the list. The result depends on the
%  type of <VAR>arg</VAR>, see Outputs section for details.  
%
% OUTPUTS:
%  l:: The resulting list object. If <VAR>arg</VAR> is missing, the list is
%      generated but holds no contents. If <VAR>arg</VAR> is a list
%      object already, the identical object is returned in
%      <VAR>l</VAR>. If <VAR>arg</VAR> is a numerical array, the array
%      entries are inserted into the list in the same order as they
%      appear in the array, with the array regarded as a single
%      column.. If <VAR>arg</VAR> is a vertical string array, 
%      the resulting list contains the strings as items. If
%      <VAR>arg</VAR> is a cell array, this cell array is converted to a
%      list with the list items corresponding to the cells in single
%      column order.
%
% PROCEDURE:
%  The list object is based on a cell array. After checking of the
%  argument number, the input is converted into a cell array and
%  integrated into the newly formed list object.
%
% EXAMPLE:
%* >> i=rand(4,1)
%* i =
%*     0.5440
%*     0.2502
%*     0.2234
%*     0.5220
%* 
%* >> l=list(i)
%*     [0.5440]
%*     [0.2502]
%*     [0.2234]
%*     [0.5220]
%* 
%* >> s = strvcat('Hello','Yes','No','Goodbye')
%* s =
%* Hello  
%* Yes    
%* No     
%* Goodbye
%* 
%* >> l=list(s)
%*     'Hello'
%*     'Yes'
%*     'No'
%*     'Goodbye'
%
% SEE ALSO:
%  <A>insert</A>, <A>retrieve</A>, <A>kill</A>, <A>stack</A>. 
%-


function l = list(varargin)
  
  switch nargin
    
   case 0
    ca=cell(1);
    l.hook = ca;
    l = class(l,'list');
   
   case 1
   
    arg=varargin{1};
    
    if isnumeric(arg)
      argtype='numeric';
    else
      argtype=class(arg);
    end
    
    switch argtype
     case 'list'
      l = arg;
     case 'numeric'
      l.hook = num2cell(arg(:));
      l = class(l,'list');
     case 'char'
      l.hook = cellstr(arg);
      l = class(l,'list');
     case 'cell'
      l.hook = arg(:);
      l = class(l,'list');
     otherwise
      error(['Unable to convert argument of class ' ...
             argtype ' to list.']);
    end % switch
   
   otherwise
   
    error('Wrong number of input arguments')
  
  end % switch
  

