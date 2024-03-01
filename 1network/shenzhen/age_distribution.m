load('Data.mat');
ages=Data.ages;

ageBins = 0:5:100;
ageBins(end) = 101;

histCounts = histcounts(ages, ageBins);

ageTable = table(ageBins(1:end-1)', ageBins(2:end)', histCounts', 'VariableNames', {'AgeStart', 'AgeEnd', 'Count'});

filename = 'age_distribution.xlsx';
writetable(ageTable, filename, 'Sheet', 'age');
