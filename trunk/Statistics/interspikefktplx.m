%+
% NAME:
%  interspikefktplx()
%
% VERSION:
%  $Id: interspikefktplx.m 2008-02-12 12:54 furche $
%
% AUTHOR:
%  J. Furche 
%
% DATE CREATED:
%  2008-02-12
%
% AIM:
%  Constructs inter-spike intervals based on ISI histograms from real PLX-data.
%
% DESCRIPTION:
% interspikefktplx.m generates a list of inter-spike intervals and timestamps
% for a specified number of spikes. The distribution on the intervals is
% based on an ISI histogram from the real spike data, given in PLX-file
% format; the toolbox 'ReadingPLXandDDTfilesinmatlab' has to be available. 
% 'laenge' random variabled are diced based on the distribution of
% the histogram and stored in an output vector.
%
%
% CATEGORY:
%  Statistics
%
% SYNTAX:
%* [abstaende,timestamps]=interspikefktplx(Neu,ch,u,laenge)
%
% INPUTS:
% Neu:: Name of the plx file, the file has to be in the current directory
% channel:: electrode
% unit:: spike unit
% laenge:: number of the inter-spike intervals that shall be generated
%
% OPTIONAL INPUTS:
%  --
%
% OUTPUTS:
% abstaende:: list containing the inter-spike intervals
% timestamps:: timestamps for the generated spikes (0 corresponds to the
%               first spike event)
%
%
% PROCEDURE:
% The distribution on the intervals is
% based on an ISI histogram from the real spike data.
% Due to outliers not all of the intervals are obtained for the
% calculations. In difference to the function interspikefkt.m the number of
% spiked used depends on the form of the ISI histogram. If it has less 
% outliers, as many spikes are used as long as more than 1.5 per cent lie 
% in each bin of the total histogram. in the other case 80 % are used as 
% before. The data is classed in 100 bins and for each bin the 
% frequency corresponds to the probability which determines the randomly
% set values for the simulated intervals to choose a sample out of the 
% diced interval. The samples within each bin are
% uniformly distributed.
%  
%
% EXAMPLE:
% Generate 14000 inter-spike intervals based on channel 54 unit 2 
% from the plx-file 'experiment1':
% * [abstaende,timestamps,index]=interspikefkt('experiment1.plx',54,2,14000)
%
% SEE ALSO:
%  ReadingPLXandDDTfilesinmatlab toolbox 
%  (http://www.plexoninc.com/support/softwaredevkit.html), 
%  <A>interspikefkt<A/>
%
%-

function [abstaende,timestamps]=interspikefktplx(Neu,ch,u,laenge)

[n, npw, ts, wave] = plx_waves_v(Neu, ch, u);
times=ts*30000;
diff=(times(2:end)-times(1:end-1));
sortiertdiff=sort(diff);
obererGrenzindex=ceil(length(diff)*8/10);
[h,n]=hist(diff,100);
wkeit=h/length(diff);
[m,k]=max(wkeit<0.015); %the first bin with less than 1.5 %
[m,pos]=max(sortiertdiff>n(k));
Ende=max(pos,obererGrenzindex);
kleinediffs=sortiertdiff(1:Ende);
[h,n]=hist(kleinediffs,100);
wkeiten=h/Ende;
cumwkeiten=cumsum(wkeiten);
zufall=rand(1,laenge);
klassenbreite=mean(n(2:end)-n(1:end-1)); 
for j=1:laenge
[eins,bin]=min(zufall(j)>cumwkeiten); 
abstand=floor(n(bin)+klassenbreite*rand-klassenbreite/2); %samples within the bins are uniformly distributed
abstaende(j)=abstand;
end
timestamps=cumsum(abstaende);


figure(1)
hist(kleinediffs,100);
title('Histogram for the real inter-spike intervals')
xlabel('Samples')
text=num2str(sprintf('Number of %g Inter-spike intervals in total',length(kleinediffs)));
ylabel(text)
figure(2)
hist(abstaende,100);
title('Histogram for the simulated inter-spike intervals')
xlabel('Samples')
text=num2str(sprintf('Number of %g Inter-spike intervals in total',laenge));
ylabel(text)
figure(3)
hist(diff,100)
title('Histogramm über die reellen Interspike-Abstände aller Spikes')
xlabel('Samples')
text=num2str(sprintf('Anzahl von insgesamt %g Spikepaaren',length(diff)));
ylabel(text)
