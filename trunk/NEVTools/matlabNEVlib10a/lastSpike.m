%+
% NAME:
%  lastSpike()
%
% VERSION:
%  $Id: lastSpike.m 2000-09-16  version 1.0 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  16/09/00
%
% AIM:
% This function returns the number of packets in the .SpikeData field of
% the NEV object.
%
% DESCRIPTION:
% This function returns the number of packets in the .SpikeData field of the NEV object. Use this
% function in place of the 'end' operator when indexing to the last spike packet.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* result = lastSpike(nevObject);
% 
%
% INPUTS:
%  nevObject::object created by 'opennev'	
% 
%
%
% OPTIONAL INPUTS:
%  --
%
% OUTPUTS:
%  result:: number of packets in the .SpikeData field of the NEV object.
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
%  <A>lastStim</A>
%
function result = lastSpike(nevObject);

try,
	result = length(nevObject.SpikeData.index);
catch,
	result = 0;
end
