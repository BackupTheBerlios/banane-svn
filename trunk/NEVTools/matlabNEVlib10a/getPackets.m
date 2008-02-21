%+
% NAME:
%  getpackets()
%
% VERSION:
%  $Id: getpackets.m 2000-08-15  version 1.0 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  15/08/00
%
% AIM:
% Used to return information from packets in the NEV file.
%
% DESCRIPTION:
% Unsed to return information from packets in the NEV file. 
% Notes:
%		1) spike waveform data is NOT scaled.
%		2) Index of the first packet is 1.el).
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* [packets, index] = getPackets(nevObject, index, field);
% 
%
% INPUTS:
%  nevObject::object created by 'opennev'
%  index:: list of indices for the packets to retrieve information from
%  field:: string containing the name of the information field to return. Valid fields are:
%			timeStamp, electrode, unit, trigger, dio, analog1, analog2, analog3, analog4, analog5, waveform
%	
% 
%
%
% OPTIONAL INPUTS:
%  --
%
% OUTPUTS:
%  packets:: desired data as either a cell array of structures, structure (1 packet), or array with desired field information 
%		index:: returns the indices of the packets. Useful in case indices are outside of valid ranges
%	
%
%
%
% PROCEDURE:
%  Since this is an adopted routine, its working is not exactly known.
%
% EXAMPLE:
% Get waveform Data for the NEV-object 'Neu' from packets 10-20: 
%  * Waveforms = getPackets(Neu, 10:20, 'waveform');
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  Specification for the NEV file formats NEVspc20.pdf
%  <A>putpackets</A>
%
function [packets, index] = getPackets(nevObject, index, field);

if ~exist('field', 'var'), field = []; end;
fid = nevObject.FileInfo.fid;
N = length(index);
index = double(index((index > 0) & (index <= nevObject.FileInfo.packetCount)));
if length(index) ~= N,
	warning('Attempt to access indicies beyond the end of the NEV file. Number of returned packets may be different than expected.');
end
offsets = ((index-1) .* nevObject.HeaderBasic.packetLength) + nevObject.HeaderBasic.dataOffset;
packets = readNEVpacket(nevObject.FileInfo.fid, offsets, nevObject.HeaderBasic.packetLength, nevObject.FileInfo.bytesPerWaveformSample, field);
if iscell(packets) & (length(index) == 1), packets = packets{1}; end;