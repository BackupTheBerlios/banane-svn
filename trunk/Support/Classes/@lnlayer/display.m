%+
% NAME:
%  display()
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
%  Mandatory display method for the <A>lnlayer</A> class.
%
% DESCRIPTION:
%  This routine computes the present activation state of a layer of
%  linear-nonlinear model neurons and prints the result to the screen.
%
% CATEGORY:
%  Support Routines<BR>
%  Classes<BR>
%  Simulation
%
% SYNTAX:
%* display(layer); 
%
% INPUTS:
%  layer:: An instance of the <A>lnlayer</A> class.
%
% OUTPUTS:
%  screen:: Displays the present activation of each neuron.
%
% PROCEDURE:
%  Compute the activation state and show it.
%
% EXAMPLE:
%* >> l=lnlayer(2,3,[1 -1 0],@threshlin);
%* >> l=lntimestep(l,rand(2,3));
%* >> display(l)
%* state =
%*     0.3561    0.9363    0.4640
%*     0.2573    0.7379    0.3794
%
% SEE ALSO:
%  <A>lnlayer</A>, <A>lntimestep</A>. 
%-


function display(l)

  statenow=l.nlf(l.kernel*l.past,l.nlfarglist);

  state=reshape(statenow,l.size);

  display(state);
