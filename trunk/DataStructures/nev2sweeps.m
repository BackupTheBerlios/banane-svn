%+
% NAME:
%  nev2sweeps()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  2/2007
%
% AIM:
%  Separate spiketrains of a complete experiment into stimulus repetitions.
%
% DESCRIPTION:
%  During an experiment, a stimulus is often repeated several time while
%  spiketrains are recorded continuously. nev2sweeps transforms the
%  complete spiketrains of multiple neurons into chunks corresponding to
%  the stimulus repetetions, called 'sweeps' here. The
%  routine uses the ASCII-file describing the stimulus coordinates to
%  determine the duration of a sweep. Spiketrain data is returned within
%  a structure array, with timestamps given in seconds. Timing of spikes
%  is corrected relative to the nearest trigger event to avoid timing
%  irregularities.
%
% CATEGORY:
%  DataStructures
%
% SYNTAX:
%* sweepstruct=nev2sweeps(nevvariable,posfile,
%*                          [,'minspikenumber',somevalue]
%*                          [,'triggercheck',0/1] 
%
% INPUTS:
%  nevvariable:: The matlab structure containing the experimental data,
%  as returned by the <A>loadNEV</A> routine. 
%  posfile:: An ASCII file containing the stimulus coordinates. The
%  format is
%*  xcoord1 ycoord1
%*  xcoord2 ycoord2
%*  xcoord3 ycoord3
%*   ...
%*  xcoordN ycoordN
%  nev2sweeps uses the number of lines of <VAR>posfile</VAR> to determine
%  the duration of the sweep. Thus, separation is also possible for
%  sweeps applying different stimuli as long as their duration is identical.   
%
% OPTIONAL INPUTS:
%  minspikenumber:: Neurons that generated less that
%  <VAR>minspikenumber</VAR> spikes during the complete experiment
%  are ignored and their spiketrains are not added to the structure
%  returned. Default value is 1000.
%  triggercheck:: Set this switch to obtain information about how many
%  spikes have been lost during conversion due to trigger irregularities.
%
% OUTPUTS:
%  sweepstruct:: Structure containing the spiketrain info after sorting
%  the signals into the different sweeps.
%
% RESTRICTIONS:
%  Not sure whether the triggercheck option works corretly. Need to check
%  this!<BR>
%  Note that te routine has been tested only marginally. It may therefore
%  fail in some cases due to specialized settings that need to be
%  generalized. 
%
% PROCEDURE:
%  Evaluate the structure returned by the loadNEV routine and build up a
%  new structure based on the number of sweeps. See the source code for
%  comments as well. 
%
% EXAMPLE:
%* posfile='/home/athiel/Experiments/ver051123/Stimuli/Movement/3-1.dat';
%* sdata = loadNEV(['/home/athiel/Experiments/ver051123/Sorted/051123-13.nev']);
%* s=nev2sweeps(sdata,posfile);
%
%
% SEE ALSO:
%  <A>loadNEV</A>
%-



function sweepstruct=nev2sweeps(nevvariable,posfile,varargin);
  
  kw=kwextract(varargin,'minspikenumber',1000,'triggercheck',0);
      
  % time resolution of time stamps
  tres=double(nevvariable.HeaderBasic.timeResolution);
  
  % use the coordinate file from the stimulation to find out how many
  % triggers are contained in one stimulus repetition, a sweep 
  % oldstyle, using the DIR command. does not work for martins DAT files
  %posfile=dir(['/home/athiel/Experiments/ver051123/Stimuli/Movement/' ...
  %             'sharp_pos1.lcf'])
  %npos=posfile.bytes/12-1
  
  posdata=load('-ascii', posfile); 
  
  npos=size(posdata,1)-1

  % trigger signal is set after presentation of 500 coordinates
  pospertrig=500

  trigspersweep=npos/pospertrig
  
  difftrigsamp=0.5*tres; % desired difference between triggers in samples 
  
  % nevvariable.ExpData.timestamps contains a mixture of both trigger
  % channels and starts with an additional entry 0.0. Extract the "right"
  % trigger channels, which is characterized by an interval
  % between first and second trigger of nearly 500ms, instead of about
  % 250ms.
  bothtrig=double(nevvariable.ExpData.timestamps);

  trig1=bothtrig(2:2:end);
  trig2=bothtrig(3:2:end);

  nsweeps1=length(trig1)/trigspersweep
  nsweeps2=length(trig2)/trigspersweep
  if nsweeps1 ~= nsweeps2 
    error('Unequal number of trigger signals in both channels.')
  end

  dt1=trig1(2)-trig1(1);
  dt2=trig2(2)-trig2(1);

  [v,mi]=max([dt1,dt2]);
  righttrig=mi;

  trigstamps=bothtrig(1+righttrig:2:end);

  nsweeps=length(trigstamps)/trigspersweep
  sweependidx=trigspersweep*(1:nsweeps);
    
  % for martins setup, active channels returns all 100 electrodes except
  % for number 51 
  channels=nevvariable.GeneralInfo.ActiveChannels;

  nchannels=length(channels);
  
  % for counting the total number of prototypes
  nproto=0;
  
  totaldiff=0;
  totalspikes=0;
  
  first=nevvariable.SpikeData(channels,1);

  for i = 1:nchannels
    nowchannel=channels(i);
    display(num2str(nowchannel));

    % for a sorted channel, find out how many prototypes have been
    % separated, maximum is 5
    protos=zeros(1,7);

    % if the channel has been sorted, the first timestamps-array is
    % empty, otherwise it contains the unsorted timestamps
    if isempty(first(i).timestamps)
      
      % size of nevvariable.SpikeData depends on the maximum number of
      % prototypes that have been sorted on a single channel within the
      % whole NEV file. if noise is present, this is 7, no matter if the
      % remaining prototypes are filled or not. thus, to avoid noise to
      % be evaluated, maxproto must be less than 7 but still flexible if
      % less prototypes are present. 
      maxproto=size(nevvariable.SpikeData,2);
      maxproto(maxproto>6)=6;

      for pidx=2:maxproto % first entry is empty for sorted prototypes, last
                   % entry is reserved for noise
   
        nowts=nevvariable.SpikeData(nowchannel,pidx).timestamps;
        
        protos(pidx)=not(isempty(nowts));
        
        nspikes=length(nowts);
        
        % eliminate prototypes which contain too few spikes
        if nspikes < kw.minspikenumber
          protos(pidx)=0;
        end
      
      end %% for pidx

      
      % now that within the current channel, sorted prototypes with
      % sufficient spike numbers have been determined, their spike
      % timestamps have to be extracted and sorted into the different
      % sweeps  
      
      pidx=find(protos);
      
      if isempty(pidx)
        nowproto=0;
      else
        nowproto=sum(protos);

        for p=1:nowproto
          
          % The first 500 coordinates are read into the buffer (which
          % happens in essentailly no time), afterwards
          % the trigger is set for the first time. Thus, the second
          % trigger marks the time when the first 500 coordinates have
          % been presented.
          
          allstamps=double(nevvariable.SpikeData(nowchannel, ...
                                                 pidx(p)).timestamps);
          
          totalspikes=totalspikes+length(allstamps);

          % find trigger interval for each spike
          [dummy,interval] = histc(allstamps,trigstamps);
          
          % trigger intervals between sweeps
          inbetween=(1:nsweeps)*trigspersweep;
          
          % mark intervals between sweeps for later elimination
          interval(ismember(interval,inbetween))=0;
          
          % only use non-zero intervals
          nzidx=find(interval);
          interval=interval(nzidx);
          nzstamps=allstamps(nzidx);

          % get each timestamp relative to its trigger by subtracting
          % from each timestamp the starting point of the corresponding
          % trigger interval
          sub=nzstamps-trigstamps(interval);
          
          % do not use those spikes that occur after the end of the
          % regular trigger interval, since they would otherwise occur at
          % the beginning of the next interval
          nottoolarge=sub<difftrigsamp;
          
          withinregular=sub(nottoolarge);
          
          % count the number of eliminated spikes for possible analysis
          if kw.triggercheck
            totaldiff=totaldiff+abs(length(sub)-length(withinregular));
          end
          
          % compute the interval index within a sweep and the sweep index
          % for each trigger interval
          intervalwithinsweep=mod(interval(nottoolarge),trigspersweep);
          swidx=ceil(interval(nottoolarge)/trigspersweep);
          
          % add regular trigger start times to the spike times relative
          % to the interval starting point
          rescaled=withinregular+(intervalwithinsweep-1)*difftrigsamp;

% The old loopy version          
% $$$           for tidx=1:(length(trigstamps)-1)
% $$$             swidx=ceil(tidx/trigspersweep);
% $$$ 
% $$$             substamps=allstamps-trigstamps(tidx);
% $$$ %            nowidx=find((-difftrigsamp < substamps) & (substamps <=0));
% $$$ %            nowidx=find((substamps >= 0) & (substamps < difftrigsamp));
% $$$             nowidx=allstamps(1+nc(tidx):nc(tidx)+n(tidx));
% $$$             
% $$$             if kw.triggercheck
% $$$               checknowidx=find((substamps >= 0) & (substamps < trigstamps(tidx+1)-trigstamps(tidx)));
% $$$             
% $$$               diffnumbers=length(checknowidx)-length(nowidx);
% $$$               if diffnumbers~=0
% $$$                 difftrig=(trigstamps(tidx+1)-trigstamps(tidx))/30000;
% $$$                 if difftrig < 4.0 
% $$$                   display('diff error!')
% $$$                   diffnumbers
% $$$                   difftrig
% $$$                   totaldiff=totaldiff+abs(diffnumbers)
% $$$                 end
% $$$               end
% $$$             end
% $$$             
% $$$             trigidxwithinsweep=mod(tidx,trigspersweep);
                        

          for si=1:nsweeps

            % HeaderExtended contains only ActiveChannels, therefore indexed
            % by {i} instead of channels{i}
            sweepstruct(si).pr(nproto+p).eln= ...
              nevvariable.HeaderExtended{i}.electrode;
            
            sweepstruct(si).pr(nproto+p).prn=pidx(p)-1;
            
            % append new rescaled spike timestamps to the structure
            sweepstruct(si).pr(nproto+p).ts= ...
                    rescaled(swidx==si)/tres;
               
            end %% for si
                    
        end %% for p
        
      end %% else
            
      % count the total number of separated prototypes
      nproto=nproto+nowproto;
    
    end %% if sortnow
   
  end %% for i = 1:nchannels

  for si=1:nsweeps
    sweepstruct(si).nproto = nproto;
  end %% for
  
  if kw.triggercheck
   display(['Total number of spikes different due to trigger shifts: ',num2str(totaldiff)]);
   display(['Total number of spikes originally in the file: ',num2str(totalspikes)]);
   display(['Fraction: ',num2str(totaldiff/totalspikes)]);
  end
 
  