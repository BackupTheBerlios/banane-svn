%+
% NAME:
%  transitions()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  5/2007
%
% AIM:
%  Generate random sequence of switches between array indices.
%
% DESCRIPTION:
%  transitions() returns a sequence of array indices
%  that can be used to generate a random series of state switches.
%  The series contains all the desired transitions between those
%  states. This may be needed to create stimulus sequences that switch 
%  between a number of possible stimuli and one wants to be sure that
%  all these stimuli are applied and that at the same time all
%  transitions from one of these stimuli to another one are also
%  contained. Since there may be more than one solution to this
%  problem, transitions() generates one possible random
%  solution. If one needs longer sequences, different of those random
%  transition sequences may be concatenated.
%
% CATEGORY:
%   Support Routines<BR>
%   Arrays
%
% SYNTAX:
%* result = transitions(array [,'maxiter',value])
%
% INPUTS:
%  array:: This may take two different forms.<BR>
%           Either, a onedimensional
%          array of integer or longword type that is interpreted as
%          all the array 
%          indices that should be visited by the sequence. The result
%          will contain all possible transitions between those
%          indices, including those that switch from one index to
%          itself.<BR>
%          The second possibility is to pass a twodimensional array of
%          numerical type, its nonzero entries meaning that a transition
%          between the row index of the entry and its column index is
%          desired. In this way, certain transitions can be excluded
%          conveniently. The actual value of nonzero elements is
%          currently not taken into account, but may later be used to
%          enable certain transitions to occur mor eoften than others.
%
% OPTIONAL INPUTS:
%  maxiter:: The maximum number of iterations allowed to find a
%            solution. Since finding a sequence of transitions may
%            sometimes take quite some time for long index arrays,
%            setting this keyword prevents the routine from searching
%            too long. If no solution was found, the result returned
%            in <VAR>NaN</VAR>. It may yield faster results if the
%            routine is started anew if it hasn't terminated after
%            a certain number of steps. Setting <VAR>'maxiter',0</VAR>
%            disables the 
%            stopping function and transitions() will continue to
%            explore the transition space until it finds a
%            solution. Default: <VAR>'maxiter',10000</VAR>.
%
% OUTPUTS:
%  result:: Onedimensional array containing a sequence of
%           indices. <VAR>result(1)=result(end)</VAR>, ie the
%           sequence always starts and ends with the same index. The
%           number of elements in <VAR>result</VAR> is 
%           <VAR>n^2+1</VAR> with <VAR>n</VAR> being the number of entries
%           in <VAR>array</VAR>, if <VAR>array</VAR> was onedimensional, and
%           <VAR>m+1</VAR>, 
%           with <VAR>m</VAR> being the number of nonzero elements of
%           <VAR>array</VAR>, if it was twodimensional.
%
% PROCEDURE:
%  A kind of sorting a twodimensional array that contains the possible
%  states in the form of
%* [...[state i],[state n]...]
%* [...[state j],[state m]...]
% that tries to arrange them such that 
%* [...[state i],[state j],[state k]...]
%* [...[state j],[state k],[state l]...]
% The routine keeps former possibilities in a stack and returns to
% them if it gets stuck.
%
% EXAMPLE:
%* array=['a' 'b' 'c'];
%* array(transitions(1:3))
%*>  Index input, all transitions allowed.
%*>  ans =
%*>  caabacbbcc
%* array(transitions(1:3))
%*>  Index input, all transitions allowed.
%*>  ans =
%*>  baabcaccbb
%* allow=ones(3)-eye(3);
%* array(transitions(allow))
%*>  Transition matrix input.
%*>  ans =
%*>  cbabcac
%* allow=ones(10)-eye(10);
%* tr=transitions(allow);
%*>  Transition matrix input.
%* trs=circshift(tr,[0,1]);
%* trc=[tr;trs]';
%* hist3(trc)
%
%-



% NAME:
%  transitions()
%
% VERSION:
%  $Id$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  5/2007
%
% AIM:
%  Generate random sequence of switches between array indices.
%
% PURPOSE:
%  transitions() returns a sequence of array indices
%  that can be used to generate a random series of state switches.
%  The series contains all the desired transitions between those
%  states. This may be needed to create stimulus sequences that switch 
%  between a number of possible stimuli and one wants to be sure that
%  all these stimuli are applied and that at the same time all
%  transitions from one of these stimuli to another one are also
%  contained. Since there may be more than one solution to this
%  problem, transitions() generates one possible random
%  solution. If one needs longer sequences, different of those random
%  transition sequences may be concatenated.
%
% CATEGORY:
%  Support Routines
%  Arrays
%
% CALLING SEQUENCE:
%* result = transitions(array [,'maxiter',value])
%
% INPUTS:
%  array:: This may take two different forms.<BR>
%           Either, a onedimensional
%          array of integer or longword type that is interpreted as
%          all the array 
%          indices that should be visited by the sequence. The result
%          will contain all possible transitions between those
%          indices, including those that switch from one index to
%          itself.<BR>
%          The second possibility is to pass a twodimensional array of
%          numerical type, its nonzero entries meaning that a transition
%          between the row index of the entry and its column index is
%          desired. In this way, certain transitions can be excluded
%          conveniently. The actual value of nonzero elements is
%          currently not taken into account, but may later be used to
%          enable certain transitions to occur mor eoften than others.
%
% INPUT KEYWORDS:
%  maxiter:: The maximum number of iterations allowed to find a
%            solution. Since finding a sequence of transitions may
%            sometimes take quite some time for long index arrays,
%            setting this keyword prevents the routine from searching
%            too long. If no solution was found, the result returned
%            in <VAR>NaN</VAR>. It may yield faster results if the
%            routine is started anew if it hasn't terminated after
%            a certain number of steps. Setting <VAR>'maxiter',0</VAR>
%            disables the 
%            stopping function and transitions() will continue to
%            explore the transition space until it finds a
%            solution. Default: <VAR>'maxiter',10000</VAR>.
%
% OUTPUTS:
%  result:: Onedimensional array containing a sequence of
%           indices. <VAR>result(1)=result(end)</VAR>, ie the
%           sequence always starts and ends with the same index. The
%           number of elements in <VAR>result</VAR> is 
%           <VAR>n^2+1</VAR> with <VAR>n</VAR> being the number of entries
%           in <VAR>array</VAR>, if <VAR>array</VAR> was onedimensional, and
%           <VAR>m+1</VAR>, 
%           with <VAR>m</VAR> being the number of nonzero elements of
%           <VAR>array</VAR>, if it was twodimensional.
%
% PROCEDURE:
%  A kind of sorting a twodimensional array that contains the possible
%  states in the form of
%* [...[state i],[state n]...]
%* [...[state j],[state m]...]
% that tries to arrange them such that 
%* [...[state i],[state j],[state k]...]
%* [...[state j],[state k],[state l]...]
% The routine keeps former possibilities in a stack and returns to
% them if it gets stuck.
%
% EXAMPLE:
%* array=['a' 'b' 'c'];
%* array(transitions(1:3))
%*>  Index input, all transitions allowed.
%*>  ans =
%*>  caabacbbcc
%* array(transitions(1:3))
%*>  Index input, all transitions allowed.
%*>  ans =
%*>  baabcaccbb
%* allow=ones(3)-eye(3);
%* array(transitions(allow))
%*>  Transition matrix input.
%*>  ans =
%*>  cbabcac
%* allow=ones(10)-eye(10);
%* tr=transitions(allow);
%*>  Transition matrix input.
%* trs=circshift(tr,[0,1]);
%* trc=[tr;trs]';
%* hist3(trc)
%




function r=transitions(i, varargin)
  
   kw=kwextract(varargin, 'maxiter', 10000);

   si=size(i);
   
   ndi=sum(si~=1);

   % decide whether input is possible indices or a transition
   % matrix. make diff array that contains all allowed transitions in
   % the form [...[state i],[state n]...]
   %          [...[state j],[state m]...]
   switch ndi
     case 1
         disp('Index input, all transitions allowed.');
         cnz = si(2)^2;
         ri=repmat(i,1,si(2));
         diff=[ri(:) repel(i,si(2)).'];
     case 2
         disp('Transition matrix input.');
         cnz=nnz(i);
         [nzi,nzj]=find(i);
         diff=[nzi nzj];
    otherwise
     error('Pass either 1- or 2dim arrays.');
   
   end % switch
   
   % Scramble the diff array to generate random solutions
   diff = diff(randperm(cnz),:);
   
   % Init some state variables
   count = 2; % position inside the diff array that is processed
   c = 1; % number of possible next diff entries that may be inserted
   niter = 0; % overall number of iterations
   stopsearch = false; % flag to mark whether max iterations have been reached

   st = stack();

   while (((count<=cnz) || (c~=1)) && (~stopsearch))
 
     % if no more diff entries are left to
     % be inserted, pop the previous state off the stack
     if (c==0)
       
       count=count-2; % return to the previous position
       [st,p]=pop(st);
       while (size(p,1)==1)
         [st,p] = pop(st);
         count = count-1;
       end % while
       next=p(2:end, :);
       c=size(next,1);
     
     else
       
       nextidx=find(diff(count:end, 1)==diff(count-1, 2));
       c=length(nextidx);
       next=diff(nextidx+count-1,:);
     
     end % if (c==0)
 
     % insert a fitting diff entry at the present position
     if (c~=0)
       
       st=push(st, next);
       nextidx = find((diff(:, 1)==next(1, 1)) & ...
                      (diff(:, 2)==next(1, 2)));

       if (nextidx~=count) % only swap if it is necessary
         add = diff(nextidx,:);
         diff(nextidx,:)=diff(count,:);
         diff(count,:)=add;
       end % if
     
     end % if (c~=0)

     if (kw.maxiter>0)
       if (niter >= kw.maxiter) 
         disp('Failed to find transition sequence.');
         stopsearch = true;
       end % if (niter >= kw.maxiter)
     end % if (kw.maxiter>0)
   
     niter=niter+1;
     count=count+1;
     
   end % while

   if (stopsearch) 
     r=NaN;
   else
     r=[diff(:, 1); diff(cnz, 2)].';
   end % if (stopsearch)

