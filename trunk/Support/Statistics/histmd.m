%+
% NAME:
%  histmd()
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
%  Compute multidimensional histograms.
%
% DESCRIPTION:
%  histmd() computes a histogram of multidimensional data,
%  in other words, it counts the occurrences of vectors
%  i.e. certain combinations of numbers in a
%  stream of data. It is an extension of MATLAB's own hist3
%  routine.
%
% CATEGORY:
%   Support Routines<BR>
%   Statistics<BR>
%
% SYNTAX:
%* [result,binvalues,revidx]=histmd(vectors
%*                                  [,'nbins',vector]
%*                                  [,'min',vector][,'max',vector]
%*                                  [,'binmid',logical]); 
%
% INPUTS:
%   vectors:: A sequence of n-dimensional vectors arranged in an array
%            of the form vectors(time,component).
%
% OPTIONAL INPUTS:
%  nbins:: A vector specifying the number of bins
%          desired for each of the n dimensions. <VAR>nbins(i)</VAR>
%          therefore specifies the number of bins to be used for the
%          <VAR>i</VAR>th dimension. The default is 10 for all dimensions.
%  min,max:: Use these keywords to manually set the ranges inside which
%            you want to compute the histogram. Both <VAR>min</VAR> and
%            <VAR>max</VAR> have to have n entries. Default is to choose
%            <VAR>min</VAR> and <VAR>max</VAR> such that the first and
%            last bin in each dimension contain the minimum and maximum
%            values of the data.  
%  binmid:: If set to false, return bin values as those where bins start,
%           otherwise return bin values as those in the middle of
%           bins. Default: <VAR>binmid=true</VAR>.
%
% OUTPUTS:
%  result::  A matrix with dimensions as specified by
%           <VAR>nbins</VAR>. <VAR>result(<B>x</B>)</VAR> with <B>x</B> being
%           an n-dimensional subscript vector is equal to the number
%           of simultaneous occurrences of the components of <B>x</B>.
%  binvalues:: Use this argument to retreive the values
%              corresponding to the histogram bins. See switch
%              <VAR>binmid</VAR> as well. The format of
%              the array returned is:<BR>
%              array(1,j): Number of bins in the <VAR>j</VAR>th
%                              dimension.<BR>
%              array(i+1,j): Data value corresponding to
%                                <VAR>i</VAR>th bin in the <VAR>j</VAR>th
%                              dimension.<BR>
%                  Array entries not used are set to <VAR>NaN</VAR>.
%  
% revidx:: This argument returns the list of reverse indices, i.e. a
%          vector containing a list of the original array subscripts that
%          contributed to each histogram bin. This list efficiently determines
%          which array elements are accumulated in a set of histogram
%          bins. The subscripts of the original array elements falling in
%          the <VAR>i</VAR>th bin are given by the expression: 
%*          R(R(i) : R(i+1)-1), 
%          where R is the reverse index list. If <VAR>R(i)</VAR> is equal
%          to <VAR>R(i+1)</VAR>, no elements are present in the
%          <VAR>i</VAR>th bin.<BR>
%          Note that although the histogram is multi-dimensional, bin
%          indices are counted linearly.
%
% RESTRICTIONS:
%  The routine has only been tested thorougly for two-dimensional data.
%
% PROCEDURE:
%  Convert the multidimensional data into a onedimensional one and do a
%  classical histogram on the linear bin indices.
%
% EXAMPLE:
%  Small example 
%* >> v=[[1,2,3,1,2,3,1,2,3];[10,20,30,10,20,30,20,30,10]]'
%* v =
%*     1    10
%*     2    20
%*     3    30
%*     1    10
%*     2    20
%*     3    30
%*     1    20
%*     2    30
%*     3    10
%*
%* >> h=histmd(v,'nbins',[3,5])
%* h =
%*     2     0     1     0     0
%*     0     0     2     0     1
%*     1     0     0     0     2
%
% Large example
%* >> a=10*randn(1000,1);
%* >> b=2*randn(1000,1);
%* >> [h,bv]=histmd([[a],[b]],'nbins',[20,30]);
%* >> subplot(1,2,1); imagesc(bv(2:bv(1,1)),bv(2:bv(1,2),2),h); axis xy
%* >> [h,bv]=histmd([[a],[b]],'nbins',[20,30],'min',[-10,-1],'max',[10,5]);
%* >> subplot(1,2,2); imagesc(bv(2:bv(1,1)),bv(2:bv(1,2),2),h); axis xy
%
% SEE ALSO:
%  MATLAB's hist() and hist3().
%-


function [result,binvalues,revidx]=histmd(s,varargin)
  
  % determine stimulus dimensions
  ssize = size(s);
  sdur = ssize(1);
  if (ndims(s)==1)
    sdim = 1;
  else
    sdim = ssize(2);
  end
  
  % find true extents of arrays
  truemin = min(s,[],1);
  truemax = max(s,[],1);

  % optional inputs
  kw=kwextract(varargin,...
               'binmid',true, ...
               'nbins',10*ones(1,sdim),...
               'min',truemin,'max',truemax);
  
  if (sdim~=length(kw.nbins))
    error('Need number of bins for each stimulus dimension.')
  end %if
  

  % Will truncation of values be needed due to user supplied
  % restriction? 
  minTruncation = logical(sum((truemin-kw.min)<0)~=0); 
  maxTruncation = logical(sum((kw.max-truemax)<0)~=0); 

  % rebin max and min for later comparison with data to find out
  % which entries are inside max and min ranges
  rebmin = repmat(kw.min, sdur, 1);
  rebmax = repmat(kw.max, sdur, 1);
  
  % bin sizes for each dimension
  sbinsize = (kw.max-kw.min)./(kw.nbins-1);

  % general idea:
  % for multidimensional stimuli, compute linear bin indices for each row
  % in the stimulus. 

  % blow up min and nbin arrays for later elementwise computations 
  rmin=repmat(kw.min,sdur,1);
  rbinsize=repmat(sbinsize,sdur,1);
  binidx=fix((s-rmin)./rbinsize);
  factor=cumprod([1 kw.nbins(1:end-1)]);

  % +1 since MATLAB counts indices starting at one, while the rest of the
  % algorithm assumes indices starting at 0
  idxmat=1+binidx*factor.';

  % Construct an array of out-of-range (0) and in-range (1) values.
  in_range = logical(ones(sdur,1));
  if (minTruncation) % set lt min to zero
    if (sdim==1)
      in_range = (s>=rebmin);
    else
      in_range = sum((s>=rebmin), 2)==sdim;
    end % if
  end % if
  
  if (maxTruncation) % set gt max to zero
    if sdim==1
      in_range = in_range & (s<=rebmax);
    else
      in_range = in_range & (sum((s<=rebmax), 2)==sdim);
    end % if
  end %if
  
  % Set values that are out of range to 0, since the histogram edges start at
  % bin idx 1, the out of range values are not counted.
  idxmat=idxmat.*in_range;

  % since indices are integer anyway, one may use the faster sliwhist
  % routine
  shist = sliwhist(idxmat, 'range',[1,prod(kw.nbins)]);

  % generate an array that contains the bin values.
  % nbins may differ for the different dimensions, thus the array is
  % generated to hold the maximum number of bins and the remainder is
  % initialized as NaN
  binvalues = NaN(max(kw.nbins)+1, sdim);
  binvalues(1, :) = kw.nbins;
  for idx=1:sdim
    binvalues(2:kw.nbins(idx)+1, idx) = ...
        kw.min(idx)+(0:kw.nbins(idx)-1) ...
        *sbinsize(idx)-0.5*sbinsize(idx)*not(kw.binmid);
  end % for
    
  % array for reverse indices
  n=length(shist);
  revidx = zeros(n+numel(idxmat)+1,1);
  ricount = n+2;

  for i=1:n 
    index = find(idxmat==i);
    count=length(index);
    if (count~=0)
      revidx(i) = ricount;
      revidx(ricount:ricount+count-1) = index;
      ricount = ricount+count;
    else
      revidx(i) = ricount;
    end % if count NE 0
  end % for i

  revidx(n+1) = ricount;
  
  % reshape the histogram before returning the result 
  if (sdim>1)
    result=reshape(shist, kw.nbins);
  else
    result=shist;
  end % if