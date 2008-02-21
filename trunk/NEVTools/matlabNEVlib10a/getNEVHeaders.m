%+
% NAME:
%  Headers()
%
% VERSION:
%  $Id: Headers.m 2000-09-08 version 1.0 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  08/09/00
%
% AIM:
%  Reads the header information from the NEV file in nevObject.
%
% DESCRIPTION:
% % Reads the header information from the NEV file in nevObject.
%  returns
%	basicHeader - structure containing basic information about the NEV file
%	extendedHeaders - cell array where each cell is an extended header
%
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* [basicHeader, extendedHeaders] = getNEVHeaders(nevObject);
% 
%
% INPUTS:
%--
%
% OPTIONAL INPUTS:
%  --
%
% OUTPUTS:
%   basicHeader:: structure containing basic information about the NEV file
%	extendedHeaders:: cell array where each cell is an extended header
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
function [basicHeader, extendedHeaders] = getNEVHeaders(nevObject);

basicHeader = readNEVBasicHeader(nevObject.FileInfo.fid);
extendedHeaders = readNEVExtendedHeaders(nevObject.FileInfo.fid);

