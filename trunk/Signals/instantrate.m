%+
% NAME:
%  instantrate()
%
% VERSION:
%  $Id:$
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
%  a sweep structure, which is returned by the <a>nev2sweeps</A> routine.
%  The output may either be a structure containing single cell and population
%  firing rates or a structure containing information about a MATLAB memory map
%  file. The memory map file option is needed if the amount of data
%  is so large that keeping all neurons' firing rates in memory is
%  impossible. Temporal integration during firing rate computation can
%  either be accomplished by simply 
%  counting the number of spikes within a moving time window, or by
%  supplying a filter kernel to the routine with which the single cell
%  spike trains are convolved.   
%
% CATEGORY:
%   Signals
%
% SYNTAX:
%* irstruc=instantrate(sweepstruc
%*                      (,'windowsize',value | ,'filter',array)
%*                      [,'memmapfile',string]
%*                      [,'vartype',string]
%*                      [,'dt',value]); 
%
% INPUTS:
%  sweepstruc:: The sweep structure containing the single neuron firing
%               timestamps as returned by <A>nev2sweeps</A>.
%  windowsize:: The size of the spike count window.
%  filter:: A one-dimensional array containinmg the filter kernel that is
%           used for convolving the spike trains. Either <VAR>windowsize</VAR>
%           or <VAR>filter</VAR> must be set for the routine to work.
%
% OPTIONAL INPUTS:
%  memmapfile:: A string containing the file name of the MATLAB memory
%               map file that is used to store the firing rate
%               information on hard disk. Default: []. 
%  vartype:: The variable type used to store the single cell firing
%            rates. This intended to reduce memory consumption for large
%            data sets. For simple counting of spike numbers, an unsigned
%            integer type like 'uint8' or 'uint16' might
%            suffice, while convolution with filters requires at least
%            type 'single'. The routine prints an error message if a
%            possible overflow occurred. Population firing rates are
%            always stored in arrays 
%            with double precision floating point values. Default:
%            'uint8' if <VAR>windowsize</VAR> is set and 'single' if
%            <VAR>filter</VAR> is set.
%  dt:: The size of a sample time bin in uints of seconds. Default:
%       0.001, i.e. samples are 1ms long. 
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
%*                |---single: Matrix of type <VAR>vartype<VAR> and size
%*                            (number of samples x number of neurons).
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
%*                            rates. To obtain firing rates in units of
%*                            Hz for single neurons, multiply 
%*                            <VAR>irstruc(s).single</VAR> with this factor.
%*                |---nbytes: Number of bytes of the data within a single
%*                            sweep. This is needed to compute the offset
%*                            within the memory map to access the data of
%*                            a certain sweep. 
%*                |---nsweeps: The number of sweeps.
%
% PROCEDURE:
%  - Syntax check and default settings.<BR>
%  - Prepare memory map file if needed.<BR>
%  - Loop through sweeps and protoytpes.<BR>
%  - Compute moving average via cumulative sum or by convolution using
%  MATALAB's filter routine.<BR>
%  - Generate output structure.
%
% EXAMPLE:
%  Generate a sample sweep structure with two neurons. 
%
%*>> testspikes.nproto=2;
%*>> testspikes.duration=1
%*>> testspikes.pr(1).eln=1
%*>> testspikes.pr(1).prn=1
%*>> testspikes.pr(1).ts=0.1*(1:10)
%*>> testspikes.pr(2).eln=2
%*>> testspikes.pr(2).prn=1
%*>> testspikes.pr(2).ts=0.1*(1:9)+0.005
%
%*>> ir=instantrate(testspikes,'windowsize',0.01 ...
%*>>                 ,'vartype','uint8')
%
%*>> ir=instantrate(testspikes,'windowsize',0.01 ...
%*>>                 ,'memmap',['/home/athiel/MATLAB/Sources/' ...
%*>>                     'Self/Turtle/ratefilesimple.mmf'],'vartype','uint8')
%
% SEE ALSO:
%  <A>nev2sweeps</A>, MATALAB filter routine, MATALAB memory map files. 
%-



function irstruc=instantrate(sweepstruc, varargin)
  
  kw=kwextract(varargin, ...
               'windowsize', [], ...
               'memmapfile', '', ...
               'vartype', 'uint8', ...
               'dt', 0.001, ...
               'filter', []);
  

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
    end % for
  
  else
    irstruc.average=av;
    irstruc.memmapfile=kw.memmapfile;
    irstruc.mmfformat=mmfformat;
    irstruc.factor=factor;
    irstruc.nbytes=nbytestotal;
    irstruc.nsweeps=nsweeps;
    % duration can be recovered from irstruc.mmfformat{1,2}(1)
    % nproto can be recovered from irstruc.mmfformat{1,2}(2)
  end % if

  
  