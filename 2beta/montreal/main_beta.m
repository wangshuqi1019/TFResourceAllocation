load('contact_matrix.mat');
load('RAll.mat');

rng(1);

degrees = sum(contact_matrix);
mean_degree = mean(degrees);

degrees_squared = degrees.^2;
mean_squared_degree = mean(degrees_squared);

a1 = 1.12;
b1 = 1.28;
c1 = 1.36;

a2 = 1.9;
b2 = 5.5;
c2 = 7.0;

triangularDist1 = makedist('Triangular', 'a', a1, 'b', b1, 'c', c1);
triangularDist2 = makedist('Triangular', 'a', a2, 'b', b2, 'c', c2);

RAll = random(triangularDist1, [10, 1]);
save('RAll.mat','RAll');
IPAll = random(triangularDist2, [10, 1]);
save('IPAll.mat','IPAll');
betaAll = RAll/((mean_squared_degree-mean_degree)/mean_degree);
save('betaAll.mat','betaAll');

R=[1.2, 1.5, 2, 2.2, 2.5, 3];
beta = R/((mean_squared_degree-mean_degree)/mean_degree);
disp(beta);


