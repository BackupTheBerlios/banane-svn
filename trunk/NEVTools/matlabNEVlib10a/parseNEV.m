%+
% NAME:
%  parseNEV()
%
% VERSION:
%  $Id: parseNEV.m 10/03/00  version 1.2 E. Maynard $
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  10/03/00
%
% AIM:
%  Used to parse a large NEV file into smaller files that can be later
% remerged.
%
% DESCRIPTION:
% Used to parse a large NEV file into smaller files that can be later
% remerged.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* result = parseNEV(filename, breakPoints);
% 
%
% INPUTS:
%  filename:: string filename for the NEV file to use
%  fraction:: breakpoints expressed as a percentage (0.0 - 1.0) of the packets
%  time:: breakpoints expressed in seconds (must be > 1.0 seconds)
%
% OPTIONAL INPUTS:
%  --
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
% --
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  <A>openNEV</A>, Specification for the NEV file formats NEVspc20.pdf
%
%-
function result = parseNEV(filename, breakPoints);

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
