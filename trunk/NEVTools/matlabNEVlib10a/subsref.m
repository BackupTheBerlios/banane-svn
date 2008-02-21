%+
% NAME:
%  subsref()
%
% VERSION:
%  $Id: subsref.m 15/9/00  version 1.2 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  15/9/00 
%
% AIM:
%  Overloaded reference to NEV object.
%
%
% DESCRIPTION:
% Overloaded reference to NEV object. This is a MATLAB support function for the NEV class.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* Z = subsref(A, S);
% 
%
% INPUTS:
% --
%
% OPTIONAL INPUTS:
%  	--
% 
%
% OUTPUTS:
% --
%
% PROCEDURE:
%  Since this is an adopted routine, its working is not exactly known.
%
% EXAMPLE:
%  --
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  <A>subsarg</A>, Specification for the NEV file formats NEVspc20.pdf
%
%
function Z = subsref(A, S);

try,

% Process the first access
Z = getfield(struct(A), S(1).subs);
if length(S) == 1, return; end

switch S(1).subs,
	case {'FileInfo', 'HeaderBasic'},
		Z = subsref(Z, S(2:end));
	case 'HeaderExtended',
		for i = 2 : length(S),
			switch S(i).type,
				case '.',
					K = [];
					switch class(Z),
						case 'cell', for j = length(Z) : -1 : 1, K(j,1) = nan; try, K(j) = getfield(Z{j}, S(i).subs); end; end;
						case 'struct', for j = length(Z) : -1 : 1, K(j,1) = nan; try, K(j) = getfield(Z(j), S(i).subs); end; end;
						otherwise, error('Structure access to non-structure elements.');
					end
					Z = K(1:length(Z));
				case '{}',
					range = S(i).subs{:}; K = {}; for j = length(range) : -1 : 1, K{j,1} = Z{range(j)}; end; Z = K;
				case '()',
					if isa(Z, 'double'), Z = subsref(Z, S(i)); else, error(['Attempted ''()'' reference to ''' class(Z) '''-type elements.']); end;
			end
		end
	case 'SpikeData',
% Trap for 'end' calls??????
		for i = 2 : length(S),
			switch S(i).type,
				case '.',
					if ~isa(Z, 'struct'), error('Attempted structure access to non-structure elements.'); end;
					eval(strcat('Z = cat(1, Z.', S(i).subs, ');'));
				case '()',
					switch class(Z),
						case 'struct',
							range = S(i).subs{:};
							Z = struct('index', num2cell(Z.index(range)), 'timeStamp', num2cell(Z.timeStamp(range)), ...
											'electrode', num2cell(Z.electrode(range)), 'unit', num2cell(Z.unit(range)));
						case {'uint32', 'uint8'}, Z = subsref(Z, S(i));
					end
				case '{}', error('Attempted cell access to non-cell elements.');
			end
		end
	case 'StimulusData',
% Trap for 'end' calls??????
		for i = 2 : length(S),
			switch S(i).type,
				case '.',
					if ~isa(Z, 'struct'), error('Attempted structure access to non-structure elements.'); end;
					eval(strcat('Z = cat(1, Z.', S(i).subs, ');'));
				case '()',
					switch class(Z),
						case 'struct',
							range = S(i).subs{:};
							Z = struct('index', num2cell(Z.index(range)), 'timeStamp', num2cell(Z.timeStamp(range)), ...
											'trigger', num2cell(Z.trigger(range)), 'dio', num2cell(Z.dio(range)), ...
											'analog', num2cell(Z.analog(range,:), 2));
						case {'uint32', 'uint8', 'uint16', 'int16'}, Z = subsref(Z, S(i));
					end
				case '{}', error('Attempted cell access to non-cell elements.');
			end
		end
end


switch class(Z),
	case 'cell', if length(Z) == 1, Z = Z{1}; end;
	case {'uint32', 'uint16', 'uint8', 'int16'}, Z = double(Z);
	otherwise, Z = Z;
end
if all(isnan(Z)), warning('Possible the desired field is not a member of the structures.'); end;

catch,
	error(lasterr);
end