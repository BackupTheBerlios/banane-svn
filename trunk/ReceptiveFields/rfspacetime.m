%+
% NAME:
%  rfspacetime()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  5/2007
%
% AIM:
%  Compute spatiotemporal receptive fields for multiple prototypes.
%
% DESCRIPTION:
%  rfspacetime computes the spatiotemporal receptive fields for multiple
%  prototypes recorded. Receptive fields have to be scanned using a
%  single dot stimulus according to the RF cinematogram technique. For
%  each prototype, the spatial coordinates of the dot stimulus preceeding each
%  spike are averaged, resulting in a three dimensional array
%  representing the average stimulus as a function of time prior to the
%  spike, and as a function of spatial position.
%
% CATEGORY:
%   Receptive Fields
%
% SYNTAX:
%* rfstruct=rfspacetime(positions,spikes
%*                      [,'avtime',value]
%*                      [,'dx',value][,'dy',value])
%
% INPUTS:
%  positions:: Mirror coordinates of the RF scanning stimulus. This has
%              to be given in longword integer notation as used by the
%              stimulus program controlling the mirror positions.
%  spikes:: Corresponding spike timestamps, contained in a structure
%           variable returned by <A>nev2sweeps</A>. Spiketrains in different
%           sweeps are concatenated into one single spiketrain for each
%           neuron. 
%
% OPTIONAL INPUTS:
%  avtime:: Duration of the time window used for spike triggered
%           averaging, in units of milliseconds. Default: 250ms.
%  dx,dy:: Minimum step size of the scanning mirrors, in units of mm on
%          the retina. Default: dx=1.7182E-3mm, dy=1.4771E-3mm. This is
%          needed to convert the mirror coordinates into retinal
%          coordinates. The values depend on the setup.
%
% OUTPUTS:
%  rfstruct:: A MATLAB structure variable with the following tags:
%* rfstruct
%*    |---nproto: number of prototypes
%*    |---avtime: duration of the averaging time window, as specified by
%*                the <VAR>avtime</VAR> keyword.  
%*    |---xyextent: Array with two elements giving the number of pixels
%*                  in horizontal and vertical direction that have been
%*                  used to scan the RFs.
%*    |---mmxnz: Horizontal scanning positions in units of mm on the
%*               retina.
%*    |---mmynz: Vertical scanning positions in units of mm on the
%*               retina.
%*    |---xmmperpos: Minimum horizontal separation of scanning pixels in
%*                   mm on the retina. 
%*    |---ymmperpos: Minimum vertical separation of scanning pixels in mm
%*                   on the retina.
%*    |---pr(p): prototype substructure
%*          |---eln: electrode number (same as in <VAR>spikes</VAR> structure).
%*          |---prn: prototype number (same as in <VAR>spikes</VAR> structure).
%*          |---spacetime: threedimensional array (t,x,y) containing the
%*                         spike triggered average stimulus.
%
% RESTRICTIONS:
%  At present, the routine is only working for the restricted type of
%  single dot stimuli moving quickly across the retina.
%
% PROCEDURE:
%  - Extract the positions of the mirrors that actually occurred
%    during the RF scan.<BR>
%  - For each prototype, concatenate the spikes from different
%    sweeps.<BR>
%  - Next, fill the average array step by step with the average stimulus
%    positions. 
%
% EXAMPLE:
%* posfile='/home/athiel/Experiments/ver051123/Stimuli/Movement/3-1.dat';
%* pos=load('-ascii', posfile);
%* sdata = loadNEV(['/home/athiel/Experiments/ver051123/Sorted/051123-13.nev']);
%* s=nev2sweeps(sdata,posfile);
%* rfst=rfspacetime(pos,s);
%
% SEE ALSO:
%  <A>nev2sweeps</A>, <A>rffitting</A>. 
%-


function rfstruct=rfspacetime(positions,spikes,varargin)
  
  %% factors for converting mirror coordinates into mm on the retina
  %% dx = 1.7182E-3 % mm on the retina
  %% dy = 1.4771E-3 % mm on the retina

  kw=kwextract(varargin,'avtime',250,'dx',1.7182E-3,'dy',1.4771E-3);
  
  rfstruct.nproto=spikes(1).nproto;
  rfstruct.avtime=kw.avtime;
  
  npos=length(positions)
  
  %% First, extract the positions of the mirrors that actually occurred
  %% during the RF scan
  maxpos=max(positions);
  minpos=min(positions);

  nedge=maxpos-minpos;

  xedges=minpos(2)+(0:nedge(2));

  xnonzero=find(histc(positions(:,2),xedges))+minpos(2)-1;

  pixpos=positions;
  
  for nonzidx=1:length(xnonzero)
    fi=find(positions(:,2) == xnonzero(nonzidx));
    pixpos(fi,2)=nonzidx;
  end

  yedges=minpos(1)+(0:nedge(1));
  ynonzero=find(histc(positions(:,1),yedges))+minpos(1)-1;

  for nonzidx=1:length(ynonzero)
    fi=find(positions(:,1) == ynonzero(nonzidx));
    pixpos(fi,1)=nonzidx;
  end

  rfstruct.xyextent=[length(xnonzero) length(ynonzero)];

  %% Convert the positions from integer values to millimeters on the
  %% retina
  rfstruct.mmxnz=kw.dx*(xnonzero-xnonzero(rfstruct.xyextent(1)/2));
  rfstruct.mmynz=kw.dy*(ynonzero-ynonzero(rfstruct.xyextent(2)/2));

  xdiff=(xnonzero-circshift(xnonzero,1));
  rfstruct.xmmperpos=kw.dx*mean(xdiff(2:end));
  ydiff=(ynonzero-circshift(ynonzero,1));
  rfstruct.ymmperpos=kw.dy*mean(ydiff(2:end));


  av=zeros(kw.avtime,rfstruct.xyextent(2),rfstruct.xyextent(1));

  spic=[rfstruct.xyextent(2) rfstruct.xyextent(1)];
  
  indarr=(1:spic(1)*spic(2))-1;


  disp(' ');
  disp('RFSpaceTime');
  disp('Processing prototypes.');

  for pidx=1:spikes(1).nproto
  
    %% simple output to show progress
    fprintf('.');
    if (mod(pidx,22)==0)
      fprintf(char(13));
    end
  
    %% concatenate the spikes from different sweeps
    for swidx=1:length(spikes)
    
      if (swidx > 1)
        catspikes=[catspikes ...
                   (swidx-1)*npos/length(spikes)+ ...
                   ceil(spikes(swidx).pr(pidx).ts*1000.)];
      else
        catspikes=[ceil(spikes(swidx).pr(pidx).ts*1000.)];
      end
      
    end % for swidx
    
    %% evaluate only spikes that occured after at least one averaging
    %% interval has passed
    catspikes=catspikes(catspikes>kw.avtime);

    nspikes=length(catspikes);
    
    %% go back in time relative to the spiketimes
    for backtime=1:kw.avtime
    
      timesnow=catspikes-backtime;
      
      %% all positions of stimulus at backtime before each spike
      xposall=pixpos(timesnow,2);
      yposall=pixpos(timesnow,1);      
    
      %% convert 2dim positions to 1dim
      flat=sub2ind(spic,yposall,xposall);
%      flat=sub2ind(spic,xposall,yposall);
      
      %% histogram of all positions
      addvect=histc(flat,indarr);

      %% convert back to 2dim
      add=reshape(addvect,spic);

      av(backtime,:,:)=add;
    
    end %% for
    
    rfstruct.pr(pidx).eln=spikes(1).pr(pidx).eln;
    rfstruct.pr(pidx).prn=spikes(1).pr(pidx).prn;    

%    disp(['spikes' num2str(spikes(1).pr(pidx).eln)])
%    disp(['rf' num2str(rfstruct.pr(pidx).eln)])
    
    if (nspikes == 0)
      rfstruct.pr(pidx).spacetime=av;
    else
      rfstruct.pr(pidx).spacetime=av/nspikes;
    end
    
  end %% for pidx
  
  fprintf('\nFinished.\n');
  
  end
  