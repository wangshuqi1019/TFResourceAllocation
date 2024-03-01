clc;
clear;
close all;

%% Generate graph
data = readtable('data/edges.csv');

numNodes = 4629;
edges = table2array(data(:, 1:2));
edges = unique((edges), 'rows');
edges1 = int32(edges(:, 1));
edges2 = int32(edges(:, 2));

G = graph();
G = addnode(G, numNodes);
nodeNames = cellstr(num2str((1:numNodes)'));
G.Nodes.Name = nodeNames;
G = addedge(G, edges1, edges2);

%% Calculate centrality
betweennessCentrality = centrality(G, 'betweenness');
save('results/betweennessCentrality.mat','betweennessCentrality');
degreeCentrality = centrality(G, 'degree');
save('results/degreeCentrality.mat','degreeCentrality');
eigenvectorCentrality = centrality(G, 'eigenvector');
save('results/eigenvectorCentrality.mat','eigenvectorCentrality');

%% Sorting results of various types of nodes
[~, sortedBetweenness] = sort(betweennessCentrality, 'descend');
[~, sortedDegree] = sort(degreeCentrality, 'descend');
[~, sortedEigenvector] = sort(eigenvectorCentrality, 'descend');

save('results/sortedBetweenness.mat','sortedBetweenness');
save('results/sortedDegree.mat','sortedDegree');
save('results/sortedEigenvector.mat','sortedEigenvector');
