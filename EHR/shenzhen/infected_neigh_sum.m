function infected_neigh_get = infected_neigh_sum(neighs, node, infection_list)
neighbors=eval(neighs{node});
infected_neigh_get=sum(infection_list(neighbors));
end
