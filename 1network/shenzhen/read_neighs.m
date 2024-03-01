edges = xlsread('edges.csv');
house_edges = xlsread('house_edges.csv');
others_edges = xlsread('others_edges.csv');

numNodes = 10000;
neighbors = cell(numNodes, 1);
str = cell(numNodes, 1);
house_neighbors = cell(numNodes, 1);
house_str = cell(numNodes, 1);
others_neighbors = cell(numNodes, 1);
others_str = cell(numNodes, 1);

for i = 1:numNodes
    connectedEdges = find(edges(:, 1) == i | edges(:, 2) == i);
    house_connectedEdges = find(house_edges(:, 1) == i | house_edges(:, 2) == i);
    others_connectedEdges = find(others_edges(:, 1) == i | others_edges(:, 2) == i);

    if isempty(connectedEdges)
        neighbors{i} = [];
        str{i} = sprintf('[%s]', strjoin(arrayfun(@num2str, [], 'UniformOutput', false), ','));
    else
        neighborNodes = setdiff(edges(connectedEdges, :), i);
        neighbors{i} = neighborNodes;
        str{i} = sprintf('[%s]', strjoin(arrayfun(@num2str, neighborNodes, 'UniformOutput', false), ','));
    end
    
    if isempty(house_connectedEdges)
        house_neighbors{i} = [];
        house_str{i} = sprintf('[%s]', strjoin(arrayfun(@num2str, [], 'UniformOutput', false), ','));
    else
        house_neighborNodes = setdiff(house_edges(house_connectedEdges, :), i);
        house_neighbors{i} = house_neighborNodes;
        house_str{i} = sprintf('[%s]', strjoin(arrayfun(@num2str, house_neighborNodes, 'UniformOutput', false), ','));
    end
    
    if isempty(others_connectedEdges)
        others_neighbors{i} = [];
        others_str{i} = sprintf('[%s]', strjoin(arrayfun(@num2str, [], 'UniformOutput', false), ','));
    else
        others_neighborNodes = setdiff(others_edges(others_connectedEdges, :), i);
        others_neighbors{i} = others_neighborNodes;
        others_str{i} = sprintf('[%s]', strjoin(arrayfun(@num2str, others_neighborNodes, 'UniformOutput', false), ','));
    end
end

fileName1 = 'neighs.xlsx';
stringArray = cellfun(@char, str, 'UniformOutput', false);
writecell(stringArray, fileName1);

fileName2 = 'house_neighs.xlsx';
stringArray = cellfun(@char, house_str, 'UniformOutput', false);
writecell(stringArray, fileName2);

fileName3 = 'others_neighs.xlsx';
stringArray = cellfun(@char, others_str, 'UniformOutput', false);
writecell(stringArray, fileName3);
