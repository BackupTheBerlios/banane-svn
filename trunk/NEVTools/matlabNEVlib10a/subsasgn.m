%+
% NAME:
%  subsasgn()
%
% VERSION:
%  $Id: subsasgn.m 10/3/00  version 1.2 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  10/3/00 
%
% AIM:
%  Overloaded assignment to NEV objects.
%
%
% DESCRIPTION:
% Overloaded assignment to NEV objects. This is a MATLAB support function.
% Assignments must be made to terminal (singular) elements of the nev structure - 
% assignments to structures or cells are not permitted.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* A = subsasgn(A, S, B);
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
%  <A>searchNEV</A>, Specification for the NEV file formats NEVspc20.pdf
%
%
function A = subsasgn(A, S, B);

CRLF = strcat(char(13), '-->');
% Assignment to the base elements of the class
if length(S) == 1,
	eval(['A.' S(1).subs ' = B;']);
	return;
end

try,
% Process the first access
switch S(1).subs,
	case 'FileInfo',
		% nev.HeaderExtended.field(range) = value;
		if isempty(B), error('Information cannot be deleted from the ''FileInfo'' field.'); end;
		if S(2).type ~= '.', error(['Terminal assignment to ' S(1).subs ' required.' CRLF 'Use: nevObject.' S(1).subs '.FIELD([range]) = value(s).']); end;
		if isfield(A.FileInfo, S(2).subs), A.FileInfo = subsasgn(A.FileInfo, S(2:end), B); end;
	case 'HeaderBasic',
		% nev.HeaderBasic.field(range) = value;
		if isempty(B), error('Information cannot be deleted from the ''HeaderBasic'' field.'); end;
		if S(2).type ~= '.', error(['Terminal assignment to ' S(1).subs ' required.' CRLF 'Use: nevObject.' S(1).subs '.FIELD([range]) = value(s).']); end;
		if isfield(A.HeaderBasic, S(2).subs), A.HeaderBasic = subsasgn(A.HeaderBasic, S(2:end), B); end;
	case 'HeaderExtended',
		% nev.HeaderExtended.field(range) = value_list
		if isempty(B), error('Information cannot be deleted from the ''HeaderExtended'' field.'); end;
		if S(2).type ~= '.', error(['Terminal assignment to ' S(1).subs ' required.' CRLF 'Use: nevObject.' S(1).subs '.FIELD([range]) = value(s).']); end;
		if length(S) == 3, range = S(3).subs{:}; else, range = 1 : length(A.HeaderExtended); end;
		if length(B) == 1, B = B .* ones(size(range)); end;
		if length(B) ~= length(range), error('Assignment to channel info must be a scalar or list of numbers with same number of elements.'); end;
		for i = 1 : length(range),
			if isfield(A.HeaderExtended{range(i)}, S(2).subs), A.HeaderExtended{range(i)} = setfield(A.HeaderExtended{range(i)}, S(2).subs, B(i)); end;
		end
	case 'SpikeData',
		% nev.SpikeData.field(range) = value_list
		if isempty(A.SpikeData), error('SpikeData is empty - nothing to modify.'); end;
		if isempty(B) & (length(S) == 2) & (strcmp(S(2).type, '()')),
		% delete packets
			disp('Deleting spike packets.');
			J = setdiff((1:length(A.SpikeData.index)), S(2).subs{:});
			K = [];
			K.index = A.SpikeData.index(J);
			K.timeStamp = A.SpikeData.timeStamp(J);
			K.electrode = A.SpikeData.electrode(J);
			K.unit = A.SpikeData.unit(J);
			A.SpikeData = K;
		else,
			if S(2).type ~= '.', error(['Terminal assignment to ' S(1).subs ' required.' CRLF 'Use: nevObject.' S(1).subs '.FIELD([range]) = value(s).']); end;
			if isempty(B), error('Cannot delete parts of spike packets.'); end;
			A.SpikeData = subsasgn(A.SpikeData, S(2:end), B);
		end
	case 'StimulusData',
		% nev.SpikeData.field(range) = value_list
		if isempty(A.StimulusData), error('StimulusData is empty - nothing to modify.'); end;
		if isempty(B) & (length(S) == 2) & (strcmp(S(2).type, '()')),
		% delete packets
			disp('Deleting stimulus packets.');
			J = setdiff((1:length(A.StimulusData.index)), S(2).subs{:});
			K = [];
			K.index = A.StimulusData.index(J);
			K.timeStamp = A.StimulusData.timeStamp(J);
			K.trigger = A.StimulusData.trigger(J);
			K.dio = A.StimulusData.dio(J);
			K.analog = A.StimulusData.analog(J,:);
			A.StimulusData = K;
		else,
			if S(2).type ~= '.', error(['Terminal assignment to ' S(1).subs ' required.' CRLF 'Use: nevObject.' S(1).subs '.FIELD([range]) = value(s).']); end;
			if isempty(B), error('Cannot delete parts of stimulus packets.'); end;
			A.StimulusData = subsasgn(A.StimulusData, S(2:end), B);
		end
end

catch,
	error(lasterr);
end