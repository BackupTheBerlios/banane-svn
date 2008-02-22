%+
% NAME:
%  openNEV()
%
% VERSION:
%  $Id: openNEV.m 2000-09-08  version 1.0 E. Maynard $
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  09/08/00
%
% AIM:
%  Opens NEV-files and creates a NEV class object in Matlab for subsequent
%  operations
%
% DESCRIPTION:
% Opens the specified NEV file for subsequent operations. Reads the header information, 
% and returns a NEV class object. File is opened in a platform-independent fashion enabling
% files collected on PCs to be analyzed with Matlab on Mac and UNIX machines. Passing in a 
% previously saved NEV object reopens the file connection to the original file.
% The routine is part of the toolbox matlabNEVlib10a. The spike data has to
% be imported seperately using getNEVSpikes.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* nevVariable = openNEV(filename);
% 
%
% INPUTS:
%  filename:: filename, NEV file has to be in current directory
%
% OPTIONAL INPUTS:
%  --
%
% OUTPUTS:
%  nevVariable:: Matlab NEV object for subsequent operations
%   A structure array with various tags that contain the
%  information within the NEV file. Most notably:
% |-.FileInfo -> additional information about the NEV file
%	|-.source -> file path and name for the open NEV file
% 	|-.packetCount -> number of packets in the NEV file
% 	|-.fid -> Matlab file pointer to the open NEV file
% 	|-.bytesPerWaveformSample -> number of bytes per waveform sample
% |-.HeaderBasic -> basic information about the NEV file
% 	(see documentation on NEV file for information of fields)
% |-.HeaderExtended -> information about each electrode in the NEV file
% 	(see documentation on NEV file for information of fields)
% |-.SpikeData -> basic information about spike packets (this is filled by the 'getNEVSpikes' function but user may store data here)
%
%
%
%
% PROCEDURE:
%  Since this is an adopted routine, its working is not exactly known.
%
% EXAMPLE:
% Open the NEV file 'experiment01':
%* Neu = openNEV('experiment01.nev');
% Get information about the number of packets in the file:
%* Neu.FileInfo.packetCount
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  <A>getNEVSpikes</A>, Specification for the NEV file formats NEVspc20.pdf
%
%-

function nevVariable = openNEV(filename);

originalDirectory = cd;
if isa(filename, 'nev'),
	disp('Establishing link to former NEV file...');
	fid = fopen(filename.FileInfo.source, 'r+', 'ieee-le');
	if fid == -1, error(['Unable to locate file ' filename.FileInfo.source]); end;
	filename.FileInfo.fid = fid;
	nevVariable = filename;
else,
	fid = fopen(filename, 'r+', 'ieee-le');
	if fid == -1, error(['Unable to locate file ' filename]); end;
	
	nevVariable = nev;
	nevVariable.FileInfo = struct('source', [], 'fid', [], 'packetCount', [], 'bytesPerWaveformSample', []);
	[p, n, e] = fileparts(fopen(fid));
	if ~isempty(p), cd(p); end;
	nevVariable.FileInfo.source = which([n e]);
	nevVariable.FileInfo.fid = fid;
	cd(originalDirectory)
	
	[A, B] = getNEVHeaders(nevVariable);
	nevVariable.HeaderBasic = A;
	nevVariable.HeaderExtended = B;
	
	
	fseek(fid, 0, 'eof');
	nevVariable.FileInfo.packetCount = (ftell(fid) - nevVariable.HeaderBasic.dataOffset) / nevVariable.HeaderBasic.packetLength;
	
	Z = nevVariable.HeaderExtended.bytesPerSample;
	nevVariable.FileInfo.bytesPerWaveformSample = mean(Z(~isnan(Z)));
	disp(nevVariable.FileInfo);
end

if (nargout == 0) & isa(filename, 'nev'),
	assignin('caller', inputname(1), nevVariable);
elseif (nargout == 0) & ~isa(filename, 'nev'),
	assignin('caller', 'nevfile', nevVariable);
end