function infected_neigh_get = infected_neigh_mask_sum( masks,neighbors_all, node, infected_list, target )
neighbors=eval(neighbors_all{node});
masks_neighbors = neighbors(masks(neighbors)==target);
infected_neigh_get=sum(infected_list(masks_neighbors));
end