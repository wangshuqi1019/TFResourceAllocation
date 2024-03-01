function [ifOutbreak, infeTime, infection_listNew, infection_listNow, infection_listSum, recovered_listNew, recovered_listNow, recovered_listSum]...
    = infection(Data, Para)

neighs = Data.neighs;

N = length(neighs);

suscept_list = ones(N,1);
infection_list = zeros(N,1);
recovered_list = zeros(N,1);

infection_listNew = zeros(Para.end_day,1);
infection_listNow = zeros(Para.end_day,1);
infection_listSum = zeros(Para.end_day,1);
recovered_listNew = zeros(Para.end_day,1);
recovered_listNow = zeros(Para.end_day,1);
recovered_listSum = zeros(Para.end_day,1);

infeTime = zeros(N,1);
infeFlag = false(N,1);
recoTime = zeros*ones(N,1);
recoFlag = false(N,1);

p_zero = randperm(N, ceil(N*Para.popImmunity));
suscept_list(p_zero) = 0;
infection_list(p_zero) = 1;
ifOutbreak = true;

for ic=1:Para.end_day
    
    infection_list_new = zeros(N,1);
    recovered_list_new = zeros(N,1);

    %% S -- I
    NodeList = find(suscept_list==1);
    for i=1:length(NodeList)
        node = NodeList(i);
        pTemp = (1-exp(-Para.beta*infected_neigh_sum(neighs, node, infection_list)));
        if rand<pTemp
            infection_list_new(node)=1;
            if ~infeFlag(node)
                infeTime(node) = ic;
                infeFlag(node) = true;
            end
        end
    end
    
    %% I -- R
    NodeList = find(infection_list==1);
    for i=1:length(NodeList)
        node=NodeList(i);
        if rand<Para.p_ir
            recovered_list_new(node)=1;
            if ~recoFlag(node)
                recoTime(node) = ic;
                recoFlag(node) = true;
            end
        end
    end

    %% Update
    suscept_list((infection_list_new==1)) = 0;    
    suscept_list((recovered_list_new==1)) = 0;
    
    infection_list((infection_list_new==1)) = 1; 
    infection_list((recovered_list_new==1)) = 0;
    
    recovered_list((infection_list_new==1)) = 0;
    recovered_list((recovered_list_new==1)) = 1;
    
    infection_listNew(ic) = sum(infection_list_new);
    recovered_listNew(ic) = sum(recovered_list_new);
    infection_listNow(ic) = sum(infection_list);
    recovered_listNow(ic) = sum(recovered_list);
    if ic==1
        infection_listSum(ic)=sum(infection_list_new);
        recovered_listSum(ic) = sum(recovered_list_new);
    else
        infection_listSum(ic) = infection_listSum(ic-1)+sum(infection_list_new);
        recovered_listSum(ic) = recovered_listSum(ic-1)+sum(recovered_list_new);
    end
    
    %% Check conditions
    if ic == 30 && (infection_listNow(ic) < ceil(N*Para.popImmunity))
        ifOutbreak = false;
        return;
    end
end
end
