load ClimateData.csv
[L,W] = size(ClimateData);

Data_min = min(ClimateData); % Data_min is the minimum values of attributes

Data_max=max(ClimateData); % Data_max is the minimum values of attributes

Data_norm=zeros(L,W);

for i=1:1:W
 Data_norm(:,i)=(ClimateData(:,i)-Data_min(i))./(Data_max(i)-Data_min(i)); % Perform standardisation for each attribute
end 

 plot(Data_norm(:,1:5));
 title('Normalization');