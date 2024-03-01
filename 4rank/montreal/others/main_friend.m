clc;
clear;
close all;

rng(1);

load('Data.mat');
neighs = Data.neighs;

friend0 = zeros(103425,1);
n = 103425;
shuffled_array = randperm(n);
for i = 1:103425
    individual = shuffled_array(i);
    neighbors = eval(neighs{individual});
    neighbor = neighbors(randi(length(neighbors)));
    friend0(i) = neighbor;
end
temp = tabulate(friend0(:));
data = temp(:,1:2);
current_size = size(data, 1);
if current_size < 103425
    for i = 1:103425 - current_size
        add = [current_size+1, 0];
        data = [data; add];
    end
end

random_order = randperm(size(data, 1));
data_random = data(random_order, :);
[~, sorted_index] = sortrows(data_random, -2);
sortedFriend = data_random(sorted_index, 1);

save('results/sortedFriend.mat','sortedFriend');
