%+
% NAME:
%  sliwhist()
%
% VERSION:
%  $Id:$
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
%  Based on an idea by Lukasz Sliwczynski.
%
% CATEGORY:
%   Support Routines<BR>
%   Statistics
%
% SYNTAX:
%* result = example_function(arg1, arg2 [,'optarg1',value][,'optarg2',value]); 
%
% INPUTS:
%  arg1:: First argument of the function call. Indicate variable type and
%  function.
%  arg2:: Second argument of the function call.
%
% OPTIONAL INPUTS:
%  optarg1:: An optional input argument.
%  optarg2:: Another optional input argument. Of course, the whole
%  section is optional, too.
%
% OUTPUTS:
%  result:: The result of the routine.
%
% RESTRICTIONS:
%  Optional section: Is there anything known that could cause problems?
%
% PROCEDURE:
%  Short description of the algorithm.
%
% EXAMPLE:
%  Indicate example lines with * as the first character. These lines
%  will be typeset in a fixed width font. Indicate user input with >>. 
%* >> data=example_function(23,5)
%* ans =
%*   28
%
% SEE ALSO:
%  Optional section: Mention related or required files here. Banane routines may be refenced as anchors <A>loadNEV</A>. 
%-



function result=sliwhist(s,varargin)
  
  if (ndims(s)>2)
    error('error!');
  end

  mas=max(s(:));
  
  kw=kwextract(varargin,'range',[]);
  
  if (isempty(kw.range))
    kw.range=[min(s(:)) mas];
  end %if  
      
  if (kw.range(1)>kw.range(2))
    error('error!');
  end

  nbins=uint32(mas+1);
  
  [nrows,nrep]=size(s);
    
  result=zeros(nbins,nrep);
  
  gs=sort(s);
  
  gsd=[diff(gs);nrows*ones(1,nrep)];
  
  linidx=find(gsd);
  
  v=uint32(gs(linidx)+1);
  
  rows=rem(linidx,nrows);
  cols=uint32(ceil(linidx/nrows)-1);
  
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

