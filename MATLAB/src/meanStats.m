function statsCell = meanStats(data, varargin)
%MEANSTATS calculates mean statistics
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2022 Maximilian C. M. Fischer
% LICENSE: EUPL v1.2
%

p = inputParser;
addRequired(p,'data',@(x) validateattributes(x,{'numeric'},{'ncols', 1}))
addParameter(p,'format', 'long',@(x) any(validatestring(x,{'long','short'})));
addOptional(p,'fSpec', '% 1.1f',@ischar);
parse(p,data,varargin{:});
fSpec = p.Results.fSpec;
format = p.Results.format;

MEAN=nanmean(data);
STD(1)=nanstd(data);STD(2)=MEAN-STD(1);STD(3)=MEAN+STD(1);
RNG(1)=range(data);RNG(2)=min(data);RNG(3)=max(data);

switch format
    case 'long'
        statsCell = {[...
            num2str(MEAN,fSpec) ' (' num2str(STD(1),fSpec) ', ' ...
            num2str(RNG(2),fSpec) ' to ' num2str(RNG(3),fSpec) ')']};
    case 'short'
        statsCell = {[num2str(MEAN,fSpec) ' ' char(177) ' ' num2str(STD(1),fSpec)]};
end

end