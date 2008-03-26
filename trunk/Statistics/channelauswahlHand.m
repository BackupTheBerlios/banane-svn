%+
% NAME:
%  channelauswahlHand()
%
% VERSION:
%  $Id: channelauswahlHand.m 12.03.2008  version 1.2 Furche$
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
% of units, sorted manually. It differentiates
% between Spike-, noise- and undershoot-units.
%
% CATEGORY:
%  Statistics
%
% SYNTAX:
%* [plxnummer,plxdatei,channel,unita]=channelauswahlHand(noise)
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
%  "speicher", see SyntheticDataHand): 1 - 051123-07Hand-OA.plx
%                                    2 - 070716-04Hand-OA.plx
%                                    3 - 070716-14Hand-OA.plx
%                                    4 - 051123-04Hand-OA.plx
%                                    5 - 051123-12Hand-OA.plx
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
%  sorting manually.
%
% EXAMPLE:
% Get a noisechannel: 
%* [plxnummer,plxdatei,channel,unita]=channelauswahlHand(2)
%
% SEE ALSO:
%  SyntheticDataHand
%
%-



function [plxnummer,plxdatei,channel,unita]=channelauswahlHand(noise)
 %unitchannel= list of channels containing specified spikeunits
 %unitauswahl = list of corresponding spikeunits
 % noisechannel = list of channels containing specified noise units
 % noiseauswahl = list of corresponding noise units
 %nachwellchannel = list of channels containing specified undershoot units
 % nachwellauswahl = list of corresponding undershoot units
    unitchannel=[12,13,16,16,18,19,22,23,28,29,29,47,48,55,56,69,72,77,78,79,82,83,84,89,       1,13,15,34,38,44,45,49,54,56,62,65,73,74,75,87,     16,16,24,24,25,26,27,28,37,38,45,46,47,49,50,52,53,53,55,57,57,59,62,63,64,66,66,67,68,68,71,73,76,77,80,82,84,86,87,90,93,95,95,99,     16,16,18,24,28,46,56,68,72,74,76,77,79,82,83,84,85,86,87,88,90,93,    14,15,16,16,18,19,24,24,24,26,26,27,28,29,33,34,34,34,36,37,37,38,38,39,42,42,43,44,48,52,54,55,56,56,59,62,65,66,72,73,75,77];
    unitauswahl=[2,2,1,3,1,1,1,2,1,2,3,2,1,1,2,3,1,1,1,1,2,1,1,1,      1,1,1,1,2,1,1,2,1,1,1,1,1,1,1,1,           1,4,1,2,1,2,2,1,1,2,1,1,2,1,1,1,1,3,2,1,2,2,2,1,1,1,2,1,1,3,1,1,2,1,2,3,1,2,2,2,1,2,4,1,     1,4,1,3,1,1,2,2,2,1,2,1,1,1,1,1,1,1,1,1,1,1,   1,1,1,3,1,1,2,3,4,3,4,2,2,1,2,1,3,4,1,1,3,1,4,1,1,3,1,1,1,1,1,1,2,3,2,1,1,2,1,2,1,1];
    noisechannel=[12,13,25,28,29,33,36,45,46,47,48,52,55,56,62,64,65,67,68,69,72,75,77,78,84,86,88,95,97,98,99,       13,14,19,24,25,38,39,41,47,48,55,58,62,65,75,77,84,86,88,       6,5,8,16,17,18,19,25,34,35,38,39,40,54,55,59,60,65,66,68,80,84,86,87,90,98,     13,14,16,18,22,24,26,28,29,36,47,56,62,67,68,72,75,79,84,85,86,87,88,89,90,96,   14,15,16,18,19,33,34,38,43,56,62,66,72,73,75,77];
    noiseauswahl=[1,1,1,2,1,1,1,2,1,1,2,1,2,1,1,1,1,1,1,2,2,1,2,2,3,1,1,1,1,1,1,     2,1,1,1,1,1,1,1,1,1,1,1,2,2,2,1,1,1,1,    1,1,1,2,1,1,1,2,2,1,1,1,1,1,1,1,1,3,4,2,1,2,1,1,1,1,   1,2,2,2,1,1,1,2,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,1,2,2,   2,2,2,2,2,1,2,2,2,1,2,1,2,1,2,2];
    nachwellchannel=[16,18,22,56,72,79,83,84,89,   44,49,   71,   16,24,79,84,   26,29,44,52,55,59,65]; %noch angeben
    nachwellauswahl=[2,4,3,3,3,2,3,2,3,   3,4,  3,   3,2,3,3,  5,3,2,3,3,3,3];

    if noise==1 %Spike
    i=ceil(148*rand); %random
    channel=unitchannel(i);
    unita=unitauswahl(i);
        if i<=24 %%entries 1-24 are channels from experiment 051123-07Hand-OA.plx...
            plxdatei='051123-07Hand-OA.plx';
            plxnummer=1;
        elseif i<=40
            plxdatei='070716-04Hand-OA.plx';
            plxnummer=2;
        elseif i<=84
            plxdatei='070716-14Hand-OA.plx';
            plxnummer=3;
        elseif i<=106
            plxdatei='051123-04Hand-OA.plx';
            plxnummer=4;
        else
            plxdatei='051123-12Hand-OA.plx';
            plxnummer=5;
        end
    elseif noise==2 %noise
        i=ceil(118*rand);
        channel=noisechannel(i);
        unita=noiseauswahl(i);
              if i<=31
                plxdatei='051123-07Hand-OA.plx';
                plxnummer=1;
              elseif i<=50
                plxdatei='070716-04Hand-OA.plx';
                plxnummer=2;
              elseif i<=76
                plxdatei='070716-14Hand-OA.plx';
                plxnummer=3;
              elseif i<=102
                plxdatei='051123-04Hand-OA.plx';
                plxnummer=4;
              else
                plxdatei='051123-12Hand-OA.plx';
                plxnummer=5;
              end
    else %undershoot
          i=ceil(23*rand); 
          channel=nachwellchannel(i);
          unita=nachwellauswahl(i);  
              if i<=9
                plxdatei='051123-07Hand-OA.plx';
                plxnummer=1;
              elseif i<=11
                plxdatei='070716-04Hand-OA.plx';
                plxnummer=2;
               elseif i<=12
                plxdatei='070716-14Hand-OA.plx';
                plxnummer=3;
              elseif i<=16
                plxdatei='051123-04Hand-OA.plx';
                plxnummer=4;
              else
                plxdatei='051123-12Hand-OA.plx';
                plxnummer=5;
              end
    end
