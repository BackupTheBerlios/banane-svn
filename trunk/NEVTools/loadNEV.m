%+
% NAME:
%  loadNEV()
%
% VERSION:
%  $Id:$
%
% AUTHOR:
%  A. Thiel
%
% DATE CREATED:
%  12/2006
%
% AIM:
%  Testchange1. Extracts keywords and their values from function calls.
%
% DESCRIPTION:
%  kwextract enables argument passing to a function in the form
%  'keyword1',value1,'keyword2',value2 etc. The list of keywords and
%  values has to occur after the regular arguments of a function, with
%  arbitrary order of the keywords. To evaluate the keywords, kwextract
%  returns a structure with fields corresponding to the keywords and the
%  values of the fields set accordingly. If the keyword is not present in
%  the call to the original function, kwextract sets a default
%  value. Abbrevation of keywords in the call is possible.
%
% CATEGORY:
%  Support routines 
%
% SYNTAX:
%* kwstruct = kwextract(kwpresent [,keyword1,defval1] [,keyword2,defval2]); 
%
% INPUTS:
%  kwpresent:: The varargin cell array provided by MATLAB originating
%  from the call to the original function.
%
% OPTIONAL INPUTS:
%  keyword1,defval1:: A pair of a string giving the name of the keyword,
%  followed by its default value. The value can be of any type. If no
%  keyword/value pairs are given, no
%  keywords are allowed in the function call. If the original function is
%  called without the keyword that is present in the list, the keyword
%  will get its default value.
%  keyword2,defval2:: Another pair. There may be as many pairs as needed.
%
% OUTPUTS:
%  kwstruct:: A structure with fields according to the keyword list,
%  their values set either to the default values or to those given in the
%  function cell.
%
% RESTRICTIONS:
%  Duplicate keywords are not allowed. Of course, assignment of values to
%  field name does only work if the order of keywordstring followed by
%  its value is strictly respected. 
%
% PROCEDURE:
%  Generate a structure with fields named according to keyword strings
%  and set their default values. Afterwards, search for occurrences of
%  keywords in the actual function call and overwrite the defaults.
%
% EXAMPLE:
%* function output=foobar(normalarg,varargin);
%*    kw=kwextract(varargin,'number',23,'string','fnord','anothernumber',1);
%*    display(kw.number);
%*    display(kw.string);
%*    display(kw.anothernumber);
%*    output=normalarg+kw.number+kw.anothernumber;
%* 
% Call function foobar like this for example:
%* out=foobar(23,'anothernumber',5,'number',8)
%
%*>ans =
%*>     8
%*>fnord
%*>ans =
%*>     5
%*>out =
%*>    36
%
% SEE ALSO:
%  <A>RoutineName</A>
%-


function kwstruct=kwextract(kwpresent,varargin);

  [st,i] = dbstack; % function call stack for error messages
  
  % small syntax check, if number of keywords plus values is odd,
  % assignment of value to keyword must fail
  % first, check arguments passed to the function
  if mod(length(kwpresent),2)==1 
    error(['Odd number of keywords and values in call to "' st(i+1).file ...
           '".']); 
  end

  ndefaults=length(varargin);
  
  % next, check arguments passed to kwextract (defaults)
  if mod(ndefaults,2)==1 
    error('Odd number of keywords and default values.'); 
  end
  
  % extract the field names and default values from varargin this relys
  % on the arguments being passed in alternating style:
  % 'keyword1',value1,'keyword2',value2 etc. 
  
  defaultfields=varargin(1:2:ndefaults);

  % check whether default field names are all strings
  for d=1:length(defaultfields)
    if not(ischar(defaultfields{d}))
     error('Default field names must be passed as strings.'); 
    end
  end
  
  duplicates=zeros(1,length(defaultfields));
  defaultvalues=varargin(2:2:ndefaults);
  
  % generate structure with default fields and the corresponding values
  kwstruct=cell2struct(defaultvalues,defaultfields,2);

  % search for the keywords that are actually present in the function call
  for k = 1:2:length(kwpresent)
    if ischar(kwpresent{k})
      now = strmatch(kwpresent{k}, strvcat(defaultfields));
      if now
        if duplicates(now)==0
          kwstruct.(defaultfields{now})=kwpresent{k+1};
          duplicates(now)=1;
        else
          error(['Keyword "%s" occurrs more than once in call to "' ...
                 st(i+1).file '".'], kwpresent{k});
        end
      else
        error(['Keyword "%s" not allowed in call to "' st(i+1).file '".'], ...
              kwpresent{k}); 
      end
    else
      error(['Keywords have to passed as strings in call to "' st(i+1).file ...
             '".']); 
    end
  end
  