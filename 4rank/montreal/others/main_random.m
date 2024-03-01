clc;
clear;
close all;

rng(1);

data = (1:103425)';
random_indices = randperm(length(data));
sortedRandom = data(random_indices);

save('results/sortedRandom.mat','sortedRandom');