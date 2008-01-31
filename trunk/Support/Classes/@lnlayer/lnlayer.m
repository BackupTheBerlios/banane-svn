%+
% NAME:
%  lnlayer()
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
%  Constructor method for a layer of linear-nonlinear model neurons.
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
%* l = lnlayer(rows,cols,kernel,nlf[,varargin]); 
%
% INPUTS:
%  rows:: Number of rows of the resulting layer.
%  cols:: Number of columns of the resulting layer.
%  kernel:: Double precision vector corresponding to the temporal filter
%           kernel that is used to determine the neurons' generator
%           potential from
%           its past input. The length of the kernel determines the
%           temporal memory.
%  nlf:: Function handle describing the nonlinear function used to
%        convert the neurons' generator potential into its output
%        activation, i.e. the firing probability. 
%
% OPTIONAL INPUTS:
%  varargin:: Arguments needed by the nonlinear function may be appended
%             here.
%
% OUTPUTS:
%  l:: An object describing a layer of linear-nonlinear model neurons.
%
% RESTRICTIONS:
%  Maybe include possibility to initialize past values with other than
%  zero.
%
% PROCEDURE:
%  Mainly syntax check.
%
% EXAMPLE:
%* >> onlay=lnlayer(2,3,[1 -1 0],@threshlin,0.,0.3);
%
% SEE ALSO:
%  <A>lntimestep</A>, <A>threshlin</A>, <A>sigmoid</A>. 
%-

function l = lnlayer(rows,cols,kernel,nlf,varargin)
  
  if (nargin==1)

    if (strcmp(class(rows),'lnlayer'))
      l=rows;
    else
      error('Wrong type of input argument.')
    end
  
  else

    if (nargin<4)
      error('Cannot create lnlayer object with less than 4 arguments.')
    else
      if (ndims(kernel)>2)||(size(kernel,1)~=1)
        error('Kernel must be a row vector.')
      else
        l.kernel = kernel;
      end
      
      if isa(nlf, 'function_handle')
        l.nlf = nlf;
      else
        error('Fourth argument must be a function handle.')
      end
      
      l.nlfarglist=varargin;
      l.past = zeros(length(l.kernel), rows*cols);
      l.size=[rows cols];
      l = class(l,'lnlayer');
    end % if (nargin<4)
    
  end % if (nargin==1)