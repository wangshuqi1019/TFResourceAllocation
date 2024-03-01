function infected_sources = infected_neigh(neighs, node, infection_list)
neighbors=eval(neighs{node})';
infected_neigh_get=infection_list(neighbors);
infected_sources = neighbors(infected_neigh_get==1);
end
