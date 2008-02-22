%+
% NAME:
%  searchNEVbyTime()
%
% VERSION:
%  $Id: SearchNEVbyTime.m 2000-09-08 version 1.0 E. Maynard Copyright: 2000 Bionic Technologies, Inc.$
%
% AUTHOR:
%  E. Maynard 
%
% DATE CREATED:
%  08/09/00
%
% AIM:
%  This function can be used to quickly find the index in the NEV file corresponding to a
% particular time in seconds.
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
% nevObject: nev object created by openNEV
%	time: time in seconds
%
% OPTIONAL INPUTS:
%  	--
% 
%
% OUTPUTS:
%  if the returned value is a:
%		fractional value (e.g. 10.5): then the time falls between two packets
%		single integer: then the packet at index matches the time
%		list of values: then there are multiple packets that occured at that time
%		+inf: then time is greater than the maximum packet time
%		-inf: then time is less than the minimum packet time
%
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
%-

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
