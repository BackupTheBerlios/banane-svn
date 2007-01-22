%+
% NAME:
%  loadNEV()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  A. Branner
%
% DATE CREATED:
%  9/2002
%
% AIM:
%  Testchange1. Read all important information from a NEV file.
%
% DESCRIPTION:
%  loadNEV opens a Neural Event (NEV) file and extracts all information
%  from this file into a MATLAB structure array. Particular channels can
%  be selected. In addition, waveforms and non-neural experiment
%  information can be loaded in. A detailed documentation can be found in
%  the file cyberkinetics_docu.pdf, which is located in the same
%  directory.<BR>
%  The routine was originally written by A. Branner, Copyright (c) 9/2002
%  by Bionic Technologies, LLC. All Rights Reserved. The version included
%  in the Banane repository is slightly modified from the original: we
%  corrected a typo in a structure tag that otherwise caused the routine
%  to stop. 
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* nevObject = loadNEV(filename[, channellist][, units][, detail]); 
%
% INPUTS:
%  filename:: String containing the name and possibly the path for the
%             file to be read.
%
% OPTIONAL INPUTS:
%  channellist:: Array of channels to be imported.
%  units:: Pass string 'no' to only load classified units.
%  detail:: Pass string 'all' to load all waveforms and stimulus
%  info. Pass string 'wav' to load all waveforms. Pass string 'exp' to
%  load all stimulus info. 
%
% OUTPUTS:
%  nevObject:: A structure array with various tags that contain the
%  information within the NEV file. Most notably: <BR>
%   nevObject.<BR>
%       |-.HeaderBasic<BR>
%             |-.timeResolution - time resolution of time stamps<BR>
%             |-.sampleResolution - time resolution of waveform samples<BR>
%       |-.SpikeData - matrix with all channels/units selected<BR>
%             |-.timestamps - timestamps on the particular channel and unit<BR>
%  There are many more tags, which are describe in detail in
%  cyberkinetics_docu.pdf.
%
% RESTRICTIONS:
%  None known so far.
%
% PROCEDURE:
%  Since this is an adopted routine, its working is not exactly known.
%
% EXAMPLE:
%  Read data of channels 14,15 ,and 19 in the file
%  '051123-02.nev'. Include wavform information.
%* data=loadNEV('/pfad/zum/datenverzeichnis/051123-02.nev',[14,15,19],'all');
%  
%  Display waveform of 105th event on channel 15:
%* plot(data.SpikeData(15).waveforms(:,105))
%
% SEE ALSO:
%  cyberkinetics_docu.pdf
%-



function nevVariable = loadNEV(filename, varargin);
  
    originalDirectory = cd;

nounclass = 1;
wav = 0;
exp = 0;
channellist = [1:255];
try, if isempty(varargin), channellist = [1:255]; end; catch, channellist = [1:255]; end;