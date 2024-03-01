function [array_mean,array_std] = mean_std(array)
num_elements = numel(array{1});
num_arrays = numel(array);

temp = zeros(num_elements, num_arrays);

for i = 1:num_arrays
    temp(:, i) = array{i};
end

array_mean = mean(temp, 2);
array_std = std(temp, 0, 2);
end
