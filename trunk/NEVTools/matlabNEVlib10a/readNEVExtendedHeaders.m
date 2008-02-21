%+
% NAME:
%  readNEVExtendedHeaders()
%
% VERSION:
%  $Id: ReadNEVExtendedHeaders.m 2000-09-08 version 1.0 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  08/09/00
%
% AIM:
%  This function is called by openNEV to read the basic header information from version 
% 2.0 NEV files.
%
% DESCRIPTION:
%  This function is called by openNEV to read the extended header information from version 
% 2.0 NEV files. File must be open and have read access permission.
%
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* A = readNEVExtendedHeader(fid); 
% (not designed to be called alone)
% 
%
% INPUTS:
%--
%
% OPTIONAL INPUTS:
%  --
%
% OUTPUTS:
%   
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
%  <A>openNEV</A>, Specification for the NEV file formats NEVspc20.pdf
%
%
function headers  = readNEVExtendedHeaders(fid);

fseek(fid, 332, 'bof');
headerCount = fread(fid, 1, 'uint32');
headers = {};
for i = 1 : headerCount,
	nextHeader = ftell(fid) + 32;
	temp = char(fread(fid, 8, 'char')');
	switch temp,
		case 'NEUEVWAV',
			headers{end+1, 1}.electrode = fread(fid, 1, 'uint16');
			headers{end}.module = fread(fid, 1, 'uchar');
			headers{end}.pin = fread(fid, 1, 'uchar');
			headers{end}.scale = fread(fid, 1, 'uint16');
			headers{end}.energy = fread(fid, 1, 'uint16');
			headers{end}.ampltiudeHi = fread(fid, 1, 'int16');
			headers{end}.amplitudeLo = fread(fid, 1, 'int16');
			headers{end}.unitCount = fread(fid, 1, 'uchar');
			headers{end}.bytesPerSample = fread(fid, 1, 'uchar');
			if headers{end}.bytesPerSample == 0, headers{end}.bytesPerSample = 1; end;
		case 'NSASEXEV',
			headers{end+1, 1}.periodicFreq = fread(fid, 1, 'uint16');
			headers{end}.DIOConfig = fread(fid, 1, 'uchar');
			headers{end}.Analog1Config = fread(fid, 1, 'uchar');
			headers{end}.Analog1Threshold = fread(fid, 1, 'int16');
			headers{end}.Analog2Config = fread(fid, 1, 'uchar');
			headers{end}.Analog2Threshold = fread(fid, 1, 'int16');
			headers{end}.Analog3Config = fread(fid, 1, 'uchar');
			headers{end}.Analog3Threshold = fread(fid, 1, 'int16');
			headers{end}.Analog4Config = fread(fid, 1, 'uchar');
			headers{end}.Analog4Threshold = fread(fid, 1, 'int16');
			headers{end}.Analog5Config = fread(fid, 1, 'uchar');
			headers{end}.Analog5Threshold = fread(fid, 1, 'int16');
		otherwise,
			error('Unrecognized channel information.');
	end
	fseek(fid, nextHeader, 'bof');
end