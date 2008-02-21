function result = parseNEV(filename, breakPoints);
%function result = parseNEV(filename, [fraction = 0.5] OR [time]);
%
% Used to parse a large NEV file into smaller files that can be later
% remerged.
% Inputs:
%	filename - string filename for the NEV file to use
%	fraction = breakpoints expressed as a percentage (0.0 - 1.0) of the packets
%	time  = breakpoints expressed in seconds (must be > 1.0 seconds)
%
% Written by: E. Maynard
% Version : 1.2 Date: 10/3/00
% Copyright: 2000 Bionic Technologies, Inc.

if ~exist('breakPoints'), breakPoints = 0.5; end;
breakPoints = [0 breakPoints(:)' inf];

% Open the nev file and get the basic packet information
if ~isa(filename, 'nev'),
	nev = opennev(filename);
else,
	nev = filename;
end
% Load the header information
fid = nev.FileInfo.fid;
fseek(fid, 0, 'bof');
headerData = fread(fid, nev.HeaderBasic.dataOffset, 'uchar');

% Write the destination files at the breakpoints
[p,n,e] = fileparts(nev.FileInfo.source);
for i = 1 : length(breakPoints)-1,
	newfile = sprintf('%s_%d', n, i);
	outputname = fullfile(p, [newfile e]);
	outfid = fopen(outputname, 'w');
	fwrite(outfid, headerData, 'uchar'); % Write the header information to the destination file.
% Find the starting index
	if breakPoints(i) == 0.0,
		start = 1;
	else,
		if breakPoints(i) < 1.0,
			start = ceil(breakPoints(i) .* nev.FileInfo.packetCount);
		else,
			start = floor(searchnevbytime(nev, breakPoints(i)));
		end
	end
% Find the ending index
	if isinf(breakPoints(i+1)),
		stop = nev.FileInfo.packetCount;
	else,
		if breakPoints(i+1) < 1.0,
			stop = floor(breakPoints(i+1) .* nev.FileInfo.packetCount);
		else,
			stop = floor(searchnevbytime(nev, breakPoints(i+1))) - 1;
		end	
	end
% Copy the blocks of data to the destination file
	for j = start : 10000 : stop,
		I = j; J = j + 9999; if J > stop, J = stop; end;
		Q = J - I + 1;
		fseek(fid, (I-1) * nev.HeaderBasic.packetLength + nev.HeaderBasic.dataOffset, 'bof');
		B = fread(fid, Q * nev.HeaderBasic.packetLength, 'uchar');
		fwrite(outfid, B, 'uchar');
		disp(J);
	end
	fclose(outfid);
	disp('---------------------- File Done.');
end
