%+
% NAME:
%  channelauswahlEM()
%
% VERSION:
%  $Id: channelauswahlEM.m 12.03.2008  version 1.2 Furche$
%
% AUTHOR:
%  J. Furche 
%
% DATE CREATED:
%  12.03.2008
%
% AIM:
% chooses randomly channel and unit from a preselection
%
% DESCRIPTION:
% This function chooses randomly a channel and a unit from a preselection
% of units, sorted by the automatical T-dist. EM algorithm. It
% differentiates
% between Spike-, noise- and undershoot-units.
%
% CATEGORY:
%  Statistics
%
% SYNTAX:
%* [plxnummer,plxdatei,channel,unita]=channelauswahlEM(noise)
% 
%
% INPUTS:
%  noise:: 1 - A Spikeunit is chosen
%          2 - a noiseunit is chosen
%          3 - a undershoot is chosen
%
%
% OUTPUTS:
%  plxnummer:: number specifying the used plx-file (for storing in
%  "speicher", see SyntheticDataEM): 1 - 051123-07EM-OA.plx
%                                    2 - 070716-04EM-OA.plx
%                                    3 - 070716-14EM-OA.plx
%                                    4 - 051123-04EM-OA.plx
%                                    5 - 051123-12EM-OA.plx
% plxdatei:: string containing the name of the used file, see above.
% channel:: randomly chosen channelnumber
% unita:: corresponding unitnumber
%
%
%
% PROCEDURE:
%  The inputargument decided whether a spikeunit, a noiseunit or an
%  undershoot is obtained. A random number determines the channel, the unit
%  and the corresponding .plx-file that have been specified manually after
%  sorting the file with t-dist EM.
%
% EXAMPLE:
% Get a spikechannel: 
%* [plxnummer,plxdatei,channel,unita]=channelauswahlEM(1)
%
% SEE ALSO:
%  SyntheticDataEM
%
%-



function [plxnummer,plxdatei,channel,unita]=channelauswahlEM(noise)

 %unitchannel= list of channels containing specified spikeunits
 %unitauswahl = list of corresponding spikeunits
 % noisechannel = list of channels containing specified noise units
 % noiseauswahl = list of corresponding noise units
 %nachwellchannel = list of channels containing specified undershoot units
 % nachwellauswahl = list of corresponding undershoot units
    unitchannel=[13,15,16,17,23,28,29,48,48,58,69,72,77,78,79,83,84,89,   13,15,34,44,45,49,56,62,65,73,75,87,       16,27,37,38,46,47,49,50,53,55,62,64,66,68,68,71,72,73,77,80,82,84,86,87,93,95,99,     16,18,24,24,28,46,72,76,77,79,82,84,86,88,89,90,93,       24,14,15,18,18,19,26,27,29,37,37,38,39,39,42,43,44,48,52,53,55,59,62,65,77,83,16];
    unitauswahl=[1,3,4,4,3,2,3,3,1,2,1,4,4,3,5,2,2,5   2,3,1,4,1,2,2,4,2,2,2,2,           4,4,2,3,3,1,2,1,1,2,2,1,2,1,3,3,3,3,3,4,3,2,3,2,1,3,5,           4,4,3,4,2,3,1,2,3,3,3,3,4,4,3,3,2,     5,3,2,1,3,4,4,5,4,1,3,3,2,5,4,2,3,4,3,2,4,4,1,4,2,1,3];
    noisechannel=[13,17,23,26,28,36,38,43,48,58,59,65,52,63,68,69,94,97,98,99,      13,14,19,24,38,45,47,49,55,56,63,65,67,75,77,87,18,        5,6,16,18,19,35,36,50,54,59,62,66,68,75,84,86,88,91,93,98,        14,18,22,24,26,29,36,47,62,72,76,77,78,84,89,90,93,96,74,74,25,      24,15,28,28,33,35,37,38,39,42,43,49,62,77,82,83,47,16,25,39,64];
    noiseauswahl=[2,1,1,1,1,1,1,1,2,1,1,1,1,1,1,2,1,1,1,1,       1,2,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,       1,1,1,1,1,1,1,2,1,1,1,1,2,3,1,2,2,1,2,1,       2,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,2,2,4,2,         4,1,3,2,2,2,2,2,4,3,1,1,2,1,2,2,1,2,1,4,1];
    nachwellchannel=[16,18,78,79,84,89,   46,    16,79,84,90,  14,44,55]; %noch angeben
    nachwellauswahl=[2,4,2,4,1,2,   2,   3,2,2,2,   2,2,3];
    

    if noise==1 %Spike
    i=ceil(101*rand); %random
    channel=unitchannel(i);
    unita=unitauswahl(i);
        if i<=18 %entries 1-18 are channels from experiment 051123-07EM-OA.plx...
            plxdatei='051123-07EM-OA.plx';
            plxnummer=1;
        elseif i<=30
            plxdatei='070716-04EM-OA.plx';
            plxnummer=2;
        elseif i<=57
            plxdatei='070716-14EM-OA.plx';
            plxnummer=3;
        elseif i<=74
            plxdatei='051123-04EM-OA.plx';
            plxnummer=4;
        else
            plxdatei='051123-12EM-OA.plx';
            plxnummer=5;
        end
    elseif noise==2 %Noise
        i=ceil(99*rand);
        channel=noisechannel(i);
        unita=noiseauswahl(i);
              if i<=20
                plxdatei='051123-07EM-OA.plx';
                plxnummer=1;
              elseif i<=37
                plxdatei='070716-04EM-OA.plx';
                plxnummer=2;
              elseif i<=57
                plxdatei='070716-14EM-OA.plx';
                plxnummer=3;
              elseif i<=78
                plxdatei='051123-04EM-OA.plx';
                plxnummer=4;
              else
                plxdatei='051123-12EM-OA.plx';
                plxnummer=5;
              end
    else %undershoot
          i=ceil(14*rand); 
          channel=nachwellchannel(i);
          unita=nachwellauswahl(i);  
              if i<=6
                plxdatei='051123-07EM-OA.plx';
                plxnummer=1;
              elseif i<=7
                plxdatei='070716-14EM-OA.plx';
                plxnummer=3;
              elseif i<=11
                plxdatei='051123-04EM-OA.plx';
                plxnummer=4;
              else
                plxdatei='051123-12EM-OA.plx';
                plxnummer=5;
              end
    end
