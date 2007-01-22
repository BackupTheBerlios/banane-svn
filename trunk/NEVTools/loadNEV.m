%+
% NAME:
%  loadNEV()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  A. Branner
%
% DATE CREATED:
%  9/2002
%
% AIM:
%  Testchange1. Read all important information from a NEV file.
%
% DESCRIPTION:
%  loadNEV opens a Neural Event (NEV) file and extracts all information
%  from this file into a MATLAB structure array. Particular channels can
%  be selected. In addition, waveforms and non-neural experiment
%  information can be loaded in. A detailed documentation can be found in
%  the file cyberkinetics_docu.pdf, which is located in the same
%  directory.<BR>
%  The routine was originally written by A. Branner, Copyright (c) 9/2002
%  by Bionic Technologies, LLC. All Rights Reserved. The version included
%  in the Banane repository is slightly modified from the original: we
%  corrected a typo in a structure tag that otherwise caused the routine
%  to stop. 
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* nevObject = loadNEV(filename[, channellist][, units][, detail]); 
%
% INPUTS:
%  filename:: String containing the name and possibly the path for the
%             file to be read.
%
% OPTIONAL INPUTS:
%  channellist:: Array of channels to be imported.
%  units:: Pass string 'no' to only load classified units.
%  detail:: Pass string 'all' to load all waveforms and stimulus
%  info. Pass string 'wav' to load all waveforms. Pass string 'exp' to
%  load all stimulus info. 
%
% OUTPUTS:
%  nevObject:: A structure array with various tags that contain the
%  information within the NEV file. Most notably: <BR>
%   nevObject.<BR>
%       |-.HeaderBasic<BR>
%             |-.timeResolution - time resolution of time stamps<BR>
%             |-.sampleResolution - time resolution of waveform samples<BR>
%       |-.SpikeData - matrix with all channels/units selected<BR>
%             |-.timestamps - timestamps on the particular channel and unit<BR>
%  There are many more tags, which are describe in detail in
%  cyberkinetics_docu.pdf.
%
% RESTRICTIONS:
%  None known so far.
%
% PROCEDURE:
%  Since this is an adopted routine, its working is not exactly known.
%
% EXAMPLE:
%  Read data of channels 14,15 ,and 19 in the file
%  '051123-02.nev'. Include wavform information.
%* data=loadNEV('/pfad/zum/datenverzeichnis/051123-02.nev',[14,15,19],'all');
%  
%  Display waveform of 105th event on channel 15:
%* plot(data.SpikeData(15).waveforms(:,105))
%
% SEE ALSO:
%  cyberkinetics_docu.pdf
%-


function nevVariable = loadNEV(filename, varargin);

  originalDirectory = cd;

nounclass = 1;
wav = 0;
exp = 0;
channellist = [1:255];
try, if isempty(varargin), channellist = [1:255]; end; catch, channellist = [1:255]; end;

for i = 1 : length(varargin),
    switch class(varargin{i}),
    case 'char',
        if (length(varargin{i}) == 2) & (varargin{i} == 'no')
            nounclass = 2;
        elseif (length(varargin{i}) == 3) & (varargin{i} == 'all')
            wav = 1;
            exp = 1; 
        elseif (length(varargin{i}) == 3) & (varargin{i} == 'wav')
            wav = 1; 
        elseif (length(varargin{i}) == 3) & (varargin{i} == 'exp')
            exp = 1; 
        end
    case 'double',
        channellist = varargin{i};
    otherwise, 
        errordlg('Incorrect input to function.');
        return;
    end
end
clear varargin;

disp(' ');
disp('Please wait....');

fid = fopen(filename, 'r+', 'ieee-le');
if fid == -1, 
    error(['Unable to locate file ' filename]);
    return;
end;

nevVariable = struct('FileInfo', [], 'HeaderBasic', [], 'HeaderExtended', [], 'GeneralInfo', [], ...
    'SpikeData', [], 'ExpData', []);
nevVariable.FileInfo = struct('source', [], 'packetCount', [], 'bytesPerWaveformSample', []);
nevVariable.HeaderBasic = struct('fileTypeID', [], 'fileSpec', [], 'formatAddtl', [], 'dataOffset', [], ...
    'packetLength', [], 'timeResolution', [], 'sampleResolution', [], 'timeOrigin', [], 'application', [], ...
    'comment', [], 'headerCount', []);

[p, n, e] = fileparts(fopen(fid));
if ~isempty(p), cd(p); end;
nevVariable.FileInfo.source = which([n e]);
cd(originalDirectory)
clear p n e;

% Read the basic header information 
fseek(fid, 0, 'bof');
nevVariable.HeaderBasic.fileTypeID = char(fread(fid, 8, 'char')');
nevVariable.HeaderBasic.fileSpec = fread(fid, 1, 'uchar') + fread(fid, 1, 'uchar')/10.0;
if nevVariable.HeaderBasic.fileSpec < 2.0, 
    errordlg('Attempting to open a non-2.0 compliant NEV file.');
    return;
end;
nevVariable.HeaderBasic.formatAddtl = uint16(fread(fid, 1, 'uint16'));
nevVariable.HeaderBasic.dataOffset = fread(fid, 1, 'uint32');
nevVariable.HeaderBasic.packetLength = fread(fid, 1, 'uint32');
nevVariable.HeaderBasic.timeResolution = uint32(fread(fid, 1, 'uint32'));
nevVariable.HeaderBasic.sampleResolution = uint32(fread(fid, 1, 'uint32'));
nevVariable.HeaderBasic.timeOrigin = uint16(fread(fid, 8, 'uint16'));
nevVariable.HeaderBasic.application = deblank(char(fread(fid, 32, 'uchar')'));
nevVariable.HeaderBasic.comment = deblank(char(fread(fid, 256, 'char')'));
nevVariable.HeaderBasic.headerCount = uint32(fread(fid, 1, 'uint32'));

fseek(fid, 0, 'eof');
nevVariable.FileInfo.packetCount = (ftell(fid) - nevVariable.HeaderBasic.dataOffset) / ...
    nevVariable.HeaderBasic.packetLength;

% Read the extended header information 
fseek(fid, 332, 'bof');
headerCount = fread(fid, 1, 'uint32');
headers = {};
for i = 1 : headerCount,
    nextHeader = ftell(fid) + 32;
    temp = char(fread(fid, 8, 'char')');
    switch temp,
    case 'NEUEVWAV',    % Standard neural event waveform
        temp = uint16(fread(fid, 1, 'uint16'));  % Loading the electrode number
        if ~isempty(find(channellist == temp)),  % Only keep the headers for channels that were selected
            headers{end+1, 1}.electrode = temp;
            headers{end}.module = uint8(fread(fid, 1, 'uchar'));
            headers{end}.pin = uint8(fread(fid, 1, 'uchar'));
            headers{end}.scale = uint16(fread(fid, 1, 'uint16'));
            headers{end}.energy = uint16(fread(fid, 1, 'uint16'));
            headers{end}.amplitudeHi = int16(fread(fid, 1, 'int16'));
            headers{end}.amplitudeLo = int16(fread(fid, 1, 'int16'));
            headers{end}.unitCount = uint8(fread(fid, 1, 'uchar'));
            headers{end}.bytesPerSample = uint8(fread(fid, 1, 'uchar'));
            if headers{end}.bytesPerSample == 2, 
                headers{end}.bytesPerSample = 2;
            else
                headers{end}.bytesPerSample = 1;
            end;
        end;
    case 'NSASEXEV',    % Configuration of NSAS experiment information channels
        headers{end+1, 1}.periodicFreq = uint16(fread(fid, 1, 'uint16'));
        headers{end}.DIOConfig = uint8(fread(fid, 1, 'uchar'));
        headers{end}.Analog1Config = uint8(fread(fid, 1, 'uchar'));
        headers{end}.Analog1Threshold = int16(fread(fid, 1, 'int16'));
        headers{end}.Analog2Config = uint8(fread(fid, 1, 'uchar'));
        headers{end}.Analog2Threshold = int16(fread(fid, 1, 'int16'));
        headers{end}.Analog3Config = uint8(fread(fid, 1, 'uchar'));
        headers{end}.Analog3Threshold = int16(fread(fid, 1, 'int16'));
        headers{end}.Analog4Config = uint8(fread(fid, 1, 'uchar'));
        headers{end}.Analog4Threshold = int16(fread(fid, 1, 'int16'));
        headers{end}.Analog5Config = uint8(fread(fid, 1, 'uchar'));
        headers{end}.Analog5Threshold = int16(fread(fid, 1, 'int16'));
    otherwise,
        error('Unrecognized channel information.');
    end
    fseek(fid, nextHeader, 'bof');
end
nevVariable.HeaderExtended = headers;
clear headers headerCount temp;

if (wav == 1) & (nevVariable.FileInfo.packetCount > 1000000),
    disp('Large number of waveforms. System might run out of memory!');
    %   return;
end

Z = [];
% Check whether the file has 8 bit (bitrate=1) or 16 bit (2) waveforms or mixed ones (3).
for i = 1:size(nevVariable.HeaderExtended, 1)
    try
        if ~isempty(find(channellist == nevVariable.HeaderExtended{i}.electrode)),
            try, Z = [Z nevVariable.HeaderExtended{i}.bytesPerSample]; end;
        end
    end
end
nevVariable.FileInfo.bytesPerWaveformSample = mean(Z(~isnan(double(Z))));
if nevVariable.FileInfo.bytesPerWaveformSample == 1,
    bitrate = 1;
elseif nevVariable.FileInfo.bytesPerWaveformSample == 2,
    bitrate = 2;
else
    bitrate = 3;
end

if (nargout == 0),
    assignin('caller', 'nevfile', nevVariable);
end
clear Z;

% Initialization
nevVariable.GeneralInfo = struct('timestamps', [], 'packetNumbers', [], 'packetOrder', [], ...
    'unitOrder', [], 'NumberSpikes', [], 'ActiveChannels', []);

% Collect info on all packets
% Note: Data is converted to integers to save memory but has to be converted to double for certain 
%       analysis or plotting commands
fseek(fid, nevVariable.HeaderBasic.dataOffset, 'bof');
nevVariable.GeneralInfo.timestamps = uint32(fread(fid, nevVariable.FileInfo.packetCount, 'uint32', ...
    nevVariable.HeaderBasic.packetLength - 4));

nevVariable.GeneralInfo.packetNumbers = (1:nevVariable.FileInfo.packetCount)';
fseek(fid, nevVariable.HeaderBasic.dataOffset, 'bof');
fread(fid, 1, 'uint32');
nevVariable.GeneralInfo.packetOrder = uint8(fread(fid, nevVariable.FileInfo.packetCount, 'uint16', ...
    nevVariable.HeaderBasic.packetLength - 2));

fseek(fid, nevVariable.HeaderBasic.dataOffset, 'bof');
fread(fid, 3, 'uint16');
nevVariable.GeneralInfo.unitOrder = uint8(fread(fid, nevVariable.FileInfo.packetCount, 'uint8', ...
    nevVariable.HeaderBasic.packetLength - 1));

disp('...............');

% Get rid of noise, unclassified units and unselected channels
if nounclass == 2, 
    temp = find((nevVariable.GeneralInfo.unitOrder == 0) | (nevVariable.GeneralInfo.unitOrder == 255));
    ind1 = temp(find(nevVariable.GeneralInfo.PacketOrder(temp) ~= 0));
    clear temp;
else
    ind1 = find(nevVariable.GeneralInfo.unitOrder == 255);
end
nevVariable.GeneralInfo.unitOrder(ind1) = [];
nevVariable.GeneralInfo.timestamps(ind1) = [];
nevVariable.GeneralInfo.packetNumbers(ind1) = [];
nevVariable.GeneralInfo.packetOrder(ind1) = [];
clear ind1;

% Search for all channels that will not be loaded and get rid of them
str1 = repmat('& ', length(channellist) + 1, 1);
str1(1) = ' ';
str2 = [str1 repmat('nevVariable.GeneralInfo.packetOrder ~= ', length(channellist) + 1, 1) num2str([0 channellist]')...
        repmat(' ', length(channellist) + 1, 1)]';
str3 = str2(1 : (size(str2, 1) * size(str2, 2)));
clear str1 str2;
ind1 = find(eval(str3));
nevVariable.GeneralInfo.unitOrder(ind1) = [];
nevVariable.GeneralInfo.timestamps(ind1) = [];
nevVariable.GeneralInfo.packetNumbers(ind1) = [];
nevVariable.GeneralInfo.packetOrder(ind1) = [];
clear ind1 str3;

% Load in waveform and stimulus information if requested (first version - everything is read in and then sorted)
% Only used for smaller files

% Include this and the elseif below to have it chose between two different search mechanisms
% maxnumpack = 10000000;
% if (wav == 1) & (nevVariable.FileInfo.packetCount < maxnumpack),

if wav == 1,
    
    % Preallocate memory
    ind1 = cell(double(max(nevVariable.GeneralInfo.packetOrder)), 1);
    ind2 = cell(double(max(nevVariable.GeneralInfo.packetOrder)), 16);
    nevVariable.GeneralInfo.NumberSpikes = zeros(1, 255);
    
    % Determine active channels and number of spikes on each
    % Loop is running backwards to speed up the filling of the structures
    for i = fliplr(channellist)
        ind1 = find(nevVariable.GeneralInfo.packetOrder == i);
        nevVariable.GeneralInfo.NumberSpikes(i) = length(ind1);
        if ~isempty(ind1)
            for j = 16:-1:nounclass
                ind2{i,j} = ind1(find(nevVariable.GeneralInfo.unitOrder(ind1) == j-1));
                if ~isempty(ind2{i,j})
                    nevVariable.SpikeData(i,j).timestamps = nevVariable.GeneralInfo.timestamps(ind2{i,j})';
                end
            end
        end
    end
    disp('...............');
    
    nevVariable.GeneralInfo.ActiveChannels = find(nevVariable.GeneralInfo.NumberSpikes);
    len = nevVariable.HeaderBasic.packetLength - 8;
    if (bitrate == 1) | (bitrate == 2),
        blocksize = 25000;
    elseif bitrate == 3,
        blocksize = 12500;
    end;
    a = 1;
    b = blocksize;
        
    while a <= nevVariable.FileInfo.packetCount,
        if b > nevVariable.FileInfo.packetCount, b = nevVariable.FileInfo.packetCount; end
        % Load in waveforms
        fseek(fid, nevVariable.HeaderBasic.dataOffset + (a - 1) * nevVariable.HeaderBasic.packetLength, 'bof');
        fread(fid, 2, 'uint32');
        if bitrate == 1,
            data = int8(fread(fid, [len, blocksize], [num2str(len) '*int8'], 8));
        elseif bitrate == 2,
            data1 = int16(fread(fid, [len/2, blocksize], [num2str(len/2) '*int16'], 8));
        elseif bitrate == 3,
            data = int8(fread(fid, [len, blocksize], [num2str(len) '*int8'], 8));
            data1 = int16(fread(fid, [len/2, blocksize], [num2str(len/2) '*int16'], 8));
        end;
        
        % Use indeces determined earlier to only selected channels
        % Loop is running backwards to speed up the filling of the structures
        for i = fliplr(nevVariable.GeneralInfo.ActiveChannels)
            for j = 16:-1:nounclass
                if (~isempty(ind2{i,j})) & ...
                        (nevVariable.HeaderExtended{find(nevVariable.GeneralInfo.ActiveChannels == i)}.bytesPerSample == 1)
                    % Indeces have to be converted to appropriate places in original file
                    ind4 = nevVariable.GeneralInfo.packetNumbers(ind2{i,j});
                    ind3 = nevVariable.GeneralInfo.packetNumbers(ind2{i,j}(find((ind4 >= a) & (ind4 <= b)))) - a + 1;
                    if a == 1, nevVariable.SpikeData(i, j).waveforms = []; end
                    nevVariable.SpikeData(i, j).waveforms = [nevVariable.SpikeData(i, j).waveforms data(:, ind3)];
                elseif (~isempty(ind2{i,j})) & ...
                        (nevVariable.HeaderExtended{find(nevVariable.GeneralInfo.ActiveChannels == i)}.bytesPerSample == 2)
                    % Indeces have to be converted to appropriate places in original file
                    ind4 = nevVariable.GeneralInfo.packetNumbers(ind2{i,j});
                    ind3 = nevVariable.GeneralInfo.packetNumbers(ind2{i,j}(find((ind4 >= a) & (ind4 <= b)))) - a + 1;
                    if a == 1, nevVariable.SpikeData(i, j).waveforms = []; end
                    nevVariable.SpikeData(i, j).waveforms = [nevVariable.SpikeData(i, j).waveforms data1(:, ind3)];
                end
            end
        end
        a = a + blocksize;
        b = b + blocksize;
        clear data data1;
    end
    clear data data1 ind1 ind2 ind3 ind4 a b i j blocksize;
    
    % Load in waveform and stimulus information if requested (second version - only relevant channels/ units are loaded in)
    % Used for larger files
    % elseif (wav == 1) & (nevVariable.FileInfo.packetCount >= maxnumpack),
    %   % Preallocate memory
    %   nevVariable.GeneralInfo.NumberSpikes = zeros(1, 255);
    %    
    %   len = nevVariable.HeaderBasic.packetLength - 8;
    %   str = [num2str(len) '*schar'];
    %   % Determine active channels and number of spikes on each
    %   % Loop is running backwards to speed up the filling of the structures
    %    
    %   for i = double(max(nevVariable.GeneralInfo.packetOrder)):-1:1
    %      ind1 = find(nevVariable.GeneralInfo.packetOrder == i);
    %      nevVariable.GeneralInfo.NumberSpikes(i) = length(ind1);
    %      if ~isempty(ind1)
    %         for j = 16:-1:nounclass
    %            ind2 = ind1(find(nevVariable.GeneralInfo.unitOrder(ind1) == j-1));
    %            if ~isempty(ind2)
    %               nevVariable.SpikeData(i,j).timestamps = nevVariable.GeneralInfo.timestamps(ind2)';
    %               % Indeces have to be converted to appropriate places in original file
    %               ind3 = nevVariable.GeneralInfo.packetNumbers(ind2);
    %               wv = [];
    %               for a = 1:length(ind3),
    %                  fseek(fid, nevVariable.HeaderBasic.dataOffset + (ind3(a) - 1) * nevVariable.HeaderBasic.packetLength, 'bof');
    %                  fread(fid, 2, 'uint32');
    %                  data = int8(fread(fid, len, str));
    %                  wv = [wv data];
    %               end
    %               nevVariable.SpikeData(i, j).waveforms = wv;
    %               clear ind3 wv;
    %            end
    %         end
    %      end
    %   end
    %   nevVariable.GeneralInfo.ActiveChannels = find(nevVariable.GeneralInfo.NumberSpikes);
    %   clear data;
    
    %   clear data ind1 ind2 ind3 a i j str;
else
    % Determine active channels and number of spikes on each
    nevVariable.GeneralInfo.NumberSpikes = zeros(1, 255);
    
    disp('...............');
    for i = 1:double(max(nevVariable.GeneralInfo.packetOrder))
        ind1 = find(nevVariable.GeneralInfo.packetOrder == i);
        nevVariable.GeneralInfo.NumberSpikes(i) = length(ind1);
        if ~isempty(ind1)
            for j = 16:-1:nounclass
                ind2 = ind1(find(nevVariable.GeneralInfo.unitOrder(ind1) == j-1));
                if ~isempty(ind2)
                    nevVariable.SpikeData(i, j).timestamps = nevVariable.GeneralInfo.timestamps(ind2)';
                end
            end
        end
    end
    nevVariable.GeneralInfo.ActiveChannels = find(nevVariable.GeneralInfo.NumberSpikes);
end

% Extract non-neural experiment info
ind1 = find(nevVariable.GeneralInfo.packetOrder == 0);
nevVariable.ExpData.timestamps = nevVariable.GeneralInfo.timestamps(ind1)';
nevVariable.ExpData.flags = nevVariable.GeneralInfo.unitOrder(ind1)';
ind1 = nevVariable.GeneralInfo.packetNumbers(ind1);

if exp == 1,
    % stimuli
    fseek(fid, nevVariable.HeaderBasic.dataOffset, 'bof');
    fread(fid, 2, 'uint32');
    data1 = int16(fread(fid, [6, nevVariable.FileInfo.packetCount], '6*int16', nevVariable.HeaderBasic.packetLength - 12));   
    nevVariable.ExpData.digital = data1(1, ind1);
    nevVariable.ExpData.analog1 = data1(2, ind1);
    nevVariable.ExpData.analog2 = data1(3, ind1);
    nevVariable.ExpData.analog3 = data1(4, ind1);
    nevVariable.ExpData.analog4 = data1(5, ind1);
    nevVariable.ExpData.analog5 = data1(6, ind1);
end
clear data1 ind1;

fclose(fid);

disp('...........done');

% Set file information global
disp(' ');
disp(char(['Filename:    ' nevVariable.FileInfo.source], ['Packet count:    ' num2str(nevVariable.FileInfo.packetCount)], ...
    ['Number of active channels:    ' num2str(length(find(nevVariable.GeneralInfo.ActiveChannels)))]));
