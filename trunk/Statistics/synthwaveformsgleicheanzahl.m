%+
%NAME:
% synthwaveformsgleicheanzahl()
%
% VERSION:
%  $Id: Version 1 12.03.2008 Furche$
%
% AUTHOR:
%  Julia Furche
%
% DATE CREATED:
%  03/2008
%
% AIM:
%  Generates sythetic waveforms based on a real spike unit
%
% DESCRIPTION:
%  The function generates waveforms 
% for a number of spikes that is almost the same as the number 
% in the original unit (varying from -10% to +10%). The expected 
% variance and the mean of the created waveforms are the same as 
% the sample ones of the real data.
%
% CATEGORY:
%  Statistics
%
% SYNTAX:
%* [mu,Waveforms,kurven]=synthwaveformsgleicheanzahl(plxdatei,channel,unita)
% 
% INPUTS:	
% plxdatei: (list of) plx datafile(s) that containe(s) the spike unit providing a base	
% channel: 	(list of) Channel(s) in the corresponding plx-file which redorded the base spike unit
% unita: (list of) Value(s) specifying the base spike unit
%
% OUTPUTS:	
% mu: 	sample mean waveform of the original data
% Waveforms: matrix containing the waveforms of the original data
% kurven: (Cell array of) matrix containing the synthetic waveforms
%
% RESTRICTIONS:
%  If 2 bytes per sample for storing waveform data are
% allowed, the restrictions 'einsetzen(einsetzen>127)=127;
%            einsetzen(einsetzen<-127)=-127;' shall be deleted.
%
% EXAMPLE:
% Generate synthetic waveforms based on the data
% file 'experiment1.plx', channel 5 unit 2:
% *[mu,Waveforms,kurven]=synthwaveformsgleicheanzahl('experiment1.plx',
%  5,2);
%
% SEE ALSO:
% interspikefktplx2.m, versuch120308.m
%-
function [mu,Waveforms,kurven]=synthwaveformsgleicheanzahl(plxdatei,channel,unita)
   

if length(channel)~=length(unita);
    error('Please specify only one channel and unit for each data file')
end


for i=1:length(channel) 
        [n, npw, ts, wave] = plx_waves_v(plxdatei, channel(i), unita(i));
        %Generating synthetic waveforms of the same distribution using
        %cholesky factorization:
        Waveforms{i}=wave*1000;
        mu{i}=1/n*sum(Waveforms{i});
        [m,n2]=size(Waveforms{i}');
        covi=cov(Waveforms{i});
        R=chol(covi);
        kurvesum=0;
        %Variation of the number of spikes:
        prozent20=n*20/100;
        number(i)=max(round(n+prozent20*rand-prozent20*2/3),70);
 
        kurve=zeros(m,number(i));
        for j=1:number(i)
            tau=randn(m,1);
            %Storing with 1 byte per sample requieres values between -127
            %and 127 mV:
            einsetzen=R'*tau+mu{i}';
            einsetzen(einsetzen>127)=127;
            einsetzen(einsetzen<-127)=-127;
            kurve(:,j)=einsetzen;
        end
        kurven{i}=kurve';
end