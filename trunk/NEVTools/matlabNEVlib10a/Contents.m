%+
% NAME:
%  NEV File Toolbox()
%
% VERSION:
%  $Version 1.0 (R11.1) 09-Aug-2000 Copyright (c) 2000 by Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  09/08/00
%
% AIM:
%  Opening/Closing Files, Accessing NEV Files, Misc. Utility Functions
%
% DESCRIPTION:
% Opening/Closing Files
%	openNEV			- used to open a NEV file for use
%	closeNEV			- used to close a NEV file after use. Important to call if used putPackets
%
% Accessing NEV Files
%	searchNEVByField	- search a NEV file from the disk for fields with certain criteria
%	searchNEVByTime	- search the NEV file for particular time indices
%	getPackets			- retrieves information from specified packets in the NEV file
%	putPackets			- updates information in spike packets
%	getNEVHeaders		- retrieves the header information from a NEV file
%	getNEVSpikes		- returns a structure holding information about packets containing spikes
%	getNEVStimulus		- returns a structure holding information about packets containing stimulus information
%
% Misc. Utility Functions
%	lastSpike			- returns the number of spikes in the .SpikeData field of the nev object
%	lastStim				- returns the number of stimulus packets in the .StimuluData field of the nev object
% Examples
%	NEVPlotWaves		- plots the waveforms for all the channels present in a NEV file
% Copyright (c) 2000 by Bionic Technologies, Inc.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
% --
% 
%
% INPUTS:
% --
%
% OPTIONAL INPUTS:
%  --
%
% OUTPUTS:
%  --
%
%
%
% PROCEDURE:
%  Since this is an adopted toolbox, its working is not exactly known. Only
%  the functions 'putpackets' and 'writeNEVfield' have been modified, the
%  rest is originally transfered from the matlabNEVlib10a toolbox.
%
% EXAMPLE:
%  --
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  Specification for the NEV file formats NEVspc20.pdf
%-

