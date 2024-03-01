clc;
clear;
close all;

%% Read relevant indicators based on data
load('data/InfeNum.mat');
eta = InfeNum;
load('data/InfeTime.mat');
tau = InfeTime;
load('data/RAll.mat');
R = RAll;
load('data/IPAll.mat');
IP = IPAll;
gamma = 1./IP;

%% index
eta_reciprocal = 1 ./ eta;
extended_R = repmat(R', size(tau, 1), 1);
extended_gamma = repmat(gamma', size(tau, 1), 1);
result = sum(tau .* (extended_R-extended_gamma), 2);
index = eta_reciprocal.*result;
[value, sorted] = sort(index);
non_result = sorted((~isinf(value))&(~isnan(value)));
new_sorted = non_result;
inf_result = sorted(isinf(value));
inf_index = mean(InfeTime(inf_result,:),2);
[inf_value, inf_sorted] = sort(inf_index);
for i=1:length(inf_result)
    new_sorted(length(non_result)+i)=inf_result(inf_sorted==i);
end
nan_result = sorted(isnan(value));
nan_index = InfeNum(nan_result);
[nan_value, nan_sorted] = sort(nan_index, 'descend');
for i=1:length(nan_result)
    new_sorted(length(non_result)+length(inf_result)+i)=nan_result(nan_sorted==i);
end
sorted = new_sorted;

%% Save results
save('results/index.mat','index');
save('results/sorted.mat','sorted');
