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
%  Detailed description of the routine. The text may contain small HTML
%  tags like for example <BR> linebreaks or <VAR>variable name
%  typesetting</VAR>. Simple anchors to other banane routines are
%  also allowed, eg <A>kwextract</A>.
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
%  layer:: First argument of the function call. Indicate variable type and
%  function.
%  input:: Matrix of numerical values describing the present input
%  to each of the neurons within the layer. The dimensions of
%  <VAR>input</VAR> must match those of the neuron layer.
%
% OUTPUTS:
%  layer:: The updated layer object.
%  now:: A matrix representing the activity of each neuron. This may be
%  interpreted as each neuron's firing probability. 
%
% PROCEDURE:
%  Save the new input as the first entry of the sequence of past
%  inputs. Multiply this past sequence with the temporal kernel and pass
%  the results to the nonlinear function. 
%
% EXAMPLE:
%  Indicate example lines with * as the first character. These lines
%  will be typeset in a fixed width font. Indicate user input with >>. 
%* >> data=example_function(23,5)
%* ans =
%*   28
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


