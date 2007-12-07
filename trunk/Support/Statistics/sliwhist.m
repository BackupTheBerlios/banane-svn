%+
% NAME:
%  sliwhist()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  12/2007
%
% AIM:
%  Fast histogram computation for positive integer values.
%
% DESCRIPTION:
%  This routine computes one or more histograms of positive integer
%  values including zero. It is nearly twice as fast as MATLAB's
%  histc() function. The algorithm is based on an idea by Lukasz
%  Sliwczynski and extended to enable the computation of multiple column
%  histograms with a single call.
%
% CATEGORY:
%  Support Routines<BR>
%  Statistics
%
% SYNTAX:
%* result=sliwhist(s[,'range',vector]); 
%
% INPUTS:
%  s:: A column vector or two-dimensional matrix of positive integers. If
%  <VAR>s</VAR> is a matrix, histograms are computed along the columns.
%
% OPTIONAL INPUTS:
%  range:: A two-element vector specifying the minimum and maxim values
%  to be considered in the histogram computation. If <VAR>range</VAR> is
%  not set, the histogram is computed to contain all values from the
%  minimum to the maximum. 
%
% OUTPUTS:
%  result:: Either a column vector or a two-dimensional matrix containing
%  the histogram.
%
% PROCEDURE:
%  The idea is to sort the data sequence and then only to calculate the
%  distance between steps in this sorted sequence. The rest of the
%  algorithm deals with enabling columnwise histogram computation without
%  using loops.
%
% EXAMPLE:
%  Indicate example lines with * as the first character. These lines
%  will be typeset in a fixed width font. Indicate user input with >>. 
%* >> s=fix(10*randn(1000,10))+50;
%* >> sh=sliwhist(s,'range',[40 60]);
%* >> shm=histc(s,(40:60));
%* >> bar(sh(:,2));
%* >> hold on
%* >> plot(shm(:,2),'r');
%
% SEE ALSO:
%  <A>histMD</A>, MATLAB's histc(). 
%-



function result=sliwhist(s,varargin)
  
  if (ndims(s)>2)
    error('Input array has too many dimensions.');
  end

  mas=double(max(s(:)));
  
  kw=kwextract(varargin,'range',[]);
  
  if (isempty(kw.range))
    kw.range=[double(min(s(:))) mas];
  end %if  
      
  if (kw.range(1)>=kw.range(2))
    error('First range value must not be larger or equal to second range value.');
  end

  nbins=mas+1;
  
  [nrows,nrep]=size(s);
    
  result=zeros(nbins,nrep);
  
  gs=sort(s);
  
  gsd=[diff(gs);nrows*ones(1,nrep)];
  
  linidx=find(gsd);
  
  v=double(gs(linidx)+1);
  
  rows=rem(linidx,nrows);
  cols=(ceil(linidx/nrows)-1);
  
  dc=diff([0; rows]);
  
  colswitch=find(dc<=0);
  
  dc(colswitch)=nrows+dc(colswitch);
      
  result(v+cols*nbins)=dc;
  
  if (kw.range(2)>mas)
    result=[result;zeros(kw.range(2)-mas,nrep)];
  elseif (kw.range(2)<mas)
    result=result(1:kw.range(2)+1,:);
  end

  if (kw.range(1)~=0)
    result=result(kw.range(1)+1:end,:);
  end

