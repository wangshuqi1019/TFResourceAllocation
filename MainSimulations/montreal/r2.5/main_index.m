clc;
clear;
close all;

%% Define parameters
load('Data.mat');
load('Para_covid.mat');
load('data/sorted.mat');
MaxSimu = 100;
Para_covid.beta = 0.0166/(Para_covid.prop_sym*Para_covid.omega_presym/Para_covid.p_py+(1-Para_covid.prop_sym)*Para_covid.omega_asym);
Para_covid.end_day = 100;

info = feature('numCores');
if info<=50
    parpool('local', 30);
elseif info>50
    parpool('local', 50);
end

%% Define the result structure
Record = cell(100, 1);
Result = cell(10, 10);

clear exposed_listNews
clear exposed_listNows
clear exposed_listSums
clear hospital_listNews
clear hospital_listNows
clear hospital_listSums
clear recovered_listNews
clear recovered_listNows
clear recovered_listSums
%% Simulate 100 times to get the result
for m = 1:10
    coverage = m*0.1;
    for n = 1:10
        efficacy = n*0.1;
        disp(['coverage: ', num2str(coverage), ', efficacy: ', num2str(efficacy)]);
        parfor i=1:100
            rng(i*10);

            params = Para_covid;

            [exposed_peak, hospital_peak, exposed_listNew, exposed_listNow, exposed_listSum, hospital_listNew, hospital_listNow, hospital_listSum,...
                recovered_listNew, recovered_listNow, recovered_listSum, death_listNew, death_listNow, death_listSum]...
                 = infection(sorted, coverage, efficacy, Data, params);

            Record{i}.exposed_peak = exposed_peak;
            Record{i}.hospital_peak = hospital_peak;
            Record{i}.exposed_listNew = exposed_listNew;
            Record{i}.exposed_listNow = exposed_listNow;
            Record{i}.exposed_listSum = exposed_listSum;
            Record{i}.hospital_listNew = hospital_listNew;
            Record{i}.hospital_listNow = hospital_listNow;
            Record{i}.hospital_listSum = hospital_listSum;
            Record{i}.recovered_listNew = recovered_listNew;
            Record{i}.recovered_listNow = recovered_listNow;
            Record{i}.recovered_listSum = recovered_listSum;
            Record{i}.death_listNew = death_listNew;
            Record{i}.death_listNow = death_listNow;
            Record{i}.death_listSum = death_listSum;
        end        
        Result{m,n} = Record;
    end
end

filename = sprintf('results/INDEX2.5.mat');
save(filename, 'Result');