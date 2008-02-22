%+
% NAME:
%  NEVPlotWaves()
%
% VERSION:
%  $Id: NEVPlotWaves.m 2000-09-30  version 1.2 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  30/09/00
%
% AIM:
%  Used to plot the waveforms present in a NEV file.
%
% DESCRIPTION:
% Used to plot the waveforms present in a NEV file. Each subplot is a different
% electrode.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* result = NEVPlotWaves(filename, Nwaves, varargin);
%* result = NEVPlotWaves(filename, numberWavforms[100], [BW], [display
% format]);
% 
%
% INPUTS:
%  filename:: string filename for the NEV file the use
%	numberWaveforms:: maximum number of waveforms to use for each unit on a channel
%	
%
% 
%
%
% OPTIONAL INPUTS:
%  BW:: pass in the string 'BW' to use black and white formatting
%	displayFormat:: a single value is the number of plots to use per page
%					an array [rows cols] uses the specified number of rows
%					and columns
%
% OUTPUTS:
%  --
%
%
%
% PROCEDURE:
%  Since this is an adopted routine, its working is not exactly known.
%
% EXAMPLE:
% --
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  Specification for the NEV file formats NEVspc20.pdf
%  
%-
function result = NEVPlotWaves(filename, Nwaves, varargin);


try, if isempty(Nwaves), Nwaves = 100; end; catch, Nwaves = 100; end;

display = [6 3];
colorMatrix = [.2 .2 .2; 0 0 1; 1 0 0; 0 1 0; 1 1 0; 0 1 1];
BWMatrix = [.9 .9 .9; 0 0 0; .7 .7 .7; .2 .2 .2; .5 .5 .5; .4 .4 .4];

for i = 1 : length(varargin),
	switch class(varargin{i}),
		case 'char', if varargin{i} == 'BW', colorMatrix = BWMatrix; end;
		case 'double',
			switch length(varargin{i}),
				case 1, display = [ceil(varargin{i}/4) 3];
				case 2, display = varargin{i};
				otherwise, display = varargin{i}(1:2);
			end
		otherwise, error('Incorrect input to function.');
	end
end

% Open the nev file and get the basic packet information
if ~isa(filename, 'nev'),
	nev = opennev(filename);
	nev.SpikeData = getNEVSpikes(nev, 300000);
else,
	nev = filename;
end
if isempty(nev.SpikeData), closeNEV(nev); return; end;
% Create the channel list
channelList = nev.HeaderExtended.electrode;
channelList = channelList(~isnan(channelList));
T = ['File: ' nev.FileInfo.source '   Packets Used: ' num2str(length(nev.SpikeData.index))];

% For each channel, plot the mean unit waveforms and label graph
for i = 1 : length(channelList),
% Create a new output page or set to current axis
	if mod(i-1, prod(display)) == 0,
		if i > 1, setfiguretitle(T); end;
		figure;
	end;
	subplot(display(1), display(2), mod(i-1, prod(display)) + 1);
% Get the waveforms for the electrode/unit pairs
	unitCount = [];
	set(gca, 'NextPlot', 'add');
	C = find(nev.SpikeData.electrode == channelList(i));
	for j = 0 : 5,
% Find the scanned packets that satisfy the electrode/unit pair
		Y = C(find(nev.SpikeData.unit(C) == j));
		if ~isempty(Y),
			unitCount(j+1) = length(Y);
			Y = Y(1:min([length(Y) Nwaves]));
			I = nev.SpikeData.index(Y);
% Get the waveforms from the returned packets
			waveforms = getPackets(nev, I, 'waveform');
% Plot the waveforms
			A = mean(waveforms);
			E = std(waveforms);
			H = errorbar(A, E);
			set(H, 'Color', colorMatrix(j+1,:));
		end
	end
	set(gca, 'NextPlot', 'replace');
	set(gca, 'FontSize', 6, 'XLim', [1 length(A)], 'YLim', [-128 128], 'Ytick', [-128 -90 -50 0 50 90 128]);
	title(sprintf('Channel: %d', channelList(i)));
	message = sprintf('[%d]', unitCount);
	text(2, 118, message, 'FontSize', 8);
	drawnow
end
setfiguretitle(T);

% Close up the open NEV file
if ~isa(filename, 'nev'), closeNEV(nev); end;
return;

function setfiguretitle(titlemsg)
	set(gcf, 'paperposition', [0.25 0.25 8 10], 'Name', 'NevPlotWaves Output');
	ax=axes('Units','Normal','Position',[.075 .075 .85 .88],'Visible','off');
	set(get(ax,'Title'),'Visible','on', 'FontSize', 10, 'FontWeight', 'bold');
	set(get(ax, 'title'), 'string', titlemsg, 'Interpreter', 'none');

