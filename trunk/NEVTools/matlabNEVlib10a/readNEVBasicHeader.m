%+
% NAME:
%  readNEVBasicHeader()
%
% VERSION:
%  $Id: ReadNEVBasicHeader.m 2000-09-08 version 1.0 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
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
% This function is called by openNEV to read the basic header information from version 
% 2.0 NEV files. File must be open and have read access permission.
%
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* A = readNEVBasicHeader(fid); 
% (not designed to be called alone)
% 
%
% INPUTS:
% --
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
%-
function A = readNEVBasicHeader(fid);

fseek(fid, 0, 'bof');
A.fileTypeID = char(fread(fid, 8, 'char')');
A.fileSpec = fread(fid, 1, 'uchar') + fread(fid, 1, 'uchar')/10.0;
if A.fileSpec < 2.0, error('Attempting to open a non-2.0 compliant NEV file.'); end;
A.formatAddtl = fread(fid, 1, 'uint16');
A.dataOffset = fread(fid, 1, 'uint32');
A.packetLength = fread(fid, 1, 'uint32');
A.timeResolution = fread(fid, 1, 'uint32');
A.sampleResolution = fread(fid, 1, 'uint32');
A.TimeOrigin = fread(fid, 8, 'uint16');
A.application = deblank(char(fread(fid, 32, 'uchar')'));
A.comment = deblank(char(fread(fid, 256, 'char')'));
A.headerCount = fread(fid, 1, 'uint32');