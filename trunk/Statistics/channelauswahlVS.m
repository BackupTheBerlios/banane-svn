%+
% NAME:
%  channelauswahlVS()
%
% VERSION:
%  $Id: channelauswahlVS.m 12.03.2008  version 1.2 Furche$
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
%* [plxnummer,plxdatei,channel,unita]=channelauswahlVS(noise)
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
%  "speicher", see SyntheticDatVS): 1 - 051123-07VS-OA.plx
%                                    2 - 070716-04VS-OA.plx
%                                    3 - 070716-14VS-OA.plx
%                                    4 - 051123-04VS-OA.plx
%                                    5 - 051123-12VS-OA.plx
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
%* [plxnummer,plxdatei,channel,unita]=channelauswahlVS(2)
%
% SEE ALSO:
%  SyntheticDataVS
%
%-
function [plxnummer,plxdatei,channel,unita]=channelauswahlVS(noise)

 %unitchannel= list of channels containing specified spikeunits
 %unitauswahl = list of corresponding spikeunits
 % noisechannel = list of channels containing specified noise units
 % noiseauswahl = list of corresponding noise units
 %nachwellchannel = list of channels containing specified undershoot units
 % nachwellauswahl = list of corresponding undershoot units
    unitchannel=[16,17,22,28,47,48,58,69,72,78,79,84,   1,13,14,15,26,29,34,38,44,45,47,54,56,62,62,65,73,75,87,       16,26,27,37,38,39,46,49,50,53,62,64,66,68,72,73,74,77,82,84,86,87,88,93,95,96,97,99,    13,16,18,19,26,28,29,46,68,72,74,78,79,83,84,85,86,88,90,93,96,       14,15,16,18,26,26,28,29,34,34,34,37,37,38,42,42,43,48,52,55,59,62,65,72,75];
    unitauswahl=[1,2,2,1,2,1,1,3,2,2,3,1,   1,1,2,2,2,1,3,1,3,2,4,4,2,2,3,1,1,1,1,           3,2,3,2,2,3,1,1,2,1,2,1,2,1,3,2,3,1,3,2,2,1,2,1,2,1,2,2,           2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,3,3,2,1,2,2,     1,2,2,1,3,4,2,2,2,3,4,1,3,1,1,2,1,3,2,3,2,2,2,1,2];
    noisechannel=[12,13,17,23,25,26,28,33,36,38,45,46,47,48,52,55,58,62,63,64,65,67,68,72,78,86,99,      13,14,38,39,46,47,49,55,56,62,67,75,84,87,88,       5,6,17,18,19,26,38,50,55,60,62,68,75,84,86,88,92,96,98,      13,14,18,22,26,28,29,46,47,56,66,67,68,72,75,78,89,90,93,96,      14,15,18,28,33,34,43,53,62,64,66,75,82,47,53,56,77,83];
    noiseauswahl=[1,1,1,1,1,1,2,1,1,1,2,1,1,2,1,1,3,1,1,1,1,1,1,1,1,1,1,       2,1,2,1,1,1,2,1,1,1,1,2,1,2,1,       1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,1,2,1,     1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,         2,1,2,1,1,1,2,2,1,1,1,1,1,1,2,1,1,1];
    nachwellchannel=[16,84,   49,71,    16,24,84,  44,55]; %noch angeben
    nachwellauswahl=[4,2,   2,3,   4,5,3,   1,2];
    

    if noise==1 %Spike
    i=ceil(105*rand); %random
    channel=unitchannel(i);
    unita=unitauswahl(i);
        if i<=12 %entries 1-12 are channels from experiment 051123-07VS-OA.plx...
            plxdatei='051123-07VS-OA.plx';
            plxnummer=1;
        elseif i<=31
            plxdatei='070716-04VS-OA.plx';
            plxnummer=2;
        elseif i<=59
            plxdatei='070716-14VS-OA.plx';
            plxnummer=3;
        elseif i<=80
            plxdatei='051123-04VS-OA.plx';
            plxnummer=4;
        else
            plxdatei='051123-12VS-OA.plx';
            plxnummer=5;
        end
    elseif noise==2 %noise
        i=ceil(99*rand);
        channel=noisechannel(i);
        unita=noiseauswahl(i);
              if i<=27
                plxdatei='051123-07VS-OA.plx';
                plxnummer=1;
              elseif i<=42
                plxdatei='070716-04VS-OA.plx';
                plxnummer=2;
              elseif i<=61
                plxdatei='070716-14VS-OA.plx';
                plxnummer=3;
              elseif i<=81
                plxdatei='051123-04VS-OA.plx';
                plxnummer=4;
              else
                plxdatei='051123-12VS-OA.plx';
                plxnummer=5;
              end
    else %undershoot
          i=ceil(9*rand); 
          channel=nachwellchannel(i);
          unita=nachwellauswahl(i);  
              if i<=2
                plxdatei='051123-07VS-OA.plx';
                plxnummer=1;
              elseif i<=4
                plxdatei='070716-14VS-OA.plx';
                plxnummer=3;
              elseif i<=7
                plxdatei='051123-04VS-OA.plx';
                plxnummer=4;
              else
                plxdatei='051123-12VS-OA.plx';
                plxnummer=5;
              end
    end
