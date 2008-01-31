%+
% NAME:
%  threshlin()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  1/2008
%
% AIM:
%  Support function for linear-nonlinear model neurons.
%
% DESCRIPTION:
%  This routine can be used as a nonlinear transfer function for
%  linear-nonlinear model neurons initialized by <A>lnlayer</A>. It
%  clips values below a given threshold to zero and multiplies values
%  above the threshold by a given factor.
%
% CATEGORY:
%  Support Routines<BR>
%  Classes<BR>
%  Misc<BR>
%  Simulation
%
% SYNTAX:
%* result=threshlin(act[{,theta[,factor]}]); 
%
% INPUTS:
%  act:: The activation that has to be transformed. This can be any
%  matrix of numerical values.
%
% OPTIONAL INPUTS:
%  theta:: The threshold argument. Values in <VAR>act</VAR> below the
%  threshold are clipped to zero. Default: 0. Note that the argument must
%  be the first element of a MATLAB cell array.
%  factor:: The factor with which the remaining nonzero values in
%  <VAR>act</VAR> are multiplied. Default: 1. Note that the argument must
%  be the second element of a MATLAB cell array.
%
% OUTPUTS:
%  result:: The converted values.
%
% PROCEDURE:
%  Setting the default values and computation.
%
% EXAMPLE:
%* >> x=linspace(-1,1);
%* >> y=threshlin(x,{0.1,0.05});
%* >> plot(x,y)
%
% SEE ALSO:
%  <A>lnlayer</A>, <A>sigmoid</A>. 
%-

function result=threshlin(act,argin)
  
  switch numel(argin)
   case 0
    theta=0;
    factor=1;
   case 1
    theta=argin{1};
    factor=1;
   case 2
    theta=argin{1};
    factor=argin{2};
   otherwise
    error('Wrong number of arguments.')
  end % switch
  
  result=factor*(act-theta);
  
  result(result<=0)=0;