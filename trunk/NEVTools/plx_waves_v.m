%+
% NAME:
%  plx_waves_v()
%
% VERSION:
%  $Id: plx_waves_v.m 10/23/06 Plexon$
%
% AUTHOR:
%  Plexon Neurotechnology research systems 
%
% DATE CREATED:
%  10/23/06
%
% AIM:
% Reads waveform data from a plx file.
%
% DESCRIPTION:
% This function uses mexPlex to scan the .plx file for waveform data. It
% gives the number of waves, the number of points in each waveform,
% the timestamps and the waveform itself.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* [n, npw, ts, wave] = plx_waves_v(filename, ch, u)
% 
%
% INPUTS:
%   filename:: if empty string, will use File Open dialog
%   channel:: 1-based channel number
%   unit:: unit number (0- unsorted, 1-4 units a-d)
%
%
% OUTPUTS:
%   n:: number of waveforms
%   npw:: number of points in each waveform
%   ts:: array of timestamps (in seconds) 
%   wave:: array of waveforms [npw, n] converted to mV
%
%
%
% PROCEDURE:
%  Since this is an adopted routine, its working is not exactly known.
%
% EXAMPLE:
% Get waveform Data for the .plx file 'experiment3', channel 56 unit 3: 
%* [n, npw, ts, wave] = plx_waves_v('experiment3.plx', 56, 3)
%
% SEE ALSO:
% mexPlex
%
%-


function [n, npw, ts, wave] = plx_waves_v(filename, ch, u)

[n, npw, ts, wave] = mexPlex(19,filename, ch, u);
