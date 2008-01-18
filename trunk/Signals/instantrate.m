%+
% NAME:
%  instantrate()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  08/2007
%
% AIM:
%  Compute instantaneous firing rates for a population of neurons.
%
% DESCRIPTION:
%  instantrate() computes the instantaneous firing rates of a population
%  of neurons for multiple repetitions of an experiment (sweeps). As
%  input, it uses the spike train information contained in 
%  a sweep structure, which is returned by the <A>nev2sweeps</A> routine.
%  The output may either be a structure containing single cell and population
%  firing rates or a structure containing information about a MATLAB memory map
%  file. The memory map file option is needed if the amount of data
%  is so large that keeping all neurons' firing rates in memory is
%  impossible. Temporal integration during firing rate computation can
%  either be accomplished by simply 
%  counting the number of spikes within a sliding time window, or by
%  supplying a filter kernel to the routine with which the single cell
%  spike trains are convolved.   
%
% CATEGORY:
%   Signals
%
% SYNTAX:
%* irstruc=instantrate(sweepstruc
%*                      ((,'windowsize',value) | (,'filter',array))
%*                      [,'memmapfile',string]
%*                      [,'vartype',string]
%*                      [,'dt',value]
%*                      [,'timeshift',value]); 
%
% INPUTS:
%  sweepstruc:: The sweep structure containing the single neuron firing
%               timestamps as returned by <A>nev2sweeps</A>.
%  windowsize:: The size of the spike count window in units of seconds.
%  filter:: A one-dimensional array containing the filter kernel that is
%           used for convolving the spike trains. The kernel must be
%           normalized, i.e. the sum of the filter
%           entries must equal 1. Thus, for an arbitray array
%           <VAR>f1</VAR>, compute the normalized filter <VAR>fn</VAR> via
%*          fn=f1/sum(f1)
%           Either <VAR>windowsize</VAR>
%           or <VAR>filter</VAR> must be set for the routine to work.
%
% OPTIONAL INPUTS:
%  memmapfile:: A string containing the file name of the MATLAB memory
%               map file that is used to store the firing rate
%               information on hard disk. Default: []. 
%  vartype:: The variable type used to store the single cell firing
%            rates. This option is intended to reduce memory consumption
%            for large 
%            data sets. For simple counting of spike numbers, an unsigned
%            integer type like 'uint8' or 'uint16' might
%            suffice, while convolution with filters requires at least
%            type 'single'. The routine prints an error message at the
%            possibility of an
%            overflow. Population firing rates are
%            always stored in arrays 
%            with double precision floating point values. Default:
%            'uint8' if <VAR>windowsize</VAR> is set, and 'single' if
%            <VAR>filter</VAR> is set.
%  dt:: The size of a sample time bin in units of seconds. Default:
%       0.001, i.e. samples are 1ms long. 
%  timeshift:: Setting this argument can be used to align a response to
%  the stimulus, e.g. to counteract the latency of the neuronal
%  response. <VAR>timeshift</VAR> is given in units of seconds, with
%  negative sign indicating a shift to earlier times. Default: 0, i.e. no
%  shift. The routine applies MATLAB's circular shifting, thus responses at one
%  end of the array occur at the other end after the shift. For long
%  datasets, this should only have marginal effects.
%
% OUTPUTS:
%  irstruc:: The exact form of the output structure depends on whether
%            the <VAR>memmapfile</VAR> option was set or not. If no
%            <VAR>memmapfile</VAR> is given, <VAR>irstruc</VAR> becomes a
%            structure array with length <VAR>S</VAR>, with <VAR>S</VAR>
%            being the number of sweeps,
%            and a single entry <VAR>irstruc(s)</VAR> for sweep
%            <VAR>s</VAR> has the following fields:
%*             irstruc(s)
%*                |---single: Matrix of type <VAR>vartype</VAR> and size
%*                            (number of samples x number of
%*                             neurons). Contains the instantaneous
%*                             spike counts of all neurons as a
%*                             function of time.
%*                |---population: Vector of length (number of samples)
%*                                describing the average firing rate of
%*                                all neurons during sweep <VAR>s</VAR>
%*                                in Hz.
%*                |---factor: Factor to convert spike counts into firing
%*                            rates. To obtain firing rates in units of
%*                            Hz for single neurons, multiply 
%*                            <VAR>irstruc(s).single</VAR> with this factor.  
%*                |---average: Average firing rates of all neurons across
%*                             all sweeps. This field is repeated in
%*                             each entry of structure arrays containing
%*                             multiple sweeps.
%*                |---minmax: Two element vector containing the minimum
%*                            and maximum spike counts across all sweeps.
%            If <VAR>memmapfile</VAR> is set, the structure returned
%            has a single entry which contains information needed to
%            recover the memory map 
%            file. In detail:
%*             irstruc
%*                |---average: Average firing rates of all neurons across
%*                             all sweeps. 
%*                |---memmapfile: The filename of the memory map file.
%*                |---mmfformat: Cell array describing the format of the
%*                               memory map file.
%*                |---factor: Factor to convert spike counts into firing
%*                            rates.
%*                |---nbytes: Number of bytes of the data within a single
%*                            sweep. This is needed to compute the offset
%*                            within the memory map to access the data of
%*                            a certain sweep. 
%*                |---nsweeps: The number of sweeps.
%*                |---minmax: Two element vector containing the minimum
%*                            and maximum spike counts across all sweeps.
%           Response duration can be obtained via 
%           <VAR>irstruc.mmfformat{1,2}(1)</VAR>, prototype number from
%           <VAR>irstruc.mmfformat{1,2}(2)</VAR>.
%
% PROCEDURE:
%  - Syntax check and default settings.<BR>
%  - Prepare memory map file if needed.<BR>
%  - Loop through sweeps and protoytpes.<BR>
%  - Compute moving average via cumulative sum or by convolution using
%  MATLAB's filter routine.<BR>
%  - Generate output structure.
%
% EXAMPLE:
%  Generate a sample sweep structure with two sweeps, 50 neurons and
%  random spikes, with higher firing probability during the second
%  half of the experiment. 
%
%*>> rspikes1=rand(1000,100)<0.01;
%*>> rspikes2=rand(1000,100)<0.08;
%*>> rspikes=[rspikes1;rspikes2];
%*
%*>> rsp.nproto=50
%*>> rsp.duration=2
%*>> rsp(2).nproto=50
%*>> rsp(2).duration=2
%*
%*>> for pidx=1:50
%*>>   rsp(1).pr(pidx).eln=pidx;
%*>>   rsp(1).pr(pidx).prn=1;
%*>>   rsp(1).pr(pidx).ts=0.001*find(rspikes(:,pidx));
%*>> end
%*>> for pidx=1:50
%*>>   rsp(2).pr(pidx).eln=pidx;
%*>>   rsp(2).pr(pidx).prn=1;
%*>>   rsp(2).pr(pidx).ts=0.001*find(rspikes(:,pidx+50));
%*>> end
%*
%  Compute the firing rates within a 100ms window:
%*>> ir=instantrate(rsp,'windowsize',0.1,'vartype','uint8')
%*
%  Plot firing rates of neuron 1 from sweeps 1 and 2 and the population
%  average of sweep 2:
%*>> plot(ir(1).single(:,1)*ir(1).factor)
%*>> hold on
%*>> plot(ir(2).single(:,1)*ir(2).factor,'k')
%*>> plot(ir(2).population,'r')
%
% SEE ALSO:
%  <A>nev2sweeps</A>, MATLAB filter routine, MATLAB memory map files. 
%-



function irstruc=instantrate(sweepstruc, varargin)
  
  kw=kwextract(varargin, ...
               'windowsize', [], ...
               'memmapfile', '', ...
               'vartype', 'uint8', ...
               'dt', 0.001, ...
               'filter', [], ...
               'timeshift', 0);
  

  shiftsamples=kw.timeshift/kw.dt;
  
  if (mod(shiftsamples,1)~=0)
    warning('Non-integer number of samples for time shift. Rounding.');
    shiftsamples=round(shiftsamples);  
  end % if
    
  if isempty(kw.filter)
    if ~isempty(kw.windowsize)
      sws=round(kw.windowsize/kw.dt); % windowsize in samples
    else
      error('Either windowsize or filter must be set.');
    end
  else
    if ~isempty(kw.windowsize)
      warning(['Setting of windowsize is overwritten by length of filter ' ...
               'kernel.'])
    end
    sws=length(kw.filter); % windowsize in samples
    kw.windowsize=sws*kw.dt; % windowsize in seconds
    kw.vartype='single'; % windowsize in seconds
  end % if
  
  dur=sweepstruc(1).duration/kw.dt; % overall duration in samples
    
  nsweeps=length(sweepstruc);
  
  factor=1/kw.windowsize; % factor needed to convert kernel into
                               % integer version, use the smallest
                               % nonzero entry that is later scaled to 1

  av=zeros(dur,1); % for average across all sweeps

  minall=0;
  maxall=0;
  
  % prepare the memmapfile
  % different sweeps are accessed via the offset
  if ~(strcmp(kw.memmapfile,'')) 

    [f, msg] = fopen(kw.memmapfile, 'wb');
  
    if f ~= -1
      for swidx=1:nsweeps
        preparesingle=zeros(dur,sweepstruc(swidx).nproto, kw.vartype);
        dummy=whos('preparesingle');
        nbytessingle=dummy.bytes;
        preparepop=zeros(dur,1,'double');
        dummy=whos('preparepop');
        nbytestotal=nbytessingle+dummy.bytes;
        fwrite(f, preparesingle, kw.vartype);
        fwrite(f, preparepop, 'double');
      end % for
      fclose(f);
    else
      error('MATLAB:demo:send:cannotOpenFile', ...
            'Cannot open file "%s": %s.', kw.memmapfile, msg);
    end
    
    mmfformat={ kw.vartype [dur sweepstruc(1).nproto] 'single'; ...
                'double' [dur 1] 'population' };
    
    m = memmapfile(kw.memmapfile, ...
                   'format', mmfformat, ...
                   'writable', true,...
                   'repeat',1);
    
  end % if 

  % loop through the sweeps
  for swidx=1:nsweeps
    
    % compute offset pointing at beginning of respective sweep 
    if ~(strcmp(kw.memmapfile,''))
      m.offset=nbytestotal*(swidx-1);
    end % if
    
    % prepare rate matrix for this sweep
    % save memory by using smaller data type
    r=zeros(dur,sweepstruc(swidx).nproto,kw.vartype);
    
    % loop through prototypes
    for ipr=1:sweepstruc(swidx).nproto
    
      % spikes must be of floating point type, otherwise,
      % cumsum does not work
      spikes=zeros(dur,1);
      spikes(round(sweepstruc(swidx).pr(ipr).ts/kw.dt))=1;
      
      if isempty(kw.filter)
        % moving average for window of size sws
        cumul=[zeros(sws,1); cumsum(spikes)];
        r(:,ipr) = cumul(sws+1:sws+dur)-cumul(1:dur);
      else
        % use filter kernel
        r(:,ipr) = filter(kw.filter*sws,1,spikes);
      end % if
      
    end % for ipr
 

    % possible overflow?
    if (isinteger(kw.vartype)) && (max(r(:))==intmax(kw.vartype))
      error(['Possible overflow, please use larger vartype or reduce the ' ...
             'windowsize.'])
    end % if
   
    pop=double(sum(r,2))/(sweepstruc(swidx).nproto*kw.windowsize);

    % find max and min response across all sweeps
    rmin=double(min(r(:)));
    rmax=double(max(r(:)));
    minall=min([minall,rmin]);
    maxall=max([maxall,rmax]);
    
    if (shiftsamples~=0)
      r=circshift(r,[shiftsamples,0]);
      pop=circshift(pop,[shiftsamples,0]);
    end % if (shiftsamples~=0)
    
    if strcmp(kw.memmapfile,'')
      irstruc(swidx).single=r;
      irstruc(swidx).population=pop;
      irstruc(swidx).factor=factor;
    else
      m.data.single=r;
      m.data.population=pop;
    end % if
    
    av=av+pop;
    
  end % for swidx

  
  av=av/nsweeps;
  

  if strcmp(kw.memmapfile,'')
 
    for swidx=1:nsweeps
      irstruc(swidx).average=av;
      irstruc(swidx).factor=factor;
      irstruc(swidx).minmax=[minall maxall];
    end % for
  
  else
    irstruc.average=av;
    irstruc.memmapfile=kw.memmapfile;
    irstruc.mmfformat=mmfformat;
    irstruc.factor=factor;
    irstruc.nbytes=nbytestotal;
    irstruc.nsweeps=nsweeps;
    irstruc.minmax=[minall maxall];
    % duration can be recovered from irstruc.mmfformat{1,2}(1)
    % nproto can be recovered from irstruc.mmfformat{1,2}(2)
  end % if

  
  