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



% NAME:
%  searchNEVbyField()
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
%  Uses a linear search of the NEV file for packets satisfying a set of criteria.
%
% DESCRIPTION:
% Uses a linear search of the NEV file for packets satisfying a set of
% criteria. NOTES: Times cannot be specified in seconds but must be
% specified in terms of timeStamps. Valid field names are: timeStamp,
% electrode, unit, waveform(sample Number), dio, bitFlag, analog1,
% analog2, analog3, analog4, analog5 
%
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* [retVal, indices] = searchNEVByField(nevObject, criteria, startIndex, stopIndex)
%* [retVal, indices] = searchNEVByField(nevObject, criteria, [startIndex = 1], [stopIndex = inf])
% 
%
% INPUTS:
% nevObject:: object created by call to openNEV
%		criteria:: a string which evaluates to a logical expression (see examples following).
%	
%
% OPTIONAL INPUTS:
%  	startIndex:: specify a starting index for the search
%	stopIndex:: specify a stopping index for search.
% 
%
% OUTPUTS:
%  retVal:: 1 or 0 indicating whether the searched packet satisfield the criteria
%  indices:: indices of packets searched
%
%
% PROCEDURE:
%  Since this is an adopted routine, its working is not exactly known.
%
% EXAMPLE:
%  all spikes on electrode 5: 
%*  A = searchNev(Neu, 'electrode == 5');
%  all spikes on electrode 5 that are unit 0: 
%*  A = searchNev(Neu, 'electrode == 5 & unit == 0');
%  find all spikes on electrode 5 before 1 second: 
%*  A = searchNev(Neu, 'electrode == 5 & timeStamp < 30000');
%  find all spikes on electrodes 1 and 5: 
%*  A = searchNev(Neu, 'ismember(electrode, [1 5])');
%  all stimulus packets with a dio value of 129: 
%*  A = searchNev(Neu, 'dio == 129');
%
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  <A>getPackets</A>, Specification for the NEV file formats NEVspc20.pdf


function [retVal, indices] = searchNEVByField(nevObject, criteria, startIndex, stopIndex)

if nargin < 3, startIndex = 1; stopIndex = nevObject.FileInfo.packetCount; end;
if nargin < 4, 
	if length(startIndex) > 1,
		stopIndex = max(startIndex);
		startIndex = min(startIndex);
	else,
		stopIndex = nevObject.FileInfo.packetCount;
	end
end

fid = nevObject.FileInfo.fid;
% Find variables in the criteria string
d = symvar(criteria);
% Find any 'waveform' comparisons
y = findstr(criteria, 'waveform');
if ~isempty(y),
	t = findstr(criteria(y(1):end), ' ');
	u = criteria(y(1):y(1)+t(1)-2);
	d = cat(1, d, {u});
end

indices = (startIndex : stopIndex)';
retVal = zeros(size(indices));

H = waitbar(0, 'Searching NEV file...');
for i = startIndex : stopIndex,
% Update user interface
	if mod(i, 1000) == 0, waitbar(i / length(indices)); end;
% Get the packet
	packet = getPackets(nevObject, i);
	P = criteria;
% Process the criteria for the packets
	try,
		for j = 1 : length(d),
			if ~isempty(findstr(d{j}, 'waveform')),
				eval(['s = packet.' d{j} ';']);
			else,
				s = getfield(packet, d{j});
			end
			P = strrep(P, d{j}, num2str(s));
		end
		retVal(i-startIndex+1) = eval(P);
	end
end
close(H);
