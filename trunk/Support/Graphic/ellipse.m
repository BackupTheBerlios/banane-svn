%+
% NAME:
%  ellipse()
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
%  Compute and return coordinates for plotting an ellipse.
%
% DESCRIPTION:
%  ellipse() generates an array containing coordinates that can be used
%  to plot an ellipse. 
%
% CATEGORY:
%  Support Routines<BR>
%  Graphic
%
% SYNTAX:
%* coords=ellipse(n,xcenter,ycenter,xradius,yradius); 
%
% INPUTS:
%  n:: The number of coordinates to compute. The larger the number, the
%  smoother the resulting curve will be.
%  xcenter:: The center coodinate of the ellipse along the x-axis.
%  ycenter:: The center coodinate of the ellipse along the y-axis.
%  xradius:: The radius in x-direction.
%
% OPTIONAL INPUTS:
%  yradius:: The radius in y-direction. If <VAR>yradius</VAR> is not
%  supplied, <VAR>yradius</VAR>=<VAR>xradius</VAR>, i.e. the coordinates
%  returned describe a circle. 
%
% OUTPUTS:
%  coords:: A 2x(<VAR>n</VAR>+1) double array containing the x- and y
%  coordinates.
%
% PROCEDURE:
%  Sin and Cos.
%
% EXAMPLE:
%  Indicate example lines with * as the first character. These lines
%  will be typeset in a fixed width font. Indicate user input with >>. 
%* >> circ=ellipse(10,2,4,1);
%* >> plot(circ(1,:),circ(2,:));
%* >> hold on
%* 
%* >> circ=ellipse(100,2,4,1);
%* >> plot(circ(1,:),circ(2,:),'k');
%* 
%* >> ell=ellipse(100,2,4,1,0.5);
%* >> plot(ell(1,:),ell(2,:),'r');
%*
%* >> ell=ellipse(100,2,4,0.25,0.5);
%* >> plot(ell(1,:),ell(2,:),'g');
%* >> hold off
%
%-


function coords=ellipse(n,xcenter,ycenter,xradius,yradius)

  if (~exist('yradius'))
    yradius=xradius;
  end
  
  arc = 2*pi*(0:n)/n;

  x=xradius*cos(arc)+xcenter;
  y=yradius*sin(arc)+ycenter;

  coords=[x;y];
  
end

