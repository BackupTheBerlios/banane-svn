%+
% NAME:
%  getNEVStimulus()
%
% VERSION:
%  $Id: getNEVStimulus.m 2000-09-29  version 1.2 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  29/09/00
%
% AIM:
% Reads Stimulus information from a NEV file and stores it in a previously
% generated NEV object.
%
% DESCRIPTION:
% This function scans the NEV file and returns a structure containing information about the
% packets containing stimulus information. Sets the 'StimulusData' field of the NEV object. 
% Information returned consists of index, timeStamp, trigger, dio, and a matrix containing the
% analog channel values (each column is an analog channel).
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* stimulus = getNEVStimulus(nevObject, maxPackets, packetStart);
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
% Get Stimulus Data for the NEV-object 'Neu': 
%  * getNEVStimulus(Neu);
% Information can be read by using:
% * Neu.StimulusData
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  Specification for the NEV file formats NEVspc20.pdf
%

function stimulus = getNEVStimulus(nevObject, maxPackets, packetStart);

msg = nargchk(1, 3, nargin); if ~isempty(msg), error(msg); end;
try, if isempty(maxPackets), maxPackets = inf; end; catch, maxPackets = inf; end;
try, if isempty(packetStart), packetStart = 1; end; catch, packetStart = 1; end;

try,

N = min([maxPackets 50000]);
fid = nevObject.FileInfo.fid;
fseek(fid, nevObject.HeaderBasic.dataOffset + (packetStart-1) * nevObject.HeaderBasic.packetLength, 'bof');
stimulus = struct('index', [], 'timeStamp', [], 'trigger', [], 'dio', [], 'analog', []);

H = waitbar(0, 'Getting stimulus information from the NEV file...');
[buffer, count] = fread(fid, N*20, '20*uchar', nevObject.HeaderBasic.packetLength-20);
firstPacket = packetStart;
while count > 0,
	buffer = reshape(buffer, 20, count/20)';
	[R, C] = size(buffer);
% Process the buffer for desired information
	K = find(buffer(:, 5) == 0);
	buffer = buffer(K, :);
	indices = (K-1) + packetStart;
	packetStart = packetStart + R;
% Process the stimulus buffers
	Z = (ones(length(K), 1) * [1 256 65536 16777216 1 256 1 0 1 256 1 256 1 256 1 256 1 256 1 256]) .* buffer;
	analog = [sum(Z(:,11:12)')' sum(Z(:,13:14)')' sum(Z(:,15:16)')' sum(Z(:,17:18)')' sum(Z(:,19:20)')'];;
	analog = analog - (analog > 32768) .* 65536;

	stimulus.index = cat(1, stimulus.index, uint32(indices));
	stimulus.timeStamp = cat(1, stimulus.timeStamp, uint32(sum(Z(:,1:4)')'));
	stimulus.trigger = cat(1, stimulus.trigger, uint8(buffer(:, 7)));
	stimulus.dio = cat(1, stimulus.dio, uint16(sum(Z(:,9:10)')'));
	stimulus.analog = cat(1, stimulus.analog, int16(analog));
% Update user interface
	Z = length(stimulus.index);
	if isinf(maxPackets),
		waitbar((packetStart-firstPacket) / (nevObject.FileInfo.packetCount-firstPacket));
	else
		waitbar(Z / maxPackets);
	end
	if Z >= maxPackets, break; end;
% Load in the next buffer
	[buffer, count] = fread(fid, N*20, '20*uchar', nevObject.HeaderBasic.packetLength-20);
end
close(H);

if length(stimulus.index) > maxPackets,
	stimulus.index = stimulus.index(1:maxPackets);
	stimulus.timeStamp = stimulus.timeStamp(1:maxPackets);
	stimulus.trigger = stimulus.trigger(1:maxPackets);
	stimulus.dio = stimulus.dio(1:maxPackets);
	stimulus.analog = stimulus.analog(1:maxPackets, :);
end

if nargout == 0,
	nevObject.StimulusData = stimulus;
	assignin('caller', inputname(1), nevObject);
end

catch,
	error(lasterr);
end	
