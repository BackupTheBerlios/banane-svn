%+
% NAME:
%  getNEVSpikes()
%
% VERSION:
%  $Id: getNEVSpikes.m 2000-09-29  version 1.2 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  29/09/00
%
% AIM:
% Reads Spike information from a NEV file and stores it in a previously
% generated NEV object.
%
% DESCRIPTION:
% This function scans the NEV file and returns a structure containing information about the
% packets containing spikes information. Sets the 'SpikeData' field of the NEV object. 
% Information returned consists of index, timeStamp, electrode, and unit.
% This routine is part of the toolbox matlabNEVlib10a and shall be called
% after creating the NEV object using openNEV.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* spikes = getNEVSpikes(nevObject, maxPackets, packetStart);
% 
%
% INPUTS:
%  nevObject::object created by 'opennev'
%
%
% OPTIONAL INPUTS:
%    	maxPackets:: maximim number of packets to return
%		packetStart:: packet to begin the scan at
%
% OUTPUTS:
% --
%
%
%
% PROCEDURE:
%  Since this is an adopted routine, its working is not exactly known.
%
% EXAMPLE:
% Get Spike Data for the NEV-object 'Neu': 
%* getNEVSpikes(Neu);
% Information can be read by using:
%* Neu.SpikeData
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  Specification for the NEV file formats NEVspc20.pdf
%-


function spikes = getNEVSpikes(nevObject, maxPackets, packetStart);

msg = nargchk(1, 3, nargin); if ~isempty(msg), error(msg); end;
try, if isempty(maxPackets), maxPackets = inf; end; catch, maxPackets = inf; end;
try, if isempty(packetStart), packetStart = 1; end; catch, packetStart = 1; end;

try,

N = min([maxPackets 50000]);
fid = nevObject.FileInfo.fid;
fseek(fid, nevObject.HeaderBasic.dataOffset + (packetStart-1) * nevObject.HeaderBasic.packetLength, 'bof');
spikes = struct('index', [], 'timeStamp', [], 'electrode', [], 'unit', []);

H = waitbar(0, 'Getting spike information from NEV file...');
[buffer, count] = fread(fid, N*8, '8*uchar', nevObject.HeaderBasic.packetLength-8);
firstPacket = packetStart;
while count > 0,
	buffer = reshape(buffer, 8, count/8)';
	[R, C] = size(buffer);
% Process the buffer for desired information
	K = find(buffer(:, 5) > 0);
	buffer = buffer(K, :);
	indices = (K-1) + packetStart;
	packetStart = packetStart + R;
% Process the spike buffers
	spikes.index = cat(1, spikes.index, uint32(indices));
	spikes.timeStamp = cat(1, spikes.timeStamp, uint32(([1 256 65536 16777216] * buffer(:, 1:4)')'));
	spikes.electrode = cat(1, spikes.electrode, uint8(([1 256] * buffer(:, 5:6)')'));
	spikes.unit = cat(1, spikes.unit, uint8(buffer(:, 7)));
% Update user interface
	Z = length(spikes.index);
	if isinf(maxPackets),
		waitbar((packetStart-firstPacket) / (nevObject.FileInfo.packetCount-firstPacket));
	else
		waitbar(Z / maxPackets);
	end
	if Z >= maxPackets, break; end;
% Load in the next buffer
	[buffer, count] = fread(fid, N*8, '8*uchar', nevObject.HeaderBasic.packetLength-8);
end
close(H);

if length(spikes.index) > maxPackets,
	spikes.index = spikes.index(1:maxPackets);
	spikes.timeStamp = spikes.timeStamp(1:maxPackets);
	spikes.electrode = spikes.electrode(1:maxPackets);
	spikes.unit = spikes.unit(1:maxPackets);
end

if nargout == 0,
	nevObject.SpikeData = spikes;
	assignin('caller', inputname(1), nevObject);
end

catch,
	error(lasterr);
end