clc;
clear;
close all;

%% Read relevant indicators based on data
load('data/InfeNum.mat');
eta0 = InfeNum;
load('data/InfeTime.mat');
tau0 = InfeTime;
load('data/RAll.mat');
R0 = RAll;
load('data/IPAll.mat');
IP0 = IPAll;
gamma0 = 1./IP0;

for a=1:10
    tau = tau0(:,1:a);
    R = R0(1:a);
    IP = IP0(1:a);
    gamma = 1./IP;
    
    eta = zeros(103425, 1);
    for i = 1:size(tau, 1)
        eta(i) = sum(tau(i, :) ~= 0);
    end
    
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
    filename1 = sprintf('results/index%s.mat', num2str(a));
    save(filename1, 'index');
    filename2 = sprintf('results/sorted%s.mat', num2str(a));
    save(filename2, 'sorted');

end
