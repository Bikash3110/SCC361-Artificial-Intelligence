load ClimateData.csv
% Obtain the size of the dataset. 
[L,W] = size(ClimateData);
% Obtain the mean and standard divation of the dataset. 
Miu=mean(ClimateData); %Mean

Sigma =std(ClimateData);  % Sigma is the standard deviation
% Standardise each attribute of the dataset

Data_stand=zeros(L,W);  % Create a variable for storing the Stand data

for i=1:1:W
 Data_stand(:,i)=(ClimateData(:,i)-Miu(i))./Sigma(i); % Perform standardisation for each attribute
end

for i=1:1:W
 find(Data_stand(:,i)>3) 
 find(Data_stand(:,i)<-3)
end 
