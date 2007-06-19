%+
% NAME:
%  insert()
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
%  Insert item into classic list data structure.
%
% DESCRIPTION:
%  Insert data into a given list object. At present, insertion can either
%  be done at the beginning or the end of the list, arbitrary positions
%  are not implemented yet. 
%
% CATEGORY:
%  Support routines<BR>
%  Classes
%
% SYNTAX:
%* l=insert(l,item,position); 
%
% INPUTS:
%  l:: A list object created with the <A>list</A> command.
%  function.
%  item:: The data item to be inserted. Since the list object is based on
%         a MATLAB cell array, <VAR>item</VAR> can be of any type.
%  position:: At present, the <VAR>position</VAR> argument can only take 
%             the values <VAR>'first'</VAR> and <VAR>'last'</VAR>.  
%
% OUTPUTS:
%  l:: The new list object with <VAR>item</VAR> inserted at the
%  respective position.
%
% RESTRICTIONS:
%  See above: position argument is not fully functional yet.
%
% PROCEDURE:
%  Create a new cell array including the value appended.
%
% EXAMPLE:
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
%* 
%* >> l=insert(l,'foobar','first') 
%*     'foobar'
%*     'Hello'
%*     'Yes'
%*     'No'
%*     'Goodbye'
%* 
% SEE ALSO:
%  <A>list</A>, <A>retrieve</A>, <A>kill</A>.
%
%-

function l=insert(l,item,position)
  
  if (isempty(l.hook{1}))
    l.hook={item};
  else
    switch position
     case 'last'
      l.hook(end+1)={item};
     case 'first'
      new=[{item}; l.hook];
      l.hook=new;
     otherwise
      error('Unknown position parameter.')
    end % switch
  end % if