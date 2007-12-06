%+
% NAME:
%  tuning()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  11/2007
%
% AIM:
%  Compute tuning curves from likelihood distribution of responses.
%
% DESCRIPTION:
%  This routine computes for a population of neurons the mean and
%  standard deviation of the likelihood distributions
%  P<SUB>i</SUB>(response|stimulus) for each stimulus value, averaged over all
%  presentations of this stimulus. The likelihood distributions may be
%  computed using the <A>likelihood</A> routine.
%
% CATEGORY:
%  Statistics<BR>
%
% SYNTAX:
%* [tm,tstd] = tuning(llh, respvalues); 
%
% INPUTS:
%  llh:: The likelihood function as returned by <A>likelihood</A>.
%  respvalues:: A row vector containing the values corresponding to the
%  response bins. This can also be obtained from the <A>likelihood</A>
%  function. 
%
% OUTPUTS:
%  tm:: The average response as a function of neuron and stimulus bin:<BR>
%  tm(neuron,stimulusdimension1,stimulusdimenion2...).
%  tstd:: The standard deviation of the average response as a function of
%  neuron and stimulus bin:<BR> 
%  tstd(neuron,stimulusdimension1,stimulusdimenion2...).
%  
% PROCEDURE:
%  Compute mean and standard deviation from the likelihood probability
%  distribution. 
%
% EXAMPLE:
%  See <A>zhangexample</A>.
%
% SEE ALSO:
%  <A>likelihood</A>, <A>zhang</A>. 
%-


function [tunem,tunestd]=tuning(llh,respvalues)
  
  sllh=size(llh);
  
  nproto=sllh(1); % number of prototypes
  rbins=sllh(2); % number of bins in response histogram
  
  if (rbins~=length(respvalues))
    error(['Number of response bins and corresponding value vector must ' ...
           'be of same length.'])
  end % if

  stimsize=sllh(3:end);
  nbins=prod(stimsize); % total number of stimulus bins
  
  % prepare arrays for tuning mean and standard deviation
  tunem=zeros([nproto,stimsize]);
  tunestd=zeros([nproto,stimsize]);
  
  % needed below
  skip=nproto*(0:rbins-1);
  
  
  % loop through stimulus bins
  for bidx=1:nbins

    % multi dimensional subscripts of present stimulus bin
    md=ind2subvec(stimsize,bidx);
    
    % find linear indices of bin and prototype within likelihood matrix
    % compute indices for all prototypes before the protoype loop to
    % save time later

    % flatstart gives the indices into the likelihhod array, for retrieval
    % of data
    flatstart=sub2indvec(sllh,[(1:nproto).',repmat([1,md],nproto,1)]);

    % tunestart gives the indices into the tuning array, for saving the
    % results 
    tunestart=sub2indvec([nproto,stimsize],[(1:nproto).',repmat(md, ...
                                                      nproto,1)]);

    % loop through prototypes
    for pridx=1:nproto

      llhnow=llh(flatstart(pridx)+skip).';
      
      % compute mean from likelihood distribution
      mnow=respvalues*llhnow;

      tunem(tunestart(pridx))=mnow;

      % compute variance from likelihood distribution
      tunestd(tunestart(pridx))=sqrt(((respvalues-mnow).^2*llhnow));
    
    end % for pridx
      
  end % for bidx
