function statsCell = medianStats(data, varargin)
p = inputParser;
addRequired(p,'data',@(x) validateattributes(x,{'numeric'},{'ncols', 1}))
addOptional(p,'fSpec', '% 1.1f',@ischar);
addParameter(p,'format', 'long',@(x) any(validatestring(x,{'long','short','Q234'})));
addParameter(p,'test', 'none',@(x) any(validatestring(x,{'none','signrank'})));
addParameter(p,'alpha', 0.05,@(x) validateattributes(x,{'numeric'},{'scalar', '>=', 0.0001, '<=' 0.1}));
parse(p,data,varargin{:});
fSpec = p.Results.fSpec;
format = p.Results.format;
test = p.Results.test;
alpha = p.Results.alpha;

PRCT=prctile(data,[0,25,50,75,100]);
IQR=iqr(data);

switch test
    case 'none'
        P = nan;
    case 'signrank'
        if all(isnan(data))
            P = nan;
        else
            P = signrank(data);
        end
end

switch format
    case 'long'
        statsCell = {[...
            num2str(PRCT(3),fSpec),... % median
            ' (' num2str(PRCT(2),fSpec) ' to ' num2str(PRCT(4),fSpec) '', ... % IQR
            ', ' num2str(PRCT(1),fSpec) ' to ' num2str(PRCT(5),fSpec) ')'] ... % Range
            };
    case 'Q234'
        statsCell = {[num2str(PRCT(3),fSpec), ', ' num2str(PRCT(4),fSpec) ', ' num2str(PRCT(5),fSpec)]};
    case 'short'
        statsCell = {[num2str(PRCT(3),fSpec) ' (' num2str(IQR,fSpec) ')']};
end

if P <= alpha
    statsCell{end} = [statsCell{end} '*'];
end

end