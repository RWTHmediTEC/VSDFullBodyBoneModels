function VSD_addPathes(prefix)
% Add necessary pathes

% 
addpath(genpath([prefix 'General\Code\optimizeMesh']))

% https://de.mathworks.com/matlabcentral/fileexchange/66645
addpath([prefix 'General\Code\#external\#InputOutput\nrrd_read_write_rensonnet'])

% https://github.com/altmany/export_fig
addpath(genpath([prefix 'General\Code\#external\#Visualization\export_fig']))

end