%+
% NAME:
%  seconds2string()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  6/2007
%
% AIM:
%  Compute hours, minutes and seconds from the number of seconds.
%
% DESCRIPTION:
%  seconds2string() computes hours, minutes and seconds from the number
%  of seconds and returns the result as a string.
%
% CATEGORY:
%  Support Routines<BR>
%  Strings
%
% SYNTAX:
%* timestr = seconds2string(sec); 
%
% INPUTS:
%  sec:: The number of seconds to be converted.
%
% OUTPUTS:
%  timestr:: A string giving the number of hours, minutes and seconds.
%
% PROCEDURE:
%  Divisions and string concatenation.
%
% EXAMPLE:
%* >> seconds2string(1000)
%* ans =
%* 16m 40s
%*
%* >> seconds2string(5000)
%* ans =
%* 1h 23m 20s
%
%-


function timestr=seconds2string(sec)

   timestr = '';

   h = fix(sec/3600); 
   m = fix((sec - h*3600)/60);
   s = mod(sec,60);

   if (h~=0)
     timestr = [timestr ' ' num2str(h) 'h'];
   end 
   
   if (m~=0) || (h~=0)
     timestr = [timestr ' ' num2str(m) 'm'];
   end     
   
   timestr = [timestr ' ' num2str(s) 's'];
