%+
% NAME:
%  searchNEVbyTime()
%
% VERSION:
%  $Id: $
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  08/09/00
%
% AIM:
%  This function can be used to quickly find the index in the NEV file corresponding to a particular time in seconds.
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


%
%
%
% DESCRIPTION:
% This function can be used to quickly find the index in the NEV file corresponding to a
% particular time in seconds. This function should be used instead of the MUCH slower searchNEV
% for time-based inquiries. The results of this search can be used to shorten the search time
% of searchNEV if the desired packets lay in a time region.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* index = searchNEVByTime(nevObject, time)
% 
%
% INPUTS:
%  nevObject:: nev object created by openNEV
%  time:: time in seconds
%
% OUTPUTS:
%  index:: if the returned value is a:<BR>
%		fractional value (e.g. 10.5): then the time falls between two packets<BR>
%		single integer: then the packet at index matches the time<BR>
%		list of values: then there are multiple packets that occured at that time<BR>
%		+inf: then time is greater than the maximum packet time<BR>
%		-inf: then time is less than the minimum packet time
%
%
% PROCEDURE:
%  Since this is an adopted routine, its working is not exactly known.
%
% EXAMPLE:
%  none
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  <A>searchNEV</A>, Specification for the NEV file formats NEVspc20.pdf
%

function index = searchNEVByTime(nevObject, time)

timeIndex = fix(time .* nevObject.HeaderBasic.timeResolution);
if timeIndex > getPackets(nevObject, nevObject.FileInfo.packetCount, 'timeStamp'), index = inf; return; end;
if timeIndex == getPackets(nevObject, nevObject.FileInfo.packetCount, 'timeStamp'), index = nevObject.FileInfo.packetCount; return; end;
if timeIndex < getPackets(nevObject, 1, 'timeStamp'), index = -inf; return; end;
if timeIndex == getPackets(nevObject, 1, 'timeStamp'), index = 1; return; end;

left = 1;
right = nevObject.FileInfo.packetCount;
while 1,
	if (right - left) <= 1,
		index = (left + right) / 2;
		return;
	else,
		mid = floor((left + right) / 2);
		t = getPackets(nevObject, mid, 'timeStamp');
%		disp([left right mid t]);
		if t == timeIndex,
			I = max([1 mid-100]):min([mid+100 nevObject.FileInfo.packetCount]);
			t = getPackets(nevObject, I, 'timeStamp');
			index = I(t == timeIndex);
			return;
		else
			if t < timeIndex,
				left = mid;
			else
				right = mid;
			end
		end
	end
end
