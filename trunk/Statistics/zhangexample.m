%+
% NAME:
%  zhangexample()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  12/2007
%
% AIM:
%  Demonstrates the use of routines for stimulus estimation.
%
% DESCRIPTION:
%  This script demonstrates the use of the routines needed for Bayesian
%  stimulus estimation. First, the responses of two neurons to a
%  stimulus alternating between two values 1 and 2 are generated. Both
%  neurons respond 
%  stronger to stimulus 2, but the second neuron generally produces more spikes
%  in response to both stimuli. The example experiment consists of three
%  repetitions (sweeps) of the same stimulus.<BR>
%  After the neuronal responses have been
%  simulated, the prior distribution of stimuli is computed using
%  <A>histmd</A>, and the spike numbers as a function of time are
%  calculated with <A>instantrate</A>. Next, the probability of
%  encountering neuronal responses given a certain stimulus is determined
%  with the <A>likelihood</A> function. The result is used as an input to
%  the <A>tuning</A> routine, which returns the average firing rates of
%  each neuron to each stimulus. likelihhod and tuning curves are
%  computed using two of the three experimental repetitions, while the
%  responses during the remaining sweep are used for reconstruction with
%  the <A>zhang</A> routine.
%
% CATEGORY:
%  Demonstration<BR>
%  Statistics
%
% SYNTAX:
%* zhangexample 
%
% PROCEDURE:
%  Generate example responses, estimate stimulus from them and display
%  the tuning curves and reconstruction.
%
% EXAMPLE:
%* >> zhangexample
%
% SEE ALSO:
%  <A>histmd</A>, <A>instantrate</A>, <A>likelihood</A>, <A>tuning</A>,
%  <A>zhang</A>.  
%-



clear all;

steplength=500;

% stimulus switches between values 1 and two every 500 ms
stim=repmat(repel([1 2],steplength),1,10);

% first neuron fires with rates 100/200 Hz, 2nd neuron fires 200/400Hz. 
ratefactor=[0.1;0.2];

% 3 repetitions of "experiment"
nsweeps=3;

rates=ratefactor*stim;
[lr,cr]=size(rates);

for swidx=1:nsweeps
  
  % generate spikes according to poisson statistics
  spikes=rand(lr,cr)<rates;

  % build response structure
  rsp(swidx).nproto=2;
  rsp(swidx).duration=size(spikes,2)/1000;

  for pidx=1:lr
    rsp(swidx).pr(pidx).eln=pidx;
    rsp(swidx).pr(pidx).prn=1;
    
    % convert spikes matrix to timestamp vectors
    rsp(swidx).pr(pidx).ts=0.001*find(spikes(pidx,:));
  end % for pidx

end % for swidx

% compute the prior, bv (stimulus bin values) are need below for
% reconstruction, ri (reverse indices) are needed by the likelihood
% function.
[h,bv,ri] = histmd(stim.','nbins',[2]);
prior=h/sum(h(:));

% count spikes in sliding window of size 100ms.
ir=instantrate(rsp,'window',0.1);

% loop through sweeps, use one of them for estimation, the other two for
% likelihhod computation
for swidx=1:nsweeps
    
  % set of training sweeps
  trainsweeps=setdiff((1:nsweeps),swidx);

  [llh,rv]=likelihood(ir(trainsweeps),bv,ri);
 
  % rv at this point has units of spike numbers. Since tuning is normally
  % given in rates, rv is multiplied by the factor returned by
  % instantrate that can be used to convert spike numbers to rates
  tunem=tuning(llh,rv*ir(swidx).factor);

  % for each sweep, save the estimated stimulus
  est(swidx).eststim=zhang(ir(swidx),tunem,prior.',bv);
  
end % for

% show the results, first tuning curves for both neurons
subplot(2,2,1), bar(tunem(1,:),1)
xlabel('Stimulus');
ylabel('f_{1}  / Hz');
axis([0.5 2.5 0 400])
subplot(2,2,2), bar(tunem(2,:),1)
xlabel('Stimulus');
ylabel('f_{2}  / Hz');
axis([0.5 2.5 0 400])

% show stimulus (red) and estimations from the first and 2nd sweep
subplot(2,2,[3 4]), plot(est(1).eststim)
axis([750 4250 0.8 2.2])
hold on
plot(est(2).eststim,'g')
plot(stim,'r')
xlabel('Time / ms');
ylabel('Stimulus');
