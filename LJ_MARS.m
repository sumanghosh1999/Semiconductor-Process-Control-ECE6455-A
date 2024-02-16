clear all;
clc;
rng('default')
s = rng;

temp=360;
time='24hrs';

D=xlsread("jvsLopt_T_360K_24hrs_rangeJ..xlsx" );

%(train: 70%, test: 30%)
cv = cvpartition(size(D,1),'HoldOut',0.3);
idx = cv.test;
% Separate to training and test data
D_train = D(~idx,:);
D_test  = D(idx,:);

sD_train=size(D_train);
sD_test=size(D_test);

X_train=D_train(:,1:sD_train(2)-1);
X_test=D_test(:,1:sD_test(2)-1);
Y_train=D_train(:,sD_train(2));
Y_test=D_test(:,sD_test(2));

min_X_train=min(X_train);
max_X_train=max(X_train);
mean_X_train=mean(X_train);
std_X_train=std(X_train);

min_Y_train=min(Y_train);
max_Y_train=max(Y_train);
mean_Y_train=mean(Y_train);
std_Y_train=std(Y_train);

min_X_test=min(X_test);
max_X_test=max(X_test);
mean_X_test=mean(X_test);
std_X_test=std(X_test);

min_Y_test=min(Y_test);
max_Y_test=max(Y_test);
mean_Y_test=mean(Y_test);
std_Y_test=std(Y_test);

%Normalization
normalized_X_train = (X_train - min_X_train) / (max_X_train - min_X_train);
normalized_X_test = (X_test - min_X_test) / (max_X_test - min_X_test);
normalized_Y_train = (Y_train - min_Y_train) / (max_Y_train - min_Y_train);
normalized_Y_test = (Y_test - min_Y_test) / (max_Y_test - min_Y_test);

%Standardization
standardized_X_train = (X_train - mean_X_train) / std_X_train;
standardized_X_test = (X_test - mean_X_test) / std_X_test;
standardized_Y_train = (Y_train - mean_Y_train) / std_Y_train; 
standardized_Y_test = (Y_test - mean_Y_test) / std_Y_test; 

%plot(normalized_X_train,normalized_Y_train)

% MARS Model
X_train_in=normalized_X_train;
X_test_in=normalized_X_test;
Y_train_in=normalized_Y_train;
Y_test_in=normalized_Y_test;

params = aresparams2('maxFuncs', -1, 'c', 3,'prune',false,'selfInteractions',5, 'cubic', false,'cubicFastLevel',0,'useEndSpan',1);
model = aresbuild(X_train_in, Y_train_in, params)
results = arestest(model, X_test_in, Y_test_in)
areseq(model)
aresplot(model)

% Wait for the user to brush the data
disp('Brush the data points you want to save, then press any key to continue...');
pause;

% Reverse Normalization
data_j=brushedData(:,1)*(max_X_train - min_X_train) + min_X_train;
data_Lopt=brushedData(:,2)*(max_Y_train - min_Y_train) + min_Y_train;


% Reverse Standardization
%data_j=brushedData(:,1)*std_X_train + mean_X_train;
%data_Lopt=brushedData(:,1)*std_Y_train + mean_Y_train;

data=[data_j data_Lopt];
data(1:10,:)
size(data)
filetype='.xlsx'; %'.csv';
filename=sprintf('jvsLopt_T_%dK_%s_MARS%s',temp,time,filetype);

%.xlsx format
colNames={'j','L_opt'};
dataTable = array2table(data,'VariableNames', colNames);
writetable(dataTable, filename, 'WriteRowNames', true);
%.csv format
%csvwrite(filename,data);
disp('Data saved!!!')