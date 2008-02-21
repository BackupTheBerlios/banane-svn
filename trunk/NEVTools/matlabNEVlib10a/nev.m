%+
% NAME:
%  nev()
%
% VERSION:
%  $Id: nev.m 2000-09-08  version 1.0 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  08/09/00
%
% AIM:
%  This is the constructor for the nev class based on the nev specification 2.0. This is a 
% MATLAB support function.
%
% DESCRIPTION:
%This is the constructor for the nev class based on the nev specification 2.0. This is a 
% MATLAB support function.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* A = nev(B);
% 
%
% INPUTS:
%  --	
% 
%
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
% --
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  Specification for the NEV file formats NEVspc20.pdf
%  <A>openNEV</A>
%
function A = nev(B);

if nargin == 0,
	A = struct('FileInfo', [], 'HeaderBasic', [], 'HeaderExtended', [], 'SpikeData', [], 'StimulusData', []);
	A = class(A, 'nev');
else
	if strcmp(class(B) , 'nev'),
		A = B;
	else,
		error('Unsupported constructor form for nev class.');
	end
end