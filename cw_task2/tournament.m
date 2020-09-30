function best = tournament(population)
    [L,W] = size(population);
    %choice = 0;
    best = L; 
    for i = 1:L
        r1 = randi([1 L]);
        r2 = randi([1 L]);
        if population(r1,W) <= population(r2,W)
            choice = r1;
        else
            choice = r2;
        end
        
        if(population(choice,W)<=population(best,W))
           best = choice;        
        end
    end