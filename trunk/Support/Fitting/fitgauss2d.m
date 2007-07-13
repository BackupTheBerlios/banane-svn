%+
% NAME:
%  fitgauss2d()
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
%  Compute the deviation of a 2D Gaussian and an arbitrary array.
%
% DESCRIPTION:
%  Support routine which computes the difference between a two
%  dimensional gaussian bell curve and an arbitray array. The bell curve
%  must be specified by 5 parameters, namely the x- and y-coordinates of
%  its peak, the maximum amplitude, and the standard deviations along the
%  x- and y-axes. This function can be used as an argument of MATLAB's
%  fminsearch routine.
%
% CATEGORY:
%   Support Routines<BR>
%   Fitting
%
% SYNTAX:
%* err = fitgauss2d(p,rf); 
%
% INPUTS:
%  p:: A five element vector representing the parameters of the Gaussian
%  curve. In detail, these are [<VAR>xpeak ypeak amplitude xwidth
%  ywidth</VAR>]. 
%  array:: A two dimensional numerical array to which the Gaussian bell
%  curve has to be fitted. 
%
% OUTPUTS:
%  err:: A scalar value representing the deviation between the array and
%  the Gaussian curve. <VAR>err</VAR> is computed as the sum over the
%  absolute differences between each element of <VAR>array</VAR> and the
%  corresponding element of the array containing the Gaussian. The result
%  is normailzed to the maximum value of <VAR>arra</VAR> to ensure that
%  error values are comparable across different amplitudes. An error
%  value of Inf is returned if the peak is positioned outside the array
%  and if the x- and y-widths are too small, i.e. below 0.1.
%
% PROCEDURE:
%  - Make sure that array is not empty.<BR>
%  - Return Inf if Gauss is too small or outside the array.<BR>
%  - Generate Gaussian array via <A>gauss2d</A>.<BR>
%  - Compute the difference and normalize.
%
% EXAMPLE:
%* >> vstart=[ix iy max(rf(:)) 1.5 1.5];
%* >> [v,fval] = fminsearch(@(v) fitgauss2d(v,rf),vstart);
%
% SEE ALSO:
%  <A>rffitting</A>, <A>gauss2d</A>. 
%-

function err = fitgauss2d(p,array)
  
  if (nnz(array)==0)
    
    warning('All elements equal to zero. Fitting does not make sense.')
    err=inf;
    
  else
  
    [n,m] = size(array);

    if ((p(1) < 1) | (p(1) > m) ...
        | (p(2) < 1) | (p(2) > n) ...
        | (p(4) <= .1) | (p(5) <= .1))
    
      err=inf;
    
    else
  
      fin=p(3)*gauss2d(m,n,p(1),p(2),p(4),p(5));
       
      diff=abs(array-fin);

      err=sum(diff(:))/max(array(:));
       
    end % if
  
  end % if
  