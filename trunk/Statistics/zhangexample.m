%+
% NAME:
%  zhangexample()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  J. R. Hacker
%
% DATE CREATED:
%  9/2002
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
%   - Support Routines<BR>
%   - Arrays<BR>
%   - Classes<BR>
%   - Misc<BR>
%   - Strings<BR>
%   - Receptive Fields<BR>
%   - Signals<BR>
%  Others may be invented, with corresponding subdirectories in the
%  BANANE directory tree. For example:<BR>
%   - DataStorage<BR>
%   - Demonstration<BR>
%   - Graphic<BR>
%   - Help<BR>
%   - Statistics<BR>
%   - Simulation<BR>
%
% SYNTAX:
%* result = example_function(arg1, arg2 [,'optarg1',value][,'optarg2',value]); 
%
% INPUTS:
%  arg1:: First argument of the function call. Indicate variable type and
%  function.
%  arg2:: Second argument of the function call.
%
% OPTIONAL INPUTS:
%  optarg1:: An optional input argument.
%  optarg2:: Another optional input argument. Of course, the whole
%  section is optional, too.
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
%  will be typeset in a fixed width font. Indicate user input with >>. 
%* >> data=example_function(23,5)
%* ans =
%*   28
%
% SEE ALSO:
%  Optional section: Mention related or required files here. Banane routines may be refenced as anchors <A>loadNEV</A>. 
%-



clear all;

steplength=500

stim=repmat(repel([1 2],steplength),1,10);

ratefactor=[0.1;0.2];

nsweeps=3

for swidx=1:nsweeps
  rates=ratefactor*stim;
  [lr,cr]=size(rates);
  spikes=rand(lr,cr)<rates;


  rsp(swidx).nproto=2;
  rsp(swidx).duration=size(spikes,2)/1000;

  for pidx=1:lr
    rsp(swidx).pr(pidx).eln=pidx;
    rsp(swidx).pr(pidx).prn=1;
    rsp(swidx).pr(pidx).ts=0.001*find(spikes(pidx,:));
  end % for cidx

end % for swidx

[h,bv,ri] = histmd(stim.','nbins',[2]);
prior=h/sum(h(:));

ir=instantrate(rsp,'window',0.1);
 
for swidx=1:nsweeps
    
  trainsweeps=setdiff((1:nsweeps),swidx);

  [llh,rv]=likelihood(ir(trainsweeps),bv,ri);
 
  tunem=tuning(llh,rv*ir(swidx).factor);

  est(swidx).eststim=zhang(ir(swidx),tunem,prior.',bv);
  
end % for

subplot(2,2,1), bar(tunem(1,:),1)
xlabel('Stimulus');
ylabel('f_{1}  / Hz');
axis([0.5 2.5 0 400])
subplot(2,2,2), bar(tunem(2,:),1)
xlabel('Stimulus');
ylabel('f_{2}  / Hz');
axis([0.5 2.5 0 400])

subplot(2,2,[3 4]) & plot(est(1).eststim)
axis([1000 3000 0.8 2.2])
hold on
plot(est(2).eststim,'g')
plot(stim,'r')
xlabel('Time / ms');
ylabel('Stimulus');
