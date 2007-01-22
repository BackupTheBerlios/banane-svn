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



function kwstruct=kwextract(kwpresent,varargin);

  [st,i] = dbstack; % function call stack for error messages
  
  % small syntax check, if number of keywords plus values is odd,
  % assignment of value to keyword must fail
  % first, check arguments passed to the function
  if mod(length(kwpresent),2)==1 
    error(['Odd number of keywords and values in call to "' st(i+1).file ...
           '".']); 
  end

  ndefaults=length(varargin);
  
  % next, check arguments passed to kwextract (defaults)
  if mod(ndefaults,2)==1 
    error('Odd number of keywords and default values.'); 
  end
  
  % extract the field names and default values from varargin this relys
  % on the arguments being passed in alternating style:
  % 'keyword1',value1,'keyword2',value2 etc. 
  
  defaultfields=varargin(1:2:ndefaults);

  % check whether default field names are all strings
  for d=1:length(defaultfields)
    if not(ischar(defaultfields{d}))
     error('Default field names must be passed as strings.'); 
    end
  end
  
  duplicates=zeros(1,length(defaultfields));
  defaultvalues=varargin(2:2:ndefaults);
  
  % generate structure with default fields and the corresponding values
  kwstruct=cell2struct(defaultvalues,defaultfields,2);

  % search for the keywords that are actually present in the function call
  for k = 1:2:length(kwpresent)
    if ischar(kwpresent{k})
      now = strmatch(kwpresent{k}, strvcat(defaultfields));
      if now
        if duplicates(now)==0
          kwstruct.(defaultfields{now})=kwpresent{k+1};
          duplicates(now)=1;
        else
          error(['Keyword "%s" occurrs more than once in call to "' ...
                 st(i+1).file '".'], kwpresent{k});
        end
      else
        error(['Keyword "%s" not allowed in call to "' st(i+1).file '".'], ...
              kwpresent{k}); 
      end
    else
      error(['Keywords have to passed as strings in call to "' st(i+1).file ...
             '".']); 
    end
  end
  