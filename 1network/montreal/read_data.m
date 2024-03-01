%% Define structures, including various types of data in data files
[~, ~, neighs] = xlsread('neighs.xlsx','Sheet1');
neighs(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),neighs)) = {''};

Data.neighs=neighs;

save('Data.mat','Data');
