clc;
clear;
close all;

%% Define parameters
load('data/Data.mat');
load('data/Para_flu.mat');
load('data/betaAll.mat');
load('data/RAll.mat');
load('data/IPAll.mat');

Para = Para_flu;
MaxSimu = 10;
NumNetwork = 4605;

info = feature('numCores');
if info<=50
    parpool('local', 30);
elseif info>50
    parpool('local', 50);
end

%% Define the result structure
InfeTimeCI = cell(MaxSimu, 1);
InfeTimeCrI = cell(MaxSimu, 1);
InfePeriodCI = cell(MaxSimu, 1);
InfePeriodCrI = cell(MaxSimu, 1);
RecordCI = cell(MaxSimu, 1);
RecordCrI = cell(MaxSimu, 1);

%% Simulating MaxSimu’s record using 10 betas
for i=1:MaxSimu
    clear infeTimes
    clear recoTimes
    clear exposed_listNews
    clear exposed_listNows
    clear exposed_listSums
    clear infection_listNews
    clear infection_listNows
    clear infection_listSums
    clear recovered_listNews
    clear recovered_listNows
    clear recovered_listSums
    %% Simulate records for each year
    parfor j=1:200
        rng(i*j*10);

        params = Para;
        params.beta = betaAll(i);
        params.p_ir = 1/IPAll(i);

        ifOutbreak = false;
        temp = 0;
        while ~ifOutbreak
            rng(i*j*10+temp);
            [ifOutbreak, infeTime, infection_listNew, infection_listNow, infection_listSum, recovered_listNew, recovered_listNow, recovered_listSum]...
                = infection(Data, params);
            temp = temp+1;
        end

        infeTimes{j} = infeTime;
        infection_listNews{j} = infection_listNew;
        infection_listNows{j} = infection_listNow;
        infection_listSums{j} = infection_listSum;
        recovered_listNews{j} = recovered_listNew;
        recovered_listNows{j} = recovered_listNow;
        recovered_listSums{j} = recovered_listSum;
    end
    
    %% CI
    [infection_listNews_mean,infection_listNews_std] = mean_std_exclude_zero(infection_listNews);
    [infection_listNows_mean,infection_listNows_std] = mean_std_exclude_zero(infection_listNows);
    [infection_listSums_mean,infection_listSums_std] = mean_std_exclude_zero(infection_listSums);
    [recovered_listNews_mean,recovered_listNews_std] = mean_std_exclude_zero(recovered_listNews);
    [recovered_listNows_mean,recovered_listNows_std] = mean_std_exclude_zero(recovered_listNows);
    [recovered_listSums_mean,recovered_listSums_std] = mean_std_exclude_zero(recovered_listSums);
    ResultCI.infection_listNews = horzcat(infection_listNews_mean, infection_listNews_std);
    ResultCI.infection_listNows = horzcat(infection_listNows_mean, infection_listNows_std);
    ResultCI.infection_listSums = horzcat(infection_listSums_mean, infection_listSums_std);
    ResultCI.recovered_listNews = horzcat(recovered_listNews_mean, recovered_listNews_std);
    ResultCI.recovered_listNows = horzcat(recovered_listNows_mean, recovered_listNows_std);
    ResultCI.recovered_listSums = horzcat(recovered_listSums_mean, recovered_listSums_std);
    RecordCI{i} = ResultCI;

    [infeTimes_mean, infeTimes_std] = mean_std_exclude_zero(infeTimes);
    infeTimes_mean = round(infeTimes_mean);
    InfeTimeCI{i} = horzcat(infeTimes_mean, infeTimes_std);
end

%% Infection time, recovery time, number of infections used to calculate metrics
InfeTime = zeros(NumNetwork, MaxSimu);
for i = 1:MaxSimu
    InfeTime(:, i) = InfeTimeCI{i}(:, 1);
end
InfeNum = zeros(NumNetwork, 1);
for i = 1:NumNetwork
    InfeNum(i) = sum(InfeTime(i, :) ~= 0);
end

%% Save results
save('results/InfeTime.mat','InfeTime');
save('results/InfeNum.mat','InfeNum');

save('results/RecordCI.mat','RecordCI');
save('results/InfeTimeCI.mat','InfeTimeCI');
