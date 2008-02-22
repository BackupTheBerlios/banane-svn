%+
% NAME:
%  readNEVpacket()
%
% VERSION:
%  $Id: ReadNEVpacket.m 2000-09-08 version 1.0 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  08/09/00
%
% AIM:
%  Reads in the packets at a given byte offsets.
%
%
% DESCRIPTION:
% Reads in the packets at a given byte offsets.
% If 'field' is not specified then a cell array of structures with the fields appropriate to the 
% packet type is returned. Otherwise, an array (or matrix for waveforms) of the 'field' data
% is returned.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* packet = readNEVpacket(fid, byteOffsets, packetLength, bytesPerSample,
% [field]);
% 
%
% INPUTS:
% --
%
% OPTIONAL INPUTS:
%  --
%
% OUTPUTS:
%   --
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
%  <A>readNEVfield</A>, Specification for the NEV file formats NEVspc20.pdf
%
%-

function packet = readNEVpacket(fid, byteOffsets, packetLength, bytesPerSample, field);


if ~exist('field', 'var'), field = []; end;
% Read in the buffers from the file
Z = zeros(length(byteOffsets), packetLength);
for i = 1 : length(byteOffsets),
	fseek(fid, byteOffsets(i) - ftell(fid), 'cof');
	Z(i, :) = fread(fid, packetLength, 'uchar')';
end

packet = cell(length(byteOffsets), 1);
for i = 1 : size(Z, 1),
	packetID = Z(i, 5:6) * [1 256]';
	if packetID == 0,
		buffer = Z(i, 1:20) .* [1 256 65536 16777216 1 256 1 0 1 256 1 256 1 256 1 256 1 256 1 256];
		packet{i,1}.timeStamp = sum(buffer(1:4));
		packet{i,1}.electrode = sum(buffer(5:6));
		packet{i,1}.trigger = buffer(7);
		packet{i,1}.dio = sum(buffer(9:10));
		packet{i,1}.analog1 = sum(buffer(11:12)); packet{i,1}.analog1 = packet{i,1}.analog1 - (packet{i,1}.analog1 > 32768) * 65536;
		packet{i,1}.analog2 = sum(buffer(13:14)); packet{i,1}.analog2 = packet{i,1}.analog2 - (packet{i,1}.analog2 > 32768) * 65536;
		packet{i,1}.analog3 = sum(buffer(15:16)); packet{i,1}.analog3 = packet{i,1}.analog3 - (packet{i,1}.analog3 > 32768) * 65536;
		packet{i,1}.analog4 = sum(buffer(17:18)); packet{i,1}.analog4 = packet{i,1}.analog4 - (packet{i,1}.analog4 > 32768) * 65536;
		packet{i,1}.analog5 = sum(buffer(19:20)); packet{i,1}.analog5 = packet{i,1}.analog5 - (packet{i,1}.analog5 > 32768) * 65536;
	else
		buffer = Z(i, :);
		S = buffer(1:8) .* [1 256 65536 16777216 1 256 1 0];
		packet{i,1}.timeStamp = sum(S(1:4));
		packet{i,1}.electrode = sum(S(5:6));
		packet{i,1}.unit = S(7);
		if bytesPerSample < 2,
			packet{i,1}.waveform = buffer(9:end) - (buffer(9:end) > 128) .* 256;
		else
			packet{i,1}.waveform = [];
			for i = 9 : 2 : length(buffer),
				packet{i,1}.waveform(end+1) = buffer(i:i+1) * [1 256]';
			end
			packet{i,1}.waveform = packet{i,1}.waveform - (packet{i,1}.waveform > 32768) .* 65536;
		end
		S = length(packet{i, 1}.waveform);
	end
end

if ~isempty(field),
	if strcmp(field, 'waveform'), Z = zeros(length(packet), S); else, Z = zeros(length(packet), 1); end;
	for i = 1 : length(packet),
		try, Z(i,:) = getfield(packet{i}, field); catch, Z(i,:) = nan; end;
	end
	packet = Z;
end
