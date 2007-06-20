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
%  Short description of the routine in a single line.
%
% DESCRIPTION:
%  Detailed description of the routine. The text may contain small HTML
%  tags like for example <BR> linebreaks or <VAR>variable name
%  typesetting</VAR>. Simple anchors to other banane routines are
%  also allowed, eg <A>kwextract</A>.
%
% CATEGORY:
%  At present, there are the following possibilities:<BR>
%   - DataStructures<BR>
%   - Documentation<BR>
%   - NEV Tools<BR>
%   - Support routines<BR>
%  Others may be invented, with corresponding subdirectories in the
%  BANANE directory tree. For example:<BR>
%   - Array<BR>
%   - DataStorage<BR>
%   - Demonstration<BR>
%   - Graphic<BR>
%   - Help<BR>
%   - Statistics<BR>
%   - Signals<BR>
%   - Simulation<BR>
%   - Strings<BR>
%
% SYNTAX:
%* result = example_function(arg1, arg2,[, optarg1][, optarg2]); 
%
% INPUTS:
%  arg1:: First argument of the function call. Indicate variable type and
%  function.
%  arg2:: Second argument of the function call.
%
% OPTIONAL INPUTS:
%  optarg1:: An optional input argument.
%  optarg2:: Another optional input argument.
%
% OUTPUTS:
%  result:: The result of the routine.
%
% RESTRICTIONS:
%  Optional section: Is there anything known that could cause problems?
%
% PROCEDURE:
%  Short description of the algorithm.
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
%  Optional section: Mention related or required files here. Banane routines may be refenced as anchors <A>loadNEV</A>. 
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
    
    if (kw.graphic)
    end
    
  mav=squeeze(max(rfstruct.pr(pidx).spacetime,[],1));
  sumav=squeeze(sum(rfstruct.pr(pidx).spacetime,1));
  
  if (kw.graphic)
  end
  
  [xmax,ix]=max(max(mav,[],1));
  [ymax,iy]=max(max(mav,[],2));
    
  tc=(rfstruct.pr(pidx).spacetime(:,iy,ix));
  
  meantc=mean(tc);
  stdtc=std(tc);

  if (kw.graphic)
  end
  
  [mtc,itc]=max(tc);
  
  tczero=find((tc-(meantc+stdtc))<=0);
  
  startidx=find((tczero-itc) < 0,1,'last');
  starttime=tczero(startidx)+1;
  if (startidx==length(tczero))
    stoptime=stalength;
  else
    stoptime=tczero(startidx+1)-1;
  end
  
  rf2=squeeze(sum(rfstruct.pr(pidx).spacetime(starttime:stoptime,:,:),1));
  rf=max(rf2-mean(rf2(:)),zeros(rfstruct.xyextent));
  
  
  vstart=[iy ix max(rf(:)) 1.5 1.5];

  [v,fval] = fminsearch(@(v) fitgauss2d(v,rf),vstart);
  
  gs=v(3)*gauss2d(rfstruct.xyextent(1),rfstruct.xyextent(2),v(2),v(1),v(4),v(5));
  mask2sig=(gs>=v(3)*exp(-0.5*kw.avspacerange.^2));
  
  vmm=v;
  vmm(1)=rfstruct.ymmperpos*(v(1)-rfstruct.xyextent(2)/2);%mmynz(round(v(1)));
  vmm(2)=rfstruct.xmmperpos*(v(2)-rfstruct.xyextent(1)/2);%mmxnz(round(v(2)));
  vmm(4)=rfstruct.xmmperpos*v(4);
  vmm(5)=rfstruct.ymmperpos*v(5);

  % e=ellipse(v(2),v(1),2*v(4),2*v(5),25);
  emm=ellipse(vmm(2),vmm(1),2*vmm(4),2*vmm(5),25);

  
  if (kw.graphic)
  end

  

  [ymaskidx,xmaskidx]=find(mask2sig);
  
  tmpav=zeros(rfstruct.avtime,length(xmaskidx));
  
  for avidx=1:length(xmaskidx)
    tmpav(:,avidx)=rfstruct.pr(pidx).spacetime(:,ymaskidx(avidx),xmaskidx(avidx));
  end
  
  tcav=mean(tmpav,2);
  
  if (kw.graphic)
  end
  
  rfstruct.pr(pidx).fit=[vmm fval];
  rfstruct.pr(pidx).avspace=rf2;
  rfstruct.pr(pidx).avtime=tcav;

  if (kw.graphic)
      disp(['index: ' num2str(pidx)]);
      disp(['electrode: ' num2str(rfstruct.pr(pidx).eln)]);
      disp(['prototype: ' num2str(rfstruct.pr(pidx).prn)]);
    subplot(2,4,1), imagesc(rfstruct.mmxnz,rfstruct.mmynz,sumav);
    axis xy;
    subplot(2,4,2), plot(tc);
    axis tight;
    hold on
    subplot(2,4,2), plot(xlim,[meantc meantc]);
    subplot(2,4,2), plot(xlim,[meantc+stdtc meantc+stdtc]);
    hold off
    subplot(2,4,3), imagesc(rfstruct.mmxnz,rfstruct.mmynz,rf)
    axis xy;
    hold on

    plot(emm(1,:),emm(2,:),'w','LineWidth',2);
    plot(vmm(2),vmm(1),'wo','LineWidth',2);
    hold off
  
    subplot(2,4,4),plot(rf(round(v(1)),:)) % , imagesc(gs);
    hold on
    subplot(2,4,4),plot(gs(round(v(1)),:),'r')
    hold off

    subplot(2,4,5),plot(rf(:,round(v(2)))) % , imagesc(gs);
    hold on
    subplot(2,4,5),plot(gs(:,round(v(2))),'r')
    hold off
  
    subplot(2,4,6), imagesc(rfstruct.mmxnz,rfstruct.mmynz,mask2sig.*rf);
    axis xy;
    subplot(2,4,7), plot(tcav);
    axis tight;
    pause
  end
  
 
  
  end %% for pidx
  
  end
  