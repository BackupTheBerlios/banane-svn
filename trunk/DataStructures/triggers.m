%+
% NAME:
%  triggers()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  7/2007
%
% AIM:
%  Extract the trigger timestamps from a NEV data structure.
%
% DESCRIPTION:
%  Since each experiment defines and uses trigger signals differently, the
%  triggers() function is meant to provide a common basis that extracts
%  the trigger signals from a NEV structure according to the special
%  needs of the respective experiment. triggers() needs an input string that
%  defines how to determine the trigger signals for the respective
%  experiment. The routine needs to be extended if new experiments
%  require different trigger evaluations. 
%
% CATEGORY:
%  DataStructures
%
% SYNTAX:
%* tr = triggers(nev, experiment); 
%
% INPUTS:
%  nev:: The matlab structure containing the experimental data,
%                as returned by the <A>loadNEV</A> routine.
%  experiment:: String variable defining the type of trigger extraction
%               that has to be carried out. Presently, the following
%               options exist: <BR>
%               '070704-02'|'070704-05'|'lsg'<BR> 
%               Compute triggers by combining
%               the timestamps recorded on the analog channels 1 and
%               2. This method is suitable for triggers provided by the
%               standalone light stimulus generator. <BR>
%               '070704-04'|'051123-02'|'051123-10'|'051123-13'
%               |'051123-14'|'mirror'<BR>
%               Compute
%               triggers by choosing either the 
%               timestamps recorded on the analog channel 3 or 4. The
%               channel with the larger first trigger interval is
%               chosen. This method is suitable for triggers provided by the
%               mirror control system.
%               '070716-15'<BR>
%               Returns only triggers for the first 6 sweeps of this
%               particular experiment, since afterwards the acquisition
%               computer crashed.<BR>
%               See also comments in the source code for more
%               possibilities.
%
% OUTPUTS:
%  tr:: Double precision numerical vector of trigger timestamps in units
%       of samples. 
%
% PROCEDURE:
%  Simple switch/case-statements.
%
% EXAMPLE:
%* >> tr=triggers(nevdata,'070704-05');
%
% SEE ALSO:
%  <A>loadNEV</A>, <A>nev2sweeps</A>. 
%-

function trigstamps=triggers(nev,experiment) 
  
  switch experiment
   %% return only triggers of the first 6 sweeps, since afterwards the
   %% acquistion computer crashed.
   case {'070716-15'}
    raw=[nev.ExpData.analog(1).timestamps ...
         nev.ExpData.analog(2).timestamps];
    trigstamps=sort(raw);
    trigstamps=trigstamps(1:4572);
   
   %% just append the missing trigger
   case {'070716-16'}
    raw=[nev.ExpData.analog(1).timestamps ...
         nev.ExpData.analog(2).timestamps];
    trigstamps=sort(raw);
    trigstamps(end+1)=trigstamps(end)+15000;
   
   %% light stimulus generator
   case {'lsg','070704-02','070704-05'}
    raw=[nev.ExpData.analog(1).timestamps ...
         nev.ExpData.analog(2).timestamps];
    trigstamps=sort(raw);
   
   %% use mirror triggers but remove the last one of each sweep (the
   %% 763rd in this case), since this just marks the end of the
   %% stimulation.
   case {'070716-05'}

    trigstamps=chooseright(nev);
    
    removeidx=(1:10)*763;
    remainidx=setdiff((1:length(trigstamps)),removeidx);
    
    trigstamps=trigstamps(remainidx);

   %% use mirror triggers but keep all triggers, suitable for example for
   %% RF cine stimulation
   case {'mirror','070704-04','051123-02','051123-10','051123-13','051123-14'}

    trigstamps=chooseright(nev);

   otherwise
      error('Unknown experiment or condition.')
  
  end % switch
      
  trigstamps=double(trigstamps);
      
end % triggers



% support function that can be used in all cases that extract mirror
% triggers from the two analog channels 3 and 4. 
% Extract the "right"
% trigger channel, which is characterized by an interval
% between first and second trigger of nearly 500ms (15000 samples),
% instead of about 250ms.

function ts=chooseright(nev)

  combtrig=[nev.ExpData.analog(3).timestamps; ...
            nev.ExpData.analog(4).timestamps];

  dt=combtrig(:,2)-combtrig(:,1);
    
  righttrig=find((dt>14900)&(dt<15100));
    
  if (isempty(righttrig))
    error(['None of the trigger channels has a correct first ' ...
           'interval.'])
  end % if
    
  ts=combtrig(righttrig,:);

end % chooseright

  

