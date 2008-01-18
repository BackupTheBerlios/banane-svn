%+
% NAME:
%  likelihood()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  10/2007
%
% AIM:
%  Compute likelihood of responses given an ensemble of stimuli.
%
% DESCRIPTION:
%  For each neuron of a population, this routine computes the likelihoods of
%  recording a set of responses given a stimuls ensemble,
%  i.e. P<SUB>i</SUB>(response|stimulus).
%
% CATEGORY:
%  Statistics
%
% SYNTAX:
%* [llh,edges]=likelihood(resp,binval,ri[,'rminmax',vector]); 
%
% INPUTS:
%  resp:: The responses of the neurons as a function of time. Presently,
%  the routine works with output structures as returned by the
%  <A>instantrate</A> routine, no matter whether spike numbers are contained
%  in the structure directly or whether they have been saved using the
%  memmapfile option of <A>instantrate</A>.
%  binval:: The values corresponding to the bins of the stimulus
%  distribution.
%  ri:: Reverse indices to reconstruct the time bins when each stimulus
%  value occurred.
%
% OPTIONAL INPUTS:
%  rminmax:: The minimum and maximum values of the response
%  histograms. As the default behaviour, min and max are chosen to
%  contain all response values. Set this optional input if min and max
%  values are desired to be identical across multiple repetitions of the
%  likelihood() routineor if the response range has to be restricted.
%
% OUTPUTS:
%  llh:: The likelihood distributions of each neuron. This is a
%  numerical array with the following format: <VAR>probability(neuron
%  idx, response, stimulus dimension 1, stim dim 2,... stimdim n)</VAR>.
%  edges:: The values of bins used to discretize the response.
%
% RESTRICTIONS:
%  Only spike numbers have been used as a response property yet, but an
%  improvement to use other response features should be possible.
%
% PROCEDURE:
%  - For a given stimulus bin, use the reverse indices to find the time
%  bins when this stimulus occurred.<BR>
%  - Combine the responses at these times
%  for all sweeps.<BR>
%  - Compute histogram across the chosen responses.
%  - Reshape the histogram.
%
% EXAMPLE:
%  See <A>zhangexample</A>.
%
% SEE ALSO:
%  <A>instantrate</A>, <A>tuning</A>, <A>zhang</A>. 
%-


function [llh,edges]=likelihood(resp,bv,ri,varargin)
  
  kw=kwextract(varargin ...
               ,'rminmax',[] ...
               ,'trainsweeps',[]);
  
  mmff=(isfield(resp,'memmapfile')); % memmapfile flag
  
  if mmff

    % duration can be recovered from irstruc.mmfformat{1,2}(1)
    dur=resp.mmfformat{1,2}(1);   
    
    % nproto can be recovered from irstruc.mmfformat{1,2}(2)
    nproto=resp.mmfformat{1,2}(2);
 
    if (isempty(kw.trainsweeps))
      nsweeps=resp.nsweeps;
      kw.trainsweeps=(1:nsweeps);
    else
      nsweeps=length(kw.trainsweeps);
    end % if
  
  else

    [dur,nproto]=size(resp(1).single);

    if (isempty(kw.trainsweeps))
      nsweeps=length(resp);
      kw.trainsweeps=(1:nsweeps);
    else
      nsweeps=length(kw.trainsweeps);
    end % if
  
  end % isfield(resp,'memmapfile')
  

  stimsize=bv(1,:);
  nbins=prod(stimsize);
  
  % if response range is not supplied, determine it across all
  % given sweeps 
  if (isempty(kw.rminmax))
    edges=(resp.minmax(1):resp.minmax(2));
  else
    edges=(kw.rminmax(1):kw.rminmax(2));
  end % if
  
  rbins=length(edges);
  
  % prepare likelihood matrix with appropriate size
  sllh=[nproto,rbins,stimsize];
  llh=zeros(sllh);
  
  % need below, moved to outside of loop
  skip=(0:rbins*nproto-1);

  
  % compute multidim subscripts of present stimulus bin
  md=ind2subvec(stimsize,(1:nbins));
    
  % loop through stimulus bins
  for bidx=1:nbins

    % number of occurrences of the stimulus
    nrevidx=ri(bidx+1)-ri(bidx);
    
    % if the stimulus didnt occur, do nothing
    if (nrevidx>0)
      
      % find time indices at which the stimulus occurred
      idxset=ri(ri(bidx):ri(bidx+1)-1);

      if mmff
        respnow=recoversweepmmf(resp,kw.trainsweeps(1));
      else
        respnow=resp(kw.trainsweeps(1));
      end % if mmff
      
      histnow=sliwhist(respnow.single(idxset,:),'range',edges([1 end]));

      % loop through sweeps and sum histograms of all responses to the same
      % stimulus  
      for swidx=2:nsweeps

        if mmff
          respnow=recoversweepmmf(resp,kw.trainsweeps(swidx));
        else
          respnow=resp(kw.trainsweeps(swidx));
        end % if mmff
        
        histnow=histnow+sliwhist(respnow.single(idxset,:),'range',edges([1 end]));
        
      end % for
      
      % linear index of prototype and stimulus bin within the
      % likelihood array 
      flatstart=sub2indvec(sllh,[1,1,md(bidx,:)]);

      % insert into output argument and normalize 
      llh(flatstart+skip)=double(histnow.')/(nsweeps*nrevidx);

    end % if
      
  end % for bidx      
  
