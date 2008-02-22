%+
% NAME:
%  example_function()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  J. R. Hacker
%
% DATE CREATED:
%  9/2002
%
% AIM:
%  Short description of the routine in a single line.
%
% DESCRIPTION:
%  Detailed description of the routine. The text may contain small HTML
%  tags like for example <BR> linebreaks or <VAR>variable name
%  typesetting</VAR>. Simple anchors to other banane routines are
%  also allowed, eg <A>kwextract</A>.<BR>
%  Please put this header in front of every banane routine and modify it
%  according to the routine you want to commit. Since the header is
%  parsed later to transfer the information to the banane web docu, it is
%  important to keep the syntax identical to this example, i.e. the
%  sections must be marked with capital letters and their order
%  must not be changed. All sections have to appear unless they are
%  marked here by "optional section". The header must start with the
%  characters "%+" at the beginning of a single line and end with the
%  characters "%-", 
%  again at the beginning of a single line. 
%  If the syntax is not correct, it cannot be
%  parsed and the header information will not appear in the online
%  documentation. 
%
% CATEGORY:
%  At present, there are the following possibilities:<BR>
%   - DataStructures<BR>
%   - Documentation<BR>
%   - NEV Tools<BR>
%   - Support Routines<BR>
%   - Arrays<BR>
%   - Classes<BR>
%   - Misc<BR>
%   - Strings<BR>
%   - Receptive Fields<BR>
%   - Signals<BR>
%   - Statistics<BR>
%  Others may be invented, with corresponding subdirectories in the
%  BANANE directory tree. For example:<BR>
%   - DataStorage<BR>
%   - Demonstration<BR>
%   - Graphic<BR>
%   - Help<BR>
%   - Simulation<BR>
%
% SYNTAX:
%* result = example_function(arg1, arg2 [,'optarg1',value][,'optarg2',value]); 
%
% INPUTS:
%  arg1:: First argument of the function call. Indicate variable type and
%  function.
%  arg2:: Second argument of the function call.
%
% OPTIONAL INPUTS:
%  optarg1:: An optional input argument.
%  optarg2:: Another optional input argument. Of course, the whole
%  section is optional, too.
%
% OUTPUTS:
%  result:: The result of the routine.
%
% RESTRICTIONS:
%  Optional section: Is there anything known that could cause problems?
%
% PROCEDURE:
%  Short description of the algorithm.
%
% EXAMPLE:
%  Indicate example lines with * as the first character. These lines
%  will be typeset in a fixed width font. Indicate user input with >>. 
%* >> data=example_function(23,5)
%* ans =
%*   28
%
% SEE ALSO:
%  Optional section: Mention related or required files here. Banane routines may be refenced as anchors <A>loadNEV</A>. 
%-



function result = funcname(arg1,arg2);
  
  result = arg1+arg2;
