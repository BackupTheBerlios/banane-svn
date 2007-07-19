%+
% NAME:
%  rffitting()
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
%  Determine spatial receptive fields by fitting 2d gaussians.
%
% DESCRIPTION:
%  Determine spatial receptive fields by fitting 2d gaussians.
%
% CATEGORY:
%  Receptive fields
%
% SYNTAX:
%* rfstruct=rffitting(rfstruct [,'avspacerange',value][,'graphic',boolean]); 
%
% INPUTS:
%  rfstruct:: Structure variable containing information about
%  spatiotemporal receptive fields. This information is obtained by using
%  <A>rfspacetime</A>.
%
% OPTIONAL INPUTS:
%  avspacerange:: Range of averaging in space.
%  graphic:: Creates a window and displaying the results of the
%  computation for a single prototype. The routine waits for a keypress
%  before continuing to display results for the next prototype.
%
% OUTPUTS:
%  rfstruct:: The original structure variable with spatial receptive
%  field information added to it.
%
% RESTRICTIONS:
%  None at the moment?
%
% PROCEDURE:
%  Will add this later.
%
% EXAMPLE:
%  Indicate example lines with * as the first character. These lines
%  will be typeset in a fixed width font. 
%* data=example_function(23,5)
%  
%  Indicate matlab output with *>
%*> ans =
%*>   28
%
% SEE ALSO:
%  <A>rfspacetime</A>. 
%-



function rfstruct=rffitting(rfstruct,varargin)
  
  kw=kwextract(varargin,'avspacerange',2,'graphic',false);
  rfstruct.avspacerange=kw.avspacerange;

  disp('Processing prototypes.');

  for pidx=1:rfstruct.nproto

    if (not(kw.graphic))
      %% simple output to show progress
      fprintf('.');
      if (mod(pidx,22)==0)
        fprintf(char(13));
      end
    end
    
    
  mav=squeeze(max(rfstruct.pr(pidx).spacetime,[],1));
  sumav=squeeze(sum(rfstruct.pr(pidx).spacetime,1));
  

  [xmax,ix]=max(max(mav,[],1));
  [ymax,iy]=max(max(mav,[],2));
    
  tc=(rfstruct.pr(pidx).spacetime(:,iy,ix));
  
  meantc=mean(tc);
  stdtc=std(tc);

  [mtc,itc]=max(tc);
  
  
  % find the start and stop of the first peak
  tczero=find((tc-(meantc+stdtc))<=0);
  
  startidx=find((tczero-itc) < 0,1,'last');
  starttime=tczero(startidx)+1;
  if (startidx==length(tczero))
    stoptime=rfstruct.avtime;
  else
    stoptime=tczero(startidx+1)-1;
  end
  
  rf2=squeeze(sum(rfstruct.pr(pidx).spacetime(starttime:stoptime,:,:),1));
  rf=max(rf2-mean(rf2(:)),zeros(rfstruct.xyextent));
  
  
  if (nnz(rf)~=0)
    vstart=[ix iy max(rf(:)) 1.5 1.5];
    [v,fval] = fminsearch(@(v) fitgauss2d(v,rf),vstart,optimset('Display','off'));
  else
    v = [ones(1,5)];
    fval=Inf;
  end
  
  gs=v(3)*gauss2d(rfstruct.xyextent(1),rfstruct.xyextent(2),v(1),v(2),v(4),v(5));
  mask2sig=(gs>=v(3)*exp(-0.5*kw.avspacerange.^2));
  
  vmm=v;
  vmm(1)=rfstruct.xmmperpos*(v(1)-rfstruct.xyextent(1)/2);%mmynz(round(v(1)));
  vmm(2)=rfstruct.ymmperpos*(v(2)-rfstruct.xyextent(2)/2);%mmxnz(round(v(2)));
  vmm(4)=rfstruct.xmmperpos*v(4);
  vmm(5)=rfstruct.ymmperpos*v(5);

  [ymaskidx,xmaskidx]=find(mask2sig);
  
  tmpav=zeros(rfstruct.avtime,length(xmaskidx));
  
  for avidx=1:length(xmaskidx)
    tmpav(:,avidx)=rfstruct.pr(pidx).spacetime(:,ymaskidx(avidx),xmaskidx(avidx));
  end
  
  tcav=mean(tmpav,2);
  
  rfstruct.pr(pidx).fit=[vmm fval];
  rfstruct.pr(pidx).avspace=rf2;
  rfstruct.pr(pidx).avtime=tcav;

  if (kw.graphic)
  
    disp(['index: ' num2str(pidx)]);
    disp(['electrode: ' num2str(rfstruct.pr(pidx).eln)]);
    disp(['prototype: ' num2str(rfstruct.pr(pidx).prn)]);
    disp(' ');
    
    subplot(2,4,1), imagesc(rfstruct.mmxnz,rfstruct.mmynz,sumav);
    axis xy;
    xlabel('x / mm');
    ylabel(' y / mm');
    title('Sum of complete time interval');
    
    subplot(2,4,2), plot(tc);
    axis tight;
    xlabel('t / ms');
    ylabel('???');
    title('Time course at maximum position');
    hold on
    subplot(2,4,2), plot(xlim,[meantc meantc]);
    subplot(2,4,2), plot(xlim,[meantc+stdtc meantc+stdtc]);
    hold off

    subplot(2,4,3), imagesc(rfstruct.mmxnz,rfstruct.mmynz,rf)
    axis xy;
    xlabel('x / mm');
    ylabel(' y / mm');
    title('Sum of peak time interval');
    hold on
    emm=ellipse(25,vmm(1),vmm(2),2*vmm(4),2*vmm(5));
    plot(emm(1,:),emm(2,:),'w','LineWidth',2);
    plot(vmm(1),vmm(2),'wo','LineWidth',2);
    hold off

    subplot(2,4,4),plot(rfstruct.mmxnz,rf(round(v(2)),:))
    axis tight;
    xlabel('x / mm');
    ylabel('???');
    title('X Slice at maximum position');
    hold on
    subplot(2,4,4),plot(rfstruct.mmxnz,gs(round(v(2)),:),'r')
    hold off

    subplot(2,4,5),plot(rfstruct.mmynz,rf(:,round(v(1)))) % , imagesc(gs);
    axis tight;
    xlabel('y / mm');
    ylabel('???');
    title('Y Slice at maximum position');
    hold on
    subplot(2,4,5),plot(rfstruct.mmynz,gs(:,round(v(1))),'r')
    hold off
  
    subplot(2,4,6), imagesc(rfstruct.mmxnz,rfstruct.mmynz,mask2sig.*rf);
    axis xy;
    xlabel('x / mm');
    ylabel(' y / mm');

    subplot(2,4,7), plot(tcav);
    axis tight;
    xlabel('t / ms');
    pause
  end
  
 
  
  end %% for pidx
  
  end
  