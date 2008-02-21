%+
% NAME:
%  interspikefkt()
%
% VERSION:
%  $Id: interspikefkt.m 2008-02-20 12:54 furche $
%
% AUTHOR:
%  J. Furche 
%
% DATE CREATED:
%  2008-02-20
%
% AIM:
%  Constructs inter-spike intervals based on ISI histograms from real NEV-data.
%
% DESCRIPTION:
% interspikefkt.m generates a list of inter-spike intervals and timestamps
% for a specified number of spikes. The distribution on the intervals is
% based on an ISI histogram from the real spike data, given in NEV-file
% format and translated with the matlabNEVlib10a-toolbox to a matlab
% object. 'laenge' random variabled are diced based on the distribution of
% the histogram and stored in an output vector.
%
%
% CATEGORY:
%  Statistics
%
% SYNTAX:
%* [abstaende,timestamps,index]=interspikefkt(Neu,channel,unita,laenge)
%
% INPUTS:
% Neu:: Matlab object of the NEV-file
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
% index:: list containing the indices of the with 'channel' and 'unita' 
%         specified spike events (for further calculations).
%
%
% PROCEDURE:
% The distribution on the intervals is
% based on an ISI histogram from the real spike data.
% Due to outliers only 80% of the intervals are obtained for the
% calculations. The data is classed in 100 bins and for each bin the 
% frequency corresponds to the probability which determines the randomly
% set values for the simulated intervals to choose a sample out of the 
% diced interval. The samples within each bin are
% uniformly distributed.
%  
%
% EXAMPLE:
% Generate 14000 inter-spike intervals based on channel 54 unit 2 
% from the Nev-Object 'Neu':
% * [abstaende,timestamps,index]=interspikefkt(Neu,54,2,14000)
%
% SEE ALSO:
%  matlabNEVlib10a toolbox, 
%  <A>interspikefktplx<A/>
%


function [abstaende,timestamps,index]=interspikefkt(Neu,channel,unita,laenge)

text=num2str(sprintf('electrode==%g & unit==%g',channel,unita))
[retVal, indices] = searchNEVByField(Neu, text); 
index=find(retVal==1);  
times=getPackets(Neu,index,'timeStamp');
diff=(times(2:end)-times(1:end-1));
Stimuluszeiten=Neu.StimulusData.timeStamp;
% 80% of the data shall be used for consructions:
sortiertdiff=sort(diff);
obererGrenzindex=ceil(length(diff)*8/10);
kleinediffs=sortiertdiff(1:obererGrenzindex);
[h,n]=hist(kleinediffs,100);
wkeiten=h/obererGrenzindex;

cumwkeiten=cumsum(wkeiten);
zufall=rand(1,laenge)
klassenbreite=mean(n(2:end)-n(1:end-1)); 
for j=1:laenge
[eins,bin]=min(zufall(j)>cumwkeiten); 
abstand=floor(n(bin)+klassenbreite*rand-klassenbreite/2); %samples within each bin are uniformly distributed
abstaende(j)=abstand;
end
timestamps=cumsum(abstaende);


figure(1)
hist(kleinediffs,100);
title('Histogram for the real inter-spike intervals')
xlabel('Samples')
text=num2str(sprintf('Number of %g Inter-spike intervals in total',length(kleinediffs)))
ylabel(text)
figure(2)
hist(abstaende,100);
title('Histogram for the simulated inter-spike intervals')
xlabel('Samples')
text=num2str(sprintf('Number of %g Inter-spike intervals in total',laenge))
ylabel(text)
