function l = list(varargin)
  
  switch nargin
   case 0
    ca=cell(1);
    l.hook = ca;
    l = class(l,'list');
   case 1
    if (isa(varargin{1},'list'))
        l = varargin{1};
    else
      ca=num2cell(varargin{1});
      l.hook = ca;
      l = class(l,'list');
    end
   otherwise
    error('Wrong number of input arguments')
  end

