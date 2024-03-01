edges = xlsread('edges.csv');

numNodes = 4629;
neighbors = cell(numNodes, 1);
str = cell(numNodes, 1);

for i = 1:numNodes
    connectedEdges = find(edges(:, 1) == i | edges(:, 2) == i);

    if isempty(connectedEdges)
        neighbors{i} = [];
        str{i} = sprintf('[%s]', strjoin(arrayfun(@num2str, [], 'UniformOutput', false), ','));
    else
        neighborNodes = setdiff(edges(connectedEdges, :), i);
        neighbors{i} = neighborNodes;
        str{i} = sprintf('[%s]', strjoin(arrayfun(@num2str, neighborNodes, 'UniformOutput', false), ','));
    end
end

fileName1 = 'neighs.xlsx';
stringArray = cellfun(@char, str, 'UniformOutput', false);
writecell(stringArray, fileName1);
