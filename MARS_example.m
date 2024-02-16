clear all;
clc;
rng('default')
s = rng;

D=xlsread("MARS example (1).xlsx" );
D=D(1:length(D)-1,4:5);
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

params = aresparams2('maxFuncs', -1, 'c', 3,'prune',false, 'maxInteractions', 1, 'cubic', true);
model = aresbuild(X_train, Y_train, params)
results = arestest(model, X_test, Y_test)
areseq(model)
aresplot(model)