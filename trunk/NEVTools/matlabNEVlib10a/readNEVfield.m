%+
% NAME:
%  readNEVfield()
%
% VERSION:
%  $Id: ReadNEVfield.m 2000-09-08 version 1.0 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  08/09/00
%
% AIM:
% This file is provided for compatibility only. Use readNEVpacket instead.
%
%
% DESCRIPTION:
%  This file is provided for compatibility only. Use readNEVpacket instead.
%
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* [fieldData, count] = readNEVfield(fid, field, offsets, packetLength,
% bytesPerSample);
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
%  <A>readNEVpacket</A>, Specification for the NEV file formats NEVspc20.pdf
%
%-
function [fieldData, count] = readNEVfield(fid, field, offsets, packetLength, bytesPerSample);

fieldData = readNEVpacket(fid, offsets, packetLength, bytesPerSample, field);
count = size(fieldData, 1);


