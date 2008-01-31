%+
% NAME:
%  dog2d()
%
% VERSION:
%  $Id: $
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  1/2008
%
% AIM:
%  Fill a two dimensional array with a Difference of Gaussians function.
%
% DESCRIPTION:
%  dog2d() generates a two dimensional array filled with values
%  representing a Difference of Gaussians function. The position of the
%  curve's peak, the width and the ratio of the positive and negative
%  part can be modified.
%
% CATEGORY:
%  Support Routines<BR>
%  Arrays
%
% SYNTAX:
%* result=dog2d2d(height[,width[,ypeak[,xpeak[,sigma[,ratio]]]]]); 
%
% INPUTS:
%  height:: The number of rows of the resulting array.
%
% OPTIONAL INPUTS:
%  width:: The number of columns of the resulting array. If
%  <VAR>width</VAR> is not specified, a square array is returned.
%  ypeak:: The position of the curve's maximum along the y-axis. Position
%  is measured relative to the arrays origin, i.e. to 
%  index (1,1). If <VAR>ypeak</VAR> is unspecified, the peak is
%  positioned in the middle of the array.
%  xpeak:: The position of the curve's maximum along the x-axis. Position
%  is measured relative to the arrays origin, i.e. to 
%  index (1,1). If <VAR>xpeak</VAR> is unspecified, the peak is
%  positioned in the middle of the array.
%  sigma:: The width (standard deviation) of the center, positive
%  part. Default: <VAR>ysigma=height/10</VAR>. 
%  ratio:: The factor specifying the how much larger the negative
%  (surround) part is
%  with respect to the positive (center) part. Default: <VAR>ratio=1.6</VAR>.
%
% OUTPUTS:
%  result:: Numerical array of dimension (<VAR>height</VAR> x
%  <VAR>width</VAR>). The curve is normalized such that both the positive
%  and the negative part sum to 1, and the total array thus has a sum of
%  zero.
%
% RESTRICTIONS:
%  The option to tilt the curve is not yet implemented.
%
% PROCEDURE:
%  Generate two grid arrays, one for the x-, the other for the
%  y-direction, compute two normalized Gaussian functions on the grid
%  values. Subtract the second Gaussian from the first.
%
% EXAMPLE:
%* >> colormap('jet')
%* >> surf(dog2d(50,100,25,40,5))
%
% SEE ALSO:
%  <A>gauss2d</A>. 
%-


function result=dog2d(height,width,ypeak,xpeak,sig,ratio)

  % generate default values
  if (~exist('width'))
    width=height;
  end

  if (~exist('xpeak'))
    xpeak=width/2;
  end

  if (~exist('ypeak'))
    ypeak=height/2;
  end

  if (~exist('sig'))
    sig=height/10;
  end

  if (~exist('ratio'))
    ratio=1.6;
  end
  
  if (ratio<=1)
    warning(['Ratio<=1 will result in reversal of positive and negative ' ...
             'parts.'])
  end
  
  xgrid=repmat((1:width)-xpeak,height,1);
  ygrid=repmat((1:height)'-ypeak,1,width);

  argsum=xgrid.^2/(sig^2)+ygrid.^2/(sig^2);
  
  result=exp(-argsum/2)/(2*pi*sig.^2) ...
         - exp(-argsum/(2*ratio.^2))/(2*pi*sig.^2*ratio.^2);
  