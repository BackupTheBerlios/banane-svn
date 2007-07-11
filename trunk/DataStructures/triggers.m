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
%  defines how to determine the trigger signals for the respcetive
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
%               '070704-02'|'070704-05' Compute triggers by combining
%               the timestamps recorded on the analog channels 1 and
%               2. This method is suitable for triggers provided by the
%               standalone light stimulus generator. <BR>
%               '070704-04','051123-02','051123-10','051123-14' Compute
%               triggers by choosing either the 
%               timestamps recorded on the analog channels 3 or 4. The
%               channel with the larger first trigger interval is
%               chosen. This method is suitable for triggers provided by the
%               mirror control system.
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
   
   case {'070704-02','070704-05'}
    raw=[nev.ExpData.analog(1).timestamps ...
         nev.ExpData.analog(2).timestamps];
    trigstamps=sort(raw);
   
   case {'070704-04','051123-02','051123-10','051123-13','051123-14'}
    % Extract the "right"
    % trigger channel, which is characterized by an interval
    % between first and second trigger of nearly 500ms, instead of about
    % 250ms.
    trig1=nev.ExpData.analog(3).timestamps;
    trig2=nev.ExpData.analog(4).timestamps;

    nsweeps1=length(trig1);
    nsweeps2=length(trig2);
    
    if nsweeps1 ~= nsweeps2 
      error('Unequal number of trigger signals in both channels.')
    end

    dt1=trig1(2)-trig1(1);
    dt2=trig2(2)-trig2(1);

    [v,righttrig]=max([dt1,dt2]);

    raw=([trig1;trig2]);
    trigstamps=raw(righttrig,:);

   otherwise
      error('Unknown experiment.')
  end % switch
      
  trigstamps=double(trigstamps);
      
end
