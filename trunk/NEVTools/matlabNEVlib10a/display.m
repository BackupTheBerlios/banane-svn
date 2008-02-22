%+
% NAME:
%  display()
%
% VERSION:
%  $Id: display.m 2000-09-08 version 1.0 E. Maynard$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  08/09/00
%
% AIM:
%  Overloaded function to evaluate equality of NEV objects. This is a MATLAB support function
% for the NEV class.
%
% DESCRIPTION:
% Overloaded function to evaluate equality of NEV objects. This is a MATLAB support function
% for the NEV class.
%
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
% --
% 
%
% INPUTS:
% --
%
% OPTIONAL INPUTS:
%  --
%
% OUTPUTS:
%  --
%
%
%
% PROCEDURE:
%  Since this is an adopted routine, its working is not exactly known.
%
% EXAMPLE:
%  --
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  <A>openNEV</A>, Specification for the NEV file formats NEVspc20.pdf
%
%-


function EQ(A, B)


disp('- NEV file object with fields:');
disp(struct(A));