%+
% NAME:
%  display()
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
%  Mandatory display method for classic list data structure.
%
% DESCRIPTION:
%  Displays the contents of a list object.
%
% CATEGORY:
%  Support Routines<BR>
%  Classes
%
% SYNTAX:
%* display(list); 
%
% INPUTS:
%  list:: The list whose contents are to be displayed.
%
% OUTPUTS:
%  screen:: Text output of the list entries. 
%
% PROCEDURE:
%  Since the list is based on a cell array, the display method refers to
%  the cell array's display routine.
%
% EXAMPLE:
%* >> i=rand(4,1)
%* i =
%*     0.5440
%*     0.2502
%*     0.2234
%*     0.5220
%* >> l=list(i);
%* >> display(l);
%*     [0.5440]
%*     [0.2502]
%*     [0.2234]
%*     [0.5220]
%
% SEE ALSO:
%  <A>list</A>, <A>insert</A>, <A>retrieve</A>, <A>kill</A>.
%
%-


function display(l)
  display(l.hook);

