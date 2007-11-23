%+
% NAME:
%  gauss2d()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  5/2007
%
% AIM:
%  Fill a two dimensional array with a Gaussian bell curve.
%
% DESCRIPTION:
%  gauss2d() generates a two dimensional array filled with values
%  representing a Gaussian bell curve. The position of the curve's peak
%  and the standard deviations in both x- and y-directions can be
%  modified.
%
% CATEGORY:
%  Support Routines<BR>
%  Arrays
%
% SYNTAX:
%* result=gauss2d(width[,height[,xpeak[,ypeak[,xsigma[,ysigma]]]]]); 
%
% INPUTS:
%  width:: The number of columns of the resulting array.
%
% OPTIONAL INPUTS:
%  height:: The number of rows of the resulting array. If
%  <VAR>height</VAR> is not specified, a square array is returned.
%  xpeak:: The position of the curve's maximum along the x-axis. Position
%  is measured relative to the arrays origin, i.e. to 
%  index (1,1). If <VAR>xpeak</VAR> is unspecified, the peak is
%  positioned in the middle of the array.
%  ypeak:: The position of the curve's maximum along the y-axis. Position
%  is measured relative to the arrays origin, i.e. to 
%  index (1,1). If <VAR>ypeak</VAR> is unspecified, the peak is
%  positioned in the middle of the array.
%  xsigma:: The width (standard deviation) of the curve along the
%  x-axis. Default: <VAR>width/10</VAR>.
%  ysigma:: The width (standard deviation) of the curve along the
%  y-axis. Default: <VAR>ysigma=xsigma</VAR>.
%
% OUTPUTS:
%  result:: Numerical array of dimension (<VAR>width</VAR> x
%  <VAR>height</VAR>). The maximum value is equal to 1.
%
% RESTRICTIONS:
%  The option to tilt the Gaussian is not yet implemented.
%
% PROCEDURE:
%  Generate two grid arrays, one for the x-, the other for the
%  y-direction, and compute gaussian function on the grid values.
%
% EXAMPLE:
%* >> imagesc(gauss2d(100,50,10,10))
%
% SEE ALSO:
%  <A>rffitting</A>, <A>fitgauss2d</A>. 
%-


function result=gauss2d(width,height,xpeak,ypeak,xsigma,ysigma)

  % generate default values
  if (~exist('height'))
    height=width;
  end

  if (~exist('xpeak'))
    xpeak=width/2;
  end

  if (~exist('ypeak'))
    ypeak=height/2;
  end

  if (~exist('xsigma'))
    xsigma=width/10;
  end

  if (~exist('ysigma'))
    ysigma=xsigma;
  end
  
  xgrid=repmat((1:width)-xpeak,height,1);
  ygrid=repmat((1:height)'-ypeak,1,width);

  result=exp(-(xgrid.^2/(2.*xsigma^2)+ygrid.^2/(2.*ysigma^2)));
  