%+
% NAME:
%  lntimestep()
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
%  Compute the new state of a layer of linear-nonlinear model neurons.
%
% DESCRIPTION:
%  This routine computes the new activation state of a population of
%  linear-nonlinear model neurons initialized with <A>lnlayer</A>,
%  depending on the present input to each of the neurons. The activation
%  state of linear-nonlinear model neurons is 
%  interpreted as the probability of generating action potentials. This
%  activation state is computed by convolving the previous inputs of an
%  individual neuron with a temporal filter kernel and passing this
%  'generator potential' to a nonlinear function. When using the
%  <A>lnlayer</A> 
%  class, any spacial processing has to be implemented prior to feeding
%  the individual inputs into the members of the neuron layer. The
%  lnlayer itself takes care of saving the past inputs, convolution with
%  the temporal kernel, and applying the nonlienar function to the
%  result.
%
% CATEGORY:
%  Support Routines<BR>
%  Classes<BR>
%  Simulation
%
% SYNTAX:
%* [layer,now] = lntimestep(layer, input); 
%
% INPUTS:
%  layer:: Instance of the <A>lnlayer</A> class.
%  input:: Matrix of numerical values describing the present input
%  to each of the neurons within the layer. The dimensions of
%  <VAR>input</VAR> must match those of the neuron layer.
%
% OUTPUTS:
%  layer:: The updated layer object.
%  now:: A matrix representing the activity of each neuron. This may be
%  interpreted as each neuron's firing probability. Poisson spiking may
%  be simulated by a comparison of the resulting activation with an array
%  of randomly generated numbers. See example.
%
% PROCEDURE:
%  Save the new input as the first entry of the sequence of past
%  inputs. Multiply this past sequence with the temporal kernel and pass
%  the results to the nonlinear function. 
%
% EXAMPLE:
%* >> l=lnlayer(2,3,[1 -1 0],@threshlin);
%* >> [l,state]=lntimestep(l,rand(2,3));
%* >> state
%* state =
%*     0.0539    0.2699    0.0386
%*     0.5530    0.9483    0.8522
%* >> spikes=rand(2,3)<state
%* spikes =
%*      0     0     0
%*      0     1     1
%
% SEE ALSO:
%  <A>lnlayer</A>, <A>threshlin</A>, <A>sigmoid</A>. 
%-


function [l,state]=lntimestep(l,input)
  
  if ~isequal(size(input), l.size)
    ('Input dimensions do not match layer dimensions.')
  end
  
  l.past=circshift(l.past,1);
  
  l.past(1,:)=input(:);
      
  statenow=l.nlf(l.kernel*l.past,l.nlfarglist);

  state=reshape(statenow,l.size);


