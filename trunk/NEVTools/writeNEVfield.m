%+
% NAME:
%  writeNEVfield()
%
% VERSION:
%  $Id: writeNEVfield.m 2008-01-22 13:47:22Z furche $
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  8/15/00
%
% AIM:
%  Writes Data to a specified field of the NEV-file. Designed to be
%  called by putpackets.m
%
% DESCRIPTION:
% Reads the entire NEV file and returns the selected field. This function
% uses the byte positions for the data and does not check to see if the packet
% is a spike or stimulus. To return the information specific to a packet type,
% it is necessary to filter the result.
% In difference to the original version now also the fields 'waveforms' and
% 'timestamps' can be changed.
% The original function is part of the matlabNEVlib10a which is available 
% on the web, and cannot be run without putPackets.m.
%
%
% CATEGORY:
%  NEV Tools
%
% SYNTAX:
%* count = writeNEVfield(nevObject, indices, field, data); 
% (but not designed to be called alone)
%
% INPUTS:
%	fid:: file pointer to the open NEV file
%	field:: string containing the field to return
%	offsets:: starting positions of the packets to be read. If a single value then all packets read
%		starting at that point.
%	N:: number of packets to read (default = all)
%
% OPTIONAL INPUTS:
%  --
%
% OUTPUTS:
%  count:: selected field
%
% RESTRICTIONS:
%  Saving waveforms with 2 bytes per sample hasn´t been tried yet
%  due to missing data, errors may be included.
%
% PROCEDURE:
%  This function uses the byte positions for the data but does not check to see if the packet
%  is a spike or stimulus. For more information about byte positions in
%  Nev-files see specifications for the NEV file format.
%
% EXAMPLE:
%  Only to use while executing putPackets:
%  * writeNEVfield(nevObject, index, field, data);
%
% SEE ALSO:
%  matlabNEVlib10a, Readme.doc
%  <A>putpackets</A>, Specification for the NEV file formats
%






function count = writeNEVfield(nevObject, indices, field, data);

[m,n]=size(data)
fid = nevObject.FileInfo.fid;
offsets = ((indices-1) .* nevObject.HeaderBasic.packetLength) + nevObject.HeaderBasic.dataOffset;

switch field,
    case 'timeStamp'
        offsets = offsets;
	case 'electrode',
		offsets = offsets + 4;
	case 'unit',
		offsets = offsets + 6;
    case 'waveform'
        offsets = offsets + 8; 
	otherwise,
		error(['Field ''' field ''' not recognized.']);
end
if n == 1, data = ones(size(indices)) .* data; end;

H = waitbar(0, 'Writing fields to NEV file...');
for i = 1 : length(offsets),
	if mod(i, 100) == 0, waitbar(i/length(offsets)); end;
	fseek(fid, offsets(i)-ftell(fid), 'cof');
	switch field,
        case 'timeStamp'
            fwrite(fid, data(i), 'uint32');
		case 'electrode',
			fwrite(fid, data(i), 'uint16');
		case 'unit',
			fwrite(fid, data(i), 'uchar');
        case 'waveform'
            if nevObject.FileInfo.bytesPerWaveformSample<2
                data(i,:)=data(i,:)+(data(i,:)<0).*256; %transform negative values to integers bigger than 128
                fwrite(fid, data(i,:), 'char'); %write data as a char array
            else
                data(i,:)=data(i,:)+(data(i,:)<0).*65536; %transform negative values to integers bigger than (256^2)/2
                datawave=[];
                for j=1:n
                    x=mod(data(i,j),256); %modulus after divison
                    y=floor(data(i,j)/256); %data(i,j)=1*x+256*y
                    datawave=[datawave x y] %save data as 2 bytes per sample
                end
                fwrite(fid, datawave(i,:),'char') %write data as a char array
            end
	end
end
close(H);