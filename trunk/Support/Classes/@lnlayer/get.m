%+
% NAME:
%  get()
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
%  The get method for the <A>lnlayer</A> class.
%
% DESCRIPTION:
%  This routine may be used to obtain information about the properties of
%  a <A>lnlayer</A> object.
%
% CATEGORY:
%  Support Routines<BR>
%  Classes<BR>
%  Simulation
%
% SYNTAX:
%* result = get(layer, propertyname); 
%
% INPUTS:
%  layer:: An instance of the <A>lnlayer</A> class.
%  propertyname:: A string describing which property should be
%  returned. Presently, only the dimensions of the neuron layer may be
%  returned via the 'Size' property.
%
% OUTPUTS:
%  result:: The desired information concerning the property given by
%  <VAR>propertyname</VAR>. For <VAR>propertyname='Size'</VAR>, the
%  result will be a two-element vector specifying the number of rows and
%  columns of the neuron layer.
%
% RESTRICTIONS:
%  Only a single property is implemented yet.
%
% PROCEDURE:
%  Simple switch/case.
%
% EXAMPLE:
%* >> onlay=lnlayer(2,3,[1 -1 0],@threshlin,0.,0.3);
%* >> get(onlay,'Size')
%* ans =
%*      2     3
%
% SEE ALSO:
%  <A>lnlayer</A>. 
%-


function val = get(a, propName)

  switch propName
   
   case 'Size'
    val = a.size;
   otherwise
    error([propName,' is not a valid lnlayer property.'])
  end