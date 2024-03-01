function [exposed_peak, hospital_peak, exposed_listNew, exposed_listNow, exposed_listSum, hospital_listNew, hospital_listNow, hospital_listSum,...
            recovered_listNew, recovered_listNow, recovered_listSum, death_listNew, death_listNow, death_listSum]...
             = infection(sorted, coverage, efficacy, Data, Para)

neighs = Data.neighs;

N = length(neighs);

suscept_list = ones(N,1);
exposed_list = zeros(N,1);
presym_list = zeros(N,1);
sym_list = zeros(N,1);
asym_list = zeros(N,1);
hospital_list = zeros(N,1);
recovered_list = zeros(N,1);
death_list = zeros(N,1);

exposed_listNew = zeros(Para.end_day,1);
exposed_listNow = zeros(Para.end_day,1);
exposed_listSum = zeros(Para.end_day,1);
hospital_listNew = zeros(Para.end_day,1);
hospital_listNow = zeros(Para.end_day,1);
hospital_listSum = zeros(Para.end_day,1);
recovered_listNew = zeros(Para.end_day,1);
recovered_listNow = zeros(Para.end_day,1);
recovered_listSum = zeros(Para.end_day,1);
death_listNew = zeros(Para.end_day,1);
death_listNow = zeros(Para.end_day,1);
death_listSum = zeros(Para.end_day,1);

ToHrate = zeros(N,1);
ToDrate = zeros(N,1);

p_zero = randperm(N, ceil(N*Para.popImmunity));
suscept_list(p_zero) = 0;
exposed_list(p_zero) = 1;
ToH = -1*ones(N,1);
ToD = -1*ones(N,1);
    
masks = zeros(N,1);
if sorted    
    masks(sorted(1:floor(coverage*N))) = 1;
    masks(sorted(floor(coverage*N)+1:end)) = 0;
end

for ic=1:Para.end_day
    
    exposed_list_new = zeros(N,1);
    asym_list_new = zeros(N,1);
    presym_list_new = zeros(N,1);
    sym_list_new = zeros(N,1);
    asym_recovered_list_new = zeros(N,1);
    sym_recovered_list_new = zeros(N,1);
    hosp_recovered_list_new = zeros(N,1);
    hospital_list_new = zeros(N,1);
    death_list_new = zeros(N,1);

    %% S -- E
    NodeList = find(suscept_list==1);
    for i=1:length(NodeList)
        node = NodeList(i);
        if masks(node)==1
            pTemp = (1-exp(-Para.beta*(1-efficacy)*(1-efficacy)*infected_neigh_mask_sum(masks,neighs, node, sym_list,1)...
                - Para.beta*(1-efficacy)*infected_neigh_mask_sum(masks,neighs, node, sym_list,0)...
                - Para.omega_asym*Para.beta*(1-efficacy)*(1-efficacy)*infected_neigh_mask_sum(masks,neighs, node, asym_list,1) ...
                - Para.omega_asym*Para.beta*(1-efficacy)*infected_neigh_mask_sum(masks,neighs, node, asym_list,0) ...
                - Para.omega_presym*Para.beta*(1-efficacy)*(1-efficacy)*infected_neigh_mask_sum(masks,neighs, node, presym_list,1) ...
                - Para.omega_presym*Para.beta*(1-efficacy)*infected_neigh_mask_sum(masks,neighs, node, presym_list,0)));
        else
            pTemp = (1-exp(-Para.beta*(1-efficacy)*infected_neigh_mask_sum(masks,neighs, node, sym_list,1)...
                - Para.beta*infected_neigh_mask_sum(masks,neighs, node, sym_list,0)...
                - Para.omega_asym*Para.beta*(1-efficacy)*infected_neigh_mask_sum(masks,neighs, node, asym_list,1) ...
                - Para.omega_asym*Para.beta*infected_neigh_mask_sum(masks,neighs, node, asym_list,0) ...
                - Para.omega_presym*Para.beta*(1-efficacy)*infected_neigh_mask_sum(masks,neighs, node, presym_list,1) ...
                - Para.omega_presym*Para.beta*infected_neigh_mask_sum(masks,neighs, node, presym_list,0)));
        end
        if rand<pTemp
            exposed_list_new(node)=1;
        end
    end

    %% E -- P or A
    NodeList = find(exposed_list==1);
    for i=1:length(NodeList)
        node=NodeList(i);
        if rand<Para.p_epa
            if rand<Para.prop_sym
                presym_list_new(node)=1;
            else
                asym_list_new(node)=1;
            end
        end
    end

    %%  P -- Y
    NodeList = find(presym_list==1);
    for i=1:length(NodeList)
        node=NodeList(i);
        if rand<Para.p_py
            sym_list_new(node)=1;
        end
    end

    %%  A -- R
    NodeList = find(asym_list==1);
    for i=1:length(NodeList)
        node=NodeList(i);
        if rand<Para.p_ar
            asym_recovered_list_new(node)=1;
        end
    end

    %%  Y -- H or R
    NodeList = find(sym_list==1);
    for i=1:length(NodeList)
        node=NodeList(i);
        if ToH(node) == -1
            if rand<Para.prop_sym_hosp
                ToH(node) = 1;
                ToHrate(node) = Para.p_yh;
            else
                ToH(node) = 0;
                ToHrate(node) = Para.p_yr;
            end
        end
        if ToH(node) == 1
            if rand<ToHrate(node)
                hospital_list_new(node)=1;
            end
        end
        if ToH(node) == 0
            if rand<ToHrate(node)
                sym_recovered_list_new(node)=1;
            end
        end
    end

    %%  H -- D or R
    NodeList = find(hospital_list==1);
	for i=1:length(NodeList)
        node=NodeList(i);
        if ToD(node) == -1
            if rand<Para.prop_hosp_dea
                ToD(node)=1;
                ToDrate(node)=Para.p_hd;
            else
                ToD(node)=0;
                ToDrate(node)=Para.p_hr;
            end
        end
        if ToD(node) == 1
            if rand<ToDrate(node)
                death_list_new(node)=1;
            end
        end
        if ToD(node) == 0
            if rand<ToDrate(node)
                hosp_recovered_list_new(node)=1;
            end
        end
	end
    
    %% Update
    suscept_list((exposed_list_new==1)) = 0;
    suscept_list((asym_list_new==1)) = 0;
    suscept_list((presym_list_new==1)) = 0;    
    suscept_list((sym_list_new==1)) = 0;    
    suscept_list((asym_recovered_list_new==1)) = 0;
    suscept_list((sym_recovered_list_new==1)) = 0;
    suscept_list((hosp_recovered_list_new==1)) = 0;
    suscept_list((hospital_list_new==1)) = 0;
    suscept_list((death_list_new==1)) = 0;
    
    exposed_list((exposed_list_new==1)) = 1;
    exposed_list((asym_list_new==1)) = 0;
    exposed_list((presym_list_new==1)) = 0;
    exposed_list((sym_list_new==1)) = 0; 
    exposed_list((asym_recovered_list_new==1)) = 0;
    exposed_list((sym_recovered_list_new==1)) = 0;
    exposed_list((hosp_recovered_list_new==1)) = 0;
    exposed_list((hospital_list_new==1)) = 0;
    exposed_list((death_list_new==1)) = 0;

    asym_list((exposed_list_new==1)) = 0;
    asym_list((asym_list_new==1)) = 1;
    asym_list((presym_list_new==1)) = 0;    
    asym_list((sym_list_new==1)) = 0;    
    asym_list((asym_recovered_list_new==1)) = 0;
    asym_list((sym_recovered_list_new==1)) = 0;
    asym_list((hosp_recovered_list_new==1)) = 0;
    asym_list((hospital_list_new==1)) = 0;
    asym_list((death_list_new==1)) = 0;

    presym_list((exposed_list_new==1)) = 0;
    presym_list((asym_list_new==1)) = 0;
    presym_list((presym_list_new==1)) = 1;    
    presym_list((sym_list_new==1)) = 0;    
    presym_list((asym_recovered_list_new==1)) = 0;
    presym_list((sym_recovered_list_new==1)) = 0;   
    presym_list((hosp_recovered_list_new==1)) = 0;  
    presym_list((hospital_list_new==1)) = 0;
    presym_list((death_list_new==1)) = 0;

    sym_list((exposed_list_new==1)) = 0;
    sym_list((asym_list_new==1)) = 0;
    sym_list((presym_list_new==1)) = 0;   
    sym_list((sym_list_new==1)) = 1;  
    sym_list((asym_recovered_list_new==1)) = 0;
    sym_list((sym_recovered_list_new==1)) = 0;  
    sym_list((hosp_recovered_list_new==1)) = 0;
    sym_list((hospital_list_new==1)) = 0;
    sym_list((death_list_new==1)) = 0;

    death_list((exposed_list_new==1)) = 0;
    death_list((asym_list_new==1)) = 0;
    death_list((presym_list_new==1)) = 0;   
    death_list((sym_list_new==1)) = 0;  
    death_list((asym_recovered_list_new==1)) = 0;
    death_list((sym_recovered_list_new==1)) = 0; 
    death_list((hosp_recovered_list_new==1)) = 0;
    death_list((hospital_list_new==1)) = 0;
    death_list((death_list_new==1)) = 1;

    hospital_list((exposed_list_new==1)) = 0;
    hospital_list((asym_list_new==1)) = 0;
    hospital_list((presym_list_new==1)) = 0;   
    hospital_list((sym_list_new==1)) = 0;  
    hospital_list((asym_recovered_list_new==1)) = 0;
    hospital_list((sym_recovered_list_new==1)) = 0;
    hospital_list((hosp_recovered_list_new==1)) = 0;
    hospital_list((hospital_list_new==1)) = 1;
    hospital_list((death_list_new==1)) = 0;

    recovered_list((exposed_list_new==1)) = 0;
    recovered_list((asym_list_new==1)) = 0;
    recovered_list((presym_list_new==1)) = 0;
    recovered_list((sym_list_new==1)) = 0;
    recovered_list((asym_recovered_list_new==1)) = 1;
    recovered_list((sym_recovered_list_new==1)) = 1;
    recovered_list((hosp_recovered_list_new==1)) = 1;
    recovered_list((hospital_list_new==1)) = 0;
    recovered_list((death_list_new==1)) = 0;   
    
    exposed_listNew(ic) = sum(exposed_list_new);
    hospital_listNew(ic) = sum(hospital_list_new);
    recovered_listNew(ic) = sum(asym_recovered_list_new)+sum(sym_recovered_list_new)+sum(hosp_recovered_list_new);
    death_listNew(ic) = sum(death_list_new);
    exposed_listNow(ic) = sum(exposed_list);
    hospital_listNow(ic) = sum(hospital_list);
    recovered_listNow(ic) = sum(recovered_list);
    death_listNow(ic) = sum(death_list);
    if ic==1
        exposed_listSum(ic)=sum(exposed_list_new);
        hospital_listSum(ic)=sum(hospital_list_new);
        recovered_listSum(ic) = sum(asym_recovered_list_new)+sum(sym_recovered_list_new)+sum(hosp_recovered_list_new);
        death_listSum(ic) = sum(death_list_new);
    else
        exposed_listSum(ic) = exposed_listSum(ic-1)+sum(exposed_list_new);
        hospital_listSum(ic) = hospital_listSum(ic-1)+sum(hospital_list_new);
        recovered_listSum(ic) = recovered_listSum(ic-1)+sum(asym_recovered_list_new)+sum(sym_recovered_list_new)+sum(hosp_recovered_list_new);
        death_listSum(ic) = death_listSum(ic-1)+sum(death_list_new);
    end
end

[~, exposed_peak] = max(exposed_listNow);
[~, hospital_peak] = max(hospital_listNow);
end
