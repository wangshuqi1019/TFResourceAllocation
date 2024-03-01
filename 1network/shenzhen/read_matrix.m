%% All contact matrices
data = xlsread('shenzhen_contact_network.csv');

contact_matrix = zeros(10000, 10000);

for i = 1:size(data, 1)
    p1 = data(i, 1)+1;
    p2 = data(i, 2)+1;
    contact_matrix(p1, p2) = 1;
    contact_matrix(p2, p1) = 1;
end

save('contact_matrix.mat', 'contact_matrix');
