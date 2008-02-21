%+
% NAME:
%  closeNEV()
%
% VERSION:
%  $Id: closeNEV.m 2000-09-08 version 1.0 E. Maynard$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  08/09/00
%
% AIM:
%  Closes the desired NEV file and deletes the NEV object.
%
% DESCRIPTION:
% Closes the desired NEV file and deletes the NEV object. Although not necessary,
% good programming practice suggests that you use this function to release file access
% information from the system.
%
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* A = closeNEV(A);
% 
%
% INPUTS:
%	A:: NEV object
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
%  Close the exisiting NEV object 'Neu':
%  * closeNEV(Neu)
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  <A>openNEV</A>, Specification for the NEV file formats NEVspc20.pdf
%
%

function A = closeNEV(A);

fclose(A.FileInfo.fid);
A.FileInfo.fid = -1;
if nargout == 0,
	assignin('caller', inputname(1), A);
end