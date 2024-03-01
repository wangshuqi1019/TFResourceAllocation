clc;
clear;

eta = 1:10;
coverage = 0.05:0.05:0.5;

load('data/sortedDegree.mat');
load('data/sortedRandom.mat');
load('data/sortedFriend.mat');
load('data/eigenvectorCentrality.mat');

len = length(sortedDegree);
eigen_degree = zeros(length(coverage), 1);
for i = 1:length(coverage)
    idx = floor(len * coverage(i));
    subsetDegree = sortedDegree(1:idx);
    subsetCentrality = eigenvectorCentrality(subsetDegree);
    eigen_degree(i) = mean(subsetCentrality);
end

eigen_random = zeros(length(coverage), 1);
for i = 1:length(coverage)
    idx = floor(len * coverage(i));
    subsetRandom = sortedRandom(1:idx);
    subsetCentrality = eigenvectorCentrality(subsetRandom);
    eigen_random(i) = mean(subsetCentrality);
end

eigen_friend = zeros(length(coverage), 1);
for i = 1:length(coverage)
    idx = floor(len * coverage(i));
    subsetFriend = sortedFriend(1:idx);
    subsetCentrality = eigenvectorCentrality(subsetFriend);
    eigen_friend(i) = mean(subsetCentrality);
end

eigen_index = zeros(length(coverage), length(eta));
for i = 1:length(coverage)
    idx = floor(len * coverage(i));
    
    for j = 1:length(eta)
        filename = sprintf('data/sorted%s.mat', num2str(j));
        load(filename, 'sorted');
        subsetIndex = sorted(1:idx);
        subsetCentrality = eigenvectorCentrality(subsetIndex);
        eigen_index(i,j) = mean(subsetCentrality);
    end
end

save('results/eigen_degree_new.mat','eigen_degree');
save('results/eigen_random_new.mat','eigen_random');
save('results/eigen_friend_new.mat','eigen_friend');
save('results/eigen_index_new.mat','eigen_index');

