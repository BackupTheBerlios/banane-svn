%+
%NAME:
%  interspikefktplx2()
%
% VERSION:
%   $Id: Version 1 12.03.2008 Furche$
%
% AUTHOR:
%   Julia Furche
%
% DATE CREATED:
%   03/2008
%
% AIM:
% Creates interspike intervals based on ISI-histograms of real data	
%
% DESCRIPTION:
% The function generates interspike intervals and corresponding
% timestamps for a number of spikes given by the variable "laenge". The
% intervals are randomly set based on the underlying distribution of the
% real data where ISI histograms obtain the probability for the appearence 
% of each spike.
%
% CATEGORY:
%  Statistics
%
% SYNTAX:
%* [abstaende,timestamps,streckfaktor]=interspikefktplx2(Neu,ch,u,laenge);
%
% INPUTS:	
% Neu: plx datafile that containes the spike unit providing a base	
% ch: 	Channel in the plx-file which redorded the base spike unit
% u: Value specifying the base spike unit
% laenge: number of spikes which timestamps shall be constructed for
%
% OUTPUTS:	
% abstaende: 	Vector containing the generated interspike intervals (in
% samples)
% timestamps: Vector containing the generated timestamps for each synthetic spike
% streckfaktor: List of factors that were used to stretch the timestamps in
% order to reach the experiment length (see below)
%
% RESTRICTIONS:
% The experiment length is set to 43500000 samples by
% default. Change this value for other experiments in order to not mutate
% the ISI-histograms.
%
% EXAMPLE:
% Generate timestamps and ISI for 4000 spikes, based on the data
% file 'experiment1.plx', channel 5 unit 2:
% *[abstaende,timestamps,streckfaktor]=interspikefktplx2('experiment1.plx',5,2,4000);
%
% SEE ALSO:
%  synthwaveformsgleicheanzahl.m, versuch120308.m
%-
function [abstaende,timestamps,streckfaktor]=interspikefktplx2(Neu,ch,u,laenge)

[n1, npw, ts, wave] = plx_waves_v(Neu, ch, u); %loading the original data
times=ts*30000; 
diff=(times(2:end)-times(1:end-1)); 
[h,n]=hist(diff,10000); %ISI histogram 10000 bins
wkeiten=h/(n1-1); %probability based on frequency

cumwkeiten=cumsum(wkeiten);
zufall=rand(1,laenge);
klassenbreite=mean(n(2:end)-n(1:end-1)); 

%classifying in bins:
for j=1:laenge;
    [eins,bin]=min(zufall(j)>cumwkeiten); 
    abstand=floor(n(bin)+klassenbreite*rand-klassenbreite/2); %within the bins: samples uniformly distributed
    abstaende(j)=abstand; 
end
abstaende(abstaende<0.0021)=0.0023; %refractory period
timestamps=cumsum(abstaende); 
abstaende=abstaende(2:end); 
streckfaktor=1;

%stretching of the timestamps:
if max(timestamps)<40500000 | max(timestamps)>43500000
    streckfaktor=(40500000+3000000*rand)/max(timestamps);
    timestamps=round(timestamps*streckfaktor);
end