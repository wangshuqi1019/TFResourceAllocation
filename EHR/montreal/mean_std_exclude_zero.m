function [array_mean, array_std] = mean_std_exclude_zero(array)
num_elements = numel(array{1});
num_arrays = numel(array);

temp = zeros(num_elements, num_arrays);

for i = 1:num_arrays
    temp(:, i) = array{i};
end

zero_counts = sum(temp == 0, 2);
zero_threshold = 160;

zero_mask = zero_counts >= zero_threshold;

array_mean = zeros(num_elements, 1);
array_std = zeros(num_elements, 1);

nonzero_num = sum(temp ~= 0, 2);
nonzero_sum = sum(temp, 2);
array_mean(~zero_mask) = nonzero_sum(~zero_mask) ./ nonzero_num(~zero_mask);
array_std(~zero_mask) = sqrt(sum((temp(~zero_mask,:) - array_mean(~zero_mask)).^2, 2) ./ (nonzero_num(~zero_mask) - 1));
end
