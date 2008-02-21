%+
% NAME:
%  putpackets()
%
% VERSION:
%  $Id: putPackets.m 2008-01-22 13:47:22Z furche $
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  8/15/00
%
% AIM:
%  Update information in specified NEV file packets.
%
% DESCRIPTION:
%  putPackets.m updates information in specified NEV file SpikeData 
%  packets, which can either be a change of the classified
%  units, the recording electrode or in difference to the originally 
%  written routine also the timestamps or the whole waveforms.
%  The original function is part of the matlabNEVlib10a which is available 
%  on the web, and cannot be run without writeNEVfield.m.
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* [fieldData, index] = putPackets(nevObject, index, field, data);
%
% INPUTS:
%  nevObject:: NEV object for the current NEV file
%		index:: list of indices for the packets to put information into
%		field:: string containing the name of the information field to 
%               return. Valid fields are: electrode, unit
%		data:: data to place into the NEV file. If data is adressed to
%              'unit','timeStamp' or 'electrode', 'data' should be a 
%              row vector the same length as the index list or a single 
%              value. If a single value is given, it will be used for all 
%              indices.
%              In case the whole waveform of the packets shall be stored, 
%              the dimension of 'data' shall agree with (the number of 
%              packets to change) x (number of sampling points used to 
%              present each waveform) (can be obtained by w=getPackets
%              (nevObject, 2,'waveform', length(w));
%
% OPTIONAL INPUTS:
%  --
%
% OUTPUTS:
%  fieldData:: information written to the NEV file
%		index:: returns the indices of the packets. Useful in case indices 
%               are outside of valid ranges
%
% RESTRICTIONS:
%  Saving waveforms with 2 bytes per sample hasn´t been tried yet
%  due to missing data, so errors may be included.
%
% PROCEDURE:
%  This function just calls writeNEVfield, which shall be analysed to
%  understand the procedure.
%
% EXAMPLE:
%  Reassign packets 1 to 10 to unit 1:
%  * A = putPackets(nev, [1:10], 'unit', 1);
%  Change waveforms of the 3rd and 7th packet to a linear line and a
%  random waveform respectively:
%  * A = putPackets(nev, [3 7], ‘waveform’,[1:60; 40*rand(1,60)])
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  getPackets.m, <A>writeNEVfield</A>
%

function [fieldData, index] = putPackets(nevObject, index, field, data);

if any(index > nevObject.FileInfo.packetCount)
	error('Attempt to write to indicies beyond the end of the NEV file.');
end

w=getPackets(nevObject, 2, 'waveform');


[m,n]=size(data)
switch field
    case{'electrode','unit','timeStamp'}
        if m>1 | (n~=length(index) & n~=1)
            error('Only row-vectors with the same length as the index vector or length equal to 1 allowed.')
        end
        writeNEVfield(nevObject, index, field, data);
    case{'waveform'}
        if (n~=length(w)) | m~=length(index)
            error('Only whole waveforms of length %d can be changed, each row in the data matrix corresponds to one waveforms packet.',w)
        end
        writeNEVfield(nevObject, index, field, data);
    otherwise
        error('Only the fields ''electrode'',''timeStamp'', ''waveform'' and ''unit'' can be changed in the original NEV file.');
end

