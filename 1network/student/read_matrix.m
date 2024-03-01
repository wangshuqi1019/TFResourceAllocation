%% All contact matrices
data = xlsread('student_cc.csv');

contact_matrix = zeros(4629, 4629);

for i = 1:size(data, 1)
    p1 = data(i, 1);
    p2 = data(i, 2);
    contact_matrix(p1, p2) = 1;
    contact_matrix(p2, p1) = 1;
end

save('contact_matrix.mat', 'contact_matrix');
