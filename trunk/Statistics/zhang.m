%+
% NAME:
%  zhang()
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
%  Reconstruct stimulus time course from neuronal responses
%
% DESCRIPTION:
%  This routine uses the <A>tuning</A> curves and stimulus
%  prior to estimate the stimulus which most probably evoked a given
%  response at each time step. It implements the one-step probabilistic
%  method described by Zhang et al. (J Neurophysiol, 79: 1017-1044,
%  1998).  
%
% CATEGORY:
%  Statistics
%
% SYNTAX:
%* est=zhang(resp,tune,prior,binval); 
%
% INPUTS:
%  resp:: The responses of the neurons as a function of time. Presently,
%  the routine works for spike numbers as returned by the
%  <A>instantrate</A> routine. The <VAR>resp</VAR> argument must contain
%  a single 
%  sweep of responses that is used for the estimation of the stimulus.  
%  tune:: The tuning functions for each neuron, i.e. the average spike
%  rates generated for each stimulus class. This can be obtained via the
%  <A>tuning</A> routine.
%  prior:: The prior distribution of stimuli. This may be computed via 
%*  [h,bv,ri] = histmd(s,'nbins',23]);
%*  prior=h/sum(h(:));
%  binval:: The values corresponding to the bins of the stimulus
%  distribution. This is returned as the second output argument of the
%  <A>histmd</A> routine.
%
% OUTPUTS:
%  est:: Estimation of the stimulus time course for the given
%  sweep. First dimension represents time.
%
% PROCEDURE:
%  MATLAB version of Zhang's algorithm.
%
% EXAMPLE:
%  See <A>zhangexample</A>.
%
% SEE ALSO:
%  <A>instantrate</A>, <A>likelihood</A>, <A>tuning</A>. 
%-



function est=zhang(resp,tunem,prior,bv)
  
  % determine sizes of stimulus and tuning
  stimdur=size(resp(1).single,1);
  ndims=size(bv,2);
  
  sizetune=size(tunem);
  nproto=sizetune(1);
  sizestim=sizetune(2:end);
  nbins=prod(sizestim);
  
  % checking input arguments
  if (length(resp)~=1)
    error('Cannot use more than one sweep for estimation.');
  end
  
  % compute constant bias from prior and sum of tuning functions
  % tau=1/resp(1).factor;
  bias=log(prior)-squeeze(sum(tunem,1))/resp(1).factor;
  
  % reshape bias to enable addition below
  rsbias=repmat(reshape(bias,1,nbins),stimdur,1);
    
  
  % convert tuning to log and add small amount to avoid taking log of
  % zero values:
  ltune=log(tunem+1E-9*max(tunem(:)));

  % reshape tuning functions to two dimensional matrix (prototype,
  % tuningvalues), for matrix multiplication below
  rstune=reshape(ltune,nproto,nbins);
  
  
  % compute all multi dimensional indices for the stimulus bins
  mdiall=ind2subvec(sizestim,(1:nbins));
  
  % number of spikes for all neurons
  nall=double(resp(1).single);

  % matrix operation multiplies tuning functions with spike numbers for
  % each neuron and sums over all neurons
  posterior=nall*rstune+rsbias;
  
  % MAP estimate
  [maxprob,maxidx]=max(posterior,[],2);
  
  % convert maximum index in posterior to multidimensional indices
  mdi=mdiall(maxidx,:);
  
  % set stimulus values of the maximum indices as estimate
  est=bv(mdi+1+repmat((0:ndims-1).*size(bv,1),stimdur,1));
  