%+
% NAME:
%  nev2sweeps()
%
% VERSION:
%  $Id$
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
%  During an experiment, a stimulus is often repeated several times while
%  spiketrains are recorded continuously. nev2sweeps transforms the
%  complete spiketrains of multiple neurons into chunks corresponding to
%  the stimulus repetitions, called 'sweeps' here. The
%  routine uses the ASCII-file describing the stimulus coordinates to
%  determine the duration of a sweep. Spiketrain data is returned within
%  a structure array, with timestamps given in seconds. Timing of spikes
%  is corrected relative to the previous trigger event to avoid timing
%  irregularities.
%
% CATEGORY:
%  DataStructures
%
% SYNTAX:
%* sweepstruct=nev2sweeps(nevvariable,trigstamps
%*                        (,'trigspersweep',value) | 
%*                        (,'stimdata',value,'stimpertrig',value)
%*                        [,'minspikenumber',value]
%*                        [,'triggercheck',boolean] 
%*                        [,'verbose',boolean] 
%
% INPUTS:
%  nevvariable:: The matlab structure containing the experimental data,
%                as returned by the <A>loadNEV</A> routine.
%  trigstamps:: The trigger timestamps in units of samples as returned by
%               <A>triggers</A>.
%  trigspersweep:: The number of trigger signals contained in a single
%                  stimulus repetition. This is used to determine which
%                  neuronal signals belong to which repetition. Supply
%                  either this keyword or the combination of
%                  <VAR>stimdata</VAR> and <VAR>stimpertrig</VAR>.
%  stimdata:: nev2sweeps uses the number of rows in <VAR>stimdata</VAR>
%             (i.e. size(stimdata,1)) to determine the duration of the
%             sweep. Thus, separation is
%             also possible for sweeps applying different stimuli as long
%             as their duration is identical.
%  stimpertrig:: For a complete definition of sweep duration, the routine
%                needs to know the number of stimulus values that are
%                presented until a trigger signal is generated. For
%                instance, when mirrors are used for stimulation, 500
%                stimulus values are presented during each trigger
%                interval. 
%
% OPTIONAL INPUTS:
%  minspikenumber:: Neurons that generated less that
%  <VAR>minspikenumber</VAR> spikes during the complete experiment
%  are ignored and their spiketrains are not included in the structure
%  returned. Default value is 0, i.e. all neurons are included.
%  triggercheck:: Set this switch to obtain information about how many
%  spikes have been lost after conversion due to trigger
%  irregularities. default: false.
%  verbose:: Set this option to obtain some information about the results
%  of nev2sweeps' computations. Default: true.
%
% OUTPUTS:
%  sweepstruct:: Structure containing the spiketrain info after sorting
%  the signals into the different sweeps.
%*  sweepstruct(n)
%*       |---nproto     : number of prototypes
%*       |---duration   : duration of single sweep in units of seconds
%*       |---pr(p)      : prototype substructure
%*            |---eln   : electrode number
%*            |---prn   : prototype number at this electrode 
%*            |---ts(s) : timestamps in seconds relative to sweep start
%  <VAR>n</VAR>: sweep index, <VAR>p</VAR>: prototype index, <VAR>s</VAR>: timestamp index
%
% RESTRICTIONS:
%  Not sure whether the triggercheck option works correctly. Need to check
%  this!<BR>
%  Note that the routine has been tested only with a single set of
%  data. It may therefore
%  fail in some cases due to specialized settings that need to be
%  generalized. 
%
% PROCEDURE:
%  Evaluate the structure returned by the <A>loadNEV</A> routine and build up a
%  new structure based on the number of sweeps. See the source code for
%  comments as well. 
%
% EXAMPLE:
%* tr=triggers(nevdata,'070704-05');
%* sweeps=nev2sweeps(nevdata,tr,'stimdata',move1,'stimpertrig',500);
%
% SEE ALSO:
%  <A>loadNEV</A>, <A>triggers</A>.
%-



function sweepstruct=nev2sweeps(nevvariable,trigstamps,varargin);
  
  if (size(nevvariable.SpikeData,2) < 2)
    error('NEV variable seems to be unsorted.')
  end % if
  
  kw=kwextract(varargin ...
               ,'minspikenumber',0 ...
               ,'triggercheck',0 ...
               ,'trigspersweep',0 ...
               ,'stimdata',[] ...
               ,'stimpertrig',0 ...
               ,'verbose',true);
      
  % time resolution of time stamps
  tres=double(nevvariable.HeaderBasic.timeResolution);
  
  
  % check the syntax of the passed arguments
  if (kw.trigspersweep==0)
    if (isempty(kw.stimdata))
      error('Number of triggers per sweep or stimulus data needed.');
    else
      if (kw.stimpertrig==0)
        error('Number of stimuli per trigger needed.')
      else
        nstim=size(kw.stimdata,1)
        kw.trigspersweep=nstim/kw.stimpertrig
        if (kw.verbose)
          display('Stimulus sequence evaluated.');
        end % if (kw.verbose)
      end % if (kw.stimpertrig==0)
    end % if (isempty((kw.stimdata))
  else
    if (kw.verbose)
          display('Triggers per sweep supplied by user.');
    end % if (kw.verbose)
  end % if (kw.trigspersweep==0)
  
  if (kw.verbose)
    display(['Triggers per sweep: ' num2str(kw.trigspersweep)]); 
  end % if (kw.verbose)
  

  
  difftrigsamp=0.5*tres; % desired difference between triggers in samples 



  nsweeps=length(trigstamps)/kw.trigspersweep;
  if (kw.verbose)
    display(['Number of sweeps: ' num2str(nsweeps)]); 
  end % if (kw.verbose)
    
  sweependidx=kw.trigspersweep*(1:nsweeps);
    
  % for the 051123 experiment, active channels returns all 100 electrodes
  % except for number 51 
  channels=nevvariable.GeneralInfo.ActiveChannels;

  nchannels=length(channels);
  
  % for counting the total number of prototypes
  nproto=0;
  
  totaldiff=0;
  totalspikes=0;
  
  %% if the channel has been sorted, the second timestamp array is not
  %% empty. thus, this can be evaluated to find the sorted channels 
  second=nevvariable.SpikeData(channels,2);

  disp('Processing channels.');
  for i = 1:nchannels
    nowchannel=channels(i);
    fprintf('.');
    if (mod(i,20)==0)
      fprintf(char(13));
    end
    
    % for a sorted channel, find out how many prototypes have been
    % separated, maximum is 5
    protos=zeros(1,7);

    % if the channel has been sorted, the second timestamp array is not
    % empty. thus, this can be evaluated to find the sorted channels 
    if not(isempty(second(i).timestamps))
      %    old version:if isempty(first(i).timestamps)
      
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
          % happens in essentially no time), afterwards
          % the trigger is set for the first time. Thus, the second
          % trigger marks the time when the first 500 coordinates have
          % been presented.
          
          allstamps=double(nevvariable.SpikeData(nowchannel, ...
                                                 pidx(p)).timestamps);
          
          totalspikes=totalspikes+length(allstamps);

          % find trigger interval for each spike
          [dummy,interval] = histc(allstamps,trigstamps);
          
          % trigger intervals between sweeps
          inbetween=(1:nsweeps)*kw.trigspersweep;
          
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
          nottoolarge=(sub<difftrigsamp);
          
          withinregular=sub(nottoolarge);
          
          % count the number of eliminated spikes for possible analysis
          if kw.triggercheck
            newdiff=(length(sub)-length(withinregular));
            if (newdiff<0)
              error('Impossible!')
            end
            totaldiff=totaldiff+newdiff;
          end
          
          % compute the interval index within a sweep and the sweep index
          % for each trigger interval
          intervalwithinsweep=mod(interval(nottoolarge),kw.trigspersweep);
          swidx=ceil(interval(nottoolarge)/kw.trigspersweep);
          
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

            sweepstruct(si).pr(nproto+p).eln=channels(i);
            
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

  fprintf('\nFinished.\n');
  
  for si=1:nsweeps
    sweepstruct(si).nproto = nproto;
    sweepstruct(si).duration = kw.trigspersweep*difftrigsamp/tres;
%    sweepstruct(si).npos = npos;
  end %% for
  
  if kw.triggercheck
   display(['Total number of spikes different due to trigger shifts: ',num2str(totaldiff)]);
   display(['Total number of spikes originally in the file: ',num2str(totalspikes)]);
   display(['Fraction: ',num2str(totaldiff/totalspikes)]);
  end
 
  