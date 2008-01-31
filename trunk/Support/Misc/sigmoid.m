%+
% NAME:
%  sigmoid()
%
% VERSION:
%  $Id:$
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
%  transforms its input values according to the sigmoid function
%*  f(x)=factor / (1+exp((-x+xshift)*tau))
%
% CATEGORY:
%  Support Routines<BR>
%  Classes<BR>
%  Misc<BR>
%  Simulation
%
% SYNTAX:
%* result=sigmoid(act[{,xshift[,factor[,factor]]}]); 
%
% INPUTS:
%  act:: The activation that has to be transformed. This can be any
%  matrix of numerical values.
%
% OPTIONAL INPUTS:
%  xshift:: This argument specifies the value in <VAR>act</VAR> that is
%  converted to half the maximum of the resulting array. Default: 0. Note
%  that the argument must
%  be the first element of a MATLAB cell array.
%  factor:: The asymptotic amplitude of the result. Default: 1. Note that
%  the argument must 
%  be the second element of a MATLAB cell array.
%  tau:: The steepness of the curve. The larger <VAR>tau</VAR>, the
%  steeper the curve. Default: 10.
%
% OUTPUTS:
%  result:: The converted values.
%
% PROCEDURE:
%  Setting the default values and computation.
%
% EXAMPLE:
%* >> x=linspace(-1,1);
%* >> y=sigmoid(x,{0.1,0.05,5.});
%* >> plot(x,y)
%
% SEE ALSO:
%  Optional section: Mention related or required files here. Banane routines may be refenced as anchors <A>loadNEV</A>. 
%-

function result=sigmoid(act,argin)
  
  switch numel(argin)
   case 0
    xshift=0;
    factor=1;
    tau=10;
   case 1
    xshift=argin{1};
    factor=1;
    tau=10;
   case 2
    xshift=argin{1};
    factor=argin{2};
    tau=10;
   case 3
    xshift=argin{1};
    factor=argin{2};
    tau=argin{3};
   otherwise
    error('Wrong number of arguments.')
  end % switch
  
  result=factor./(1+exp((-act+xshift).*tau));
  
