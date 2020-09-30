iter = 10000;% Number of iterations: repeat "iter" times 
population_size = 200; % Number of chromosomes in population
load xy.mat; %Load xy.mat
distance_matrix = []; %empty distance matrix

num_cities = size(xy,1); %get number of cities 
total_distance = zeros(1,population_size);
dist_history = zeros(1,iter);
global_min = Inf;
temp = 0;
cur_gen = 0;
k = 0;

%cities_dist
a = meshgrid(1:num_cities);
cities_dist = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),num_cities,num_cities);

%Generate population
population = zeros(population_size,num_cities);
population(1,:) = (1:num_cities);
for i = 2:population_size
    temp_chromosome = randperm(num_cities); %unique
    population(i,:) = temp_chromosome;
end

%Fitness
%% always have an extra column at end for fitness scores

population = [population zeros(population_size,1)];

%% repeat k times; each time generates a new population
for k = 1:iter  
    %% evaluate fitness scores
    for i = 1:population_size
        temp = cities_dist(population(i,num_cities),population(i,1));
        for j = 2:num_cities
                temp = temp + cities_dist(population(i,j-1),population(i,j));
        end
        population(i,num_cities+1) = temp;
    end
    
    % get minimum dist and index
    [min_dist,index] = min(population(:,num_cities+1));
    dist_history(k) = min_dist;
    
    if min_dist < global_min
        global_min = min_dist;
        optimal_route = population(index,:);
        path = optimal_route([1:num_cities 1]);
        plot(xy(path,1),xy(path,2),'r.-');
        title(sprintf('Distance = %1.4f',min_dist));
        cur_gen=k;
    end
    
     %% elite, keep best 2
     population = sortrows(population,num_cities+1);   
     population_new = zeros(population_size,num_cities);
     population_new(1:2,:) = population(1:2,1:num_cities);
     population_new_num = 2;
     
     %% repeat until new population is full0.
    while (population_new_num < population_size)
        %% use a selection method and pick two chromosomes
        %population1 = population;
        best1 = tournament(population);
        %population1(best1,:)=[]; 
        best2 = tournament(population);
        temp_chromosome_1 = population(best1,1:num_cities);
        temp_chromosome_2 = population(best2,1:num_cities);
        %choice1
        %choice2
        
        %% crossover prob 0.8 and random pick cross point
        if (rand < 0.8)
            % need to add your own code here ...
            offspring1 = zeros(1,100);
            offspring2 = zeros(1,100);
            
            %Order based Crossover
            cp1 = randi([1,100]); 
            cp2 = randi([1,100]);
            while (cp2 == cp1)
                cp2 = randi([1,100]);
            end
            
            if(cp1 > cp2)
                temp = cp1;
                cp1 = cp2;
                cp2 = temp;
            end
            
            
            for i=1:1:100
                if(i>=cp1) && (i<=cp2)
                    offspring1(1,i) = temp_chromosome_1(1,i);
                    offspring2(1,i) = temp_chromosome_2(1,i); 
                end  
            end
        %------------------------------------------------------    
            x1 = offspring1(1,cp1:cp2);
            x2 = offspring2(1,cp1:cp2);
            [M1,N1] = size(x1);
            [M2,N2] = size(x2);
            
            C1_rest=[];
            C2_rest=[];
            
            for i=1:1:100
               mem2 = ismember(temp_chromosome_2(1,i),x1);
               mem1 = ismember(temp_chromosome_1(1,i),x2);
               if(mem2 == 0)
                  
                  C2_rest = [C2_rest temp_chromosome_2(1,i)]; 
               end
               
               if(mem1 == 0)
                  
                  C1_rest = [C1_rest temp_chromosome_1(1,i)]; 
               end
                
            end 
            
        %-------------------------------------------------------    
            [L1, S1] = size(C1_rest);
            [L2, S2] = size(C2_rest);
            
            %=========
            j=0;
            
            for i=1:1:S1
                if (i+cp2)>100
                  j = j+1;              
                  offspring1(1,j) = C2_rest(1,i);
                  offspring2(1,j) = C1_rest(1,i);
                else
                  offspring1(1,i+cp2) = C2_rest(1,i);
                  offspring2(1,i+cp2) = C1_rest(1,i);
                end
            end
            
            population_new_num = population_new_num + 1;
            population_new(population_new_num,:) = offspring1;
            
            if (population_new_num < population_size)
                population_new_num = population_new_num + 1;
                population_new(population_new_num,:) = offspring2;
            end

        end
        
        %% mutation prob 0.2 and random pick bit to switch
        %swap
        if (rand < 0.2) && (population_new_num < population_size)

            offspring3 = temp_chromosome_1; %----------------------------
            %flip
            fr1 = randi([1,100]); 
            fr2 = randi([1,100]);
            while (fr1 == fr2)
                fr2 = randi([1,100]);
            end
            
            if(fr1 > fr2)
                temp = fr1;
                fr1 = fr2;
                fr2 = temp;
            end
            
            part1 = offspring3(1,1:fr1-1);
            part2 = offspring3(1,fr1:fr2);
            part3 = offspring3(1,fr2+1:end);
            
            part2_flip = fliplr(part2);
            
            offspring5 = [part1 part2_flip part3];
     
            %slide
            
            s1 = randi([1,100]); 
            s2 = randi([1,100]);
            while (s1 == s2)
                s2 = randi([1,100]);
            end
            
            if(s1 > s2)
                temp = s1;
                s1 = s2;
                s2 = temp;
            end
            
            p1 = offspring5(1,1:s1-1);
            p2 = offspring5(1,s1);
            p3 = offspring5(1,s1+1:s2);
            p4 = offspring5(1,s2+1:end);

            offspring7 = [p1 p3 p2 p4];
        
            
            population_new_num = population_new_num + 1;
            population_new(population_new_num,:) = offspring7;

        end
        
        if (rand < 0.2) && (population_new_num < population_size)
            %flip
            offspring4 = temp_chromosome_2; %----------------------------           
            fr3 = randi([1,100]); 
            fr4 = randi([1,100]);
            while (fr3 == fr4)
                fr4 = randi([1,100]);
            end 
 
            if(fr3 > fr4)
                temp = fr3;
                fr3 = fr4;
                fr4 = temp;
            end
            
            part11 = offspring4(1,1:fr3-1);
            part22 = offspring4(1,fr3:fr4);
            part33 = offspring4(1,fr4+1:end);
            
            part22_flip = fliplr(part22);
            
            offspring6 = [part11 part22_flip part33];
            %slide       
            s3 = randi([1,100]); 
            s4 = randi([1,100]);
            while (s3 == s4)
                s4 = randi([1,100]);
            end
         
            offspring6 = temp_chromosome_2; %----------------------------
            if(s3 > s4)
                temp = s3;
                s3 = s4;
                s4 = temp;
            end
            
            p11 = offspring6(1,1:s3-1);
            p22 = offspring6(1,s3);
            p33 = offspring6(1,s3+1:s4);
            p44 = offspring6(1,s4+1:end);

            offspring8 = [p11 p33 p22 p44];
        
          
            population_new_num = population_new_num + 1;
            population_new(population_new_num,:) = offspring8;
                     
        end
             
       
    end     
    %% replace, last column not updated yet
    population(:,1:num_cities) = population_new; 
    
    %% evaluate fitness scores and rank them
    for i = 1:population_size
        temp = cities_dist(population(i,num_cities),population(i,1));
        for j = 2:num_cities
                temp = temp + cities_dist(population(i,j-1),population(i,j));
        end
        
        population(i,num_cities+1) = temp;
        %population
    end
    population = sortrows(population,num_cities+1);
    population(1,num_cities+1)
   
    %%=============plotting===============================
    %figure('Name','TSP_GA | Results','Numbertitle','off');
    subplot(2,2,1);
    pclr = ~get(0,'DefaultAxesColor');
    plot(xy(:,1),xy(:,2),'.','Color',pclr);
    title('City Locations');
    subplot(2,2,2);
    
    [minDist,Index] = min(population(:,num_cities+1));
    optimal_route = population(index,:);
    path = optimal_route([1:num_cities 1]);
    plot(xy(path,1),xy(path,2),'r.-');
    title(sprintf('Distance = %1.4f',min_dist));
end
    
