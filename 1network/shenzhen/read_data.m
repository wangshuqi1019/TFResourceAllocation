%% Define structures, including various types of data in data files
[~, ~, neighs] = xlsread('neighs.xlsx','Sheet1');
neighs(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),neighs)) = {''};
[~, ~, house_neighs] = xlsread('house_neighs.xlsx','Sheet1');
house_neighs(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),house_neighs)) = {''};
[~, ~, others_neighs] = xlsread('others_neighs.xlsx','Sheet1');
others_neighs(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),others_neighs)) = {''};
[~, ~, ages] = xlsread('ages.xlsx','Sheet1');
ages(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),ages)) = {''};
ages = reshape([ages{:}],size(ages));

Data.neighs=neighs;
Data.house_neighs=house_neighs;
Data.others_neighs=others_neighs;
Data.ages=ages;

save('Data.mat','Data');
