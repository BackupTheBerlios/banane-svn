%+
% NAME:
%  searchNEVbyField()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  E. Maynard
%
% DATE CREATED:
%  08/09/00
%
% AIM:
%  Short description of the routine in a single line.
%
% DESCRIPTION:
%  Uses a linear search of the NEV file for packets satisfying a set of
%  criteria. NOTES: Times cannot be specified in seconds but must be
%  specified in terms of timeStamps. Valid field names are: timeStamp,
%  electrode, unit, waveform(sample Number), dio, bitFlag, analog1,
%  analog2, analog3, analog4, analog5.  
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