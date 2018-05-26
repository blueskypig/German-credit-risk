clear;clc;close all;

%% import data
[features,labels]=preprocessing2();
costM=[0,1;1,0];

%% classification
disp('Multiple Layers Neural Network')
% define architecture
NodeNum1=128;% 1st layer
NodeNum2=128;% 2nd layer
NodeNum3=128;% 3rd layer
NodeNum4=128;% 4th layer
NodeNum5=64;% 5th layer
TypeNum=2; % number of class
TF1='tansig';%'tansig';  %tansig(n) = 2/(1+exp(-2*n))-1
TF2='purelin';
TF3='tansig';
TF4='purelin';
TF5='logsig';
OUT='tansig';
net=newff(minmax(sn),[NodeNum1,NodeNum2,NodeNum3,NodeNum4,NodeNum5,TypeNum],{TF1 TF2 TF3,TF4,TF5,OUT});%,'trainscg','learngdm'
net.trainParam.show=100; 
net.trainParam.epochs=100000; 
net.trainParam.goal=3e-5; 
net.trainParam.lr=0.1;

foldnum=5;
% set aside testdata(20%)
[dfeatures,dlabels]=Partition(features,labels,foldnum);
tcaccuracy=zeros(5,1);tcf_measure=zeros(5,2);
for tindex=1:foldnum
    [traindata,trainlabels,testdata,testlabels]=redistribution(dfeatures,dlabels,tindex,0);
    % times for cross-validation
    ctimes=20;
    accuracymat=zeros(size(features,2),ctimes);
    for T=1:ctimes
        [tdfeatures,tdlabels]=Partition(traindata,trainlabels,foldnum);
        for fnum=1:size(features,2)
            % reinitial
            caccuracy=zeros(5,1);cf_measure=zeros(5,2);
            for i=1:foldnum 
                [trfeatures,trlabels,vfeatures,vlabels]=redistribution(tdfeatures,tdlabels,i,0);
                %% Normalization
                fmean=mean(trfeatures);
                fstd=std(trfeatures);
                trfeatures=normalize(trfeatures,fmean,fstd);
                vfeatures=normalize(vfeatures,fmean,fstd);
                %% PCA
                [coeff, score, latent]=pca(trfeatures);
                trfeatures=score(:,1:fnum);
                project_v=vfeatures*coeff;
                vfeatures=project_v(:,1:fnum);
                %% classifier
                targets=zeros(size(trlabels,1),2);
                for ti=1:size(trlabels,1)
                    if trlabels(ti)==1
                        targets(ti,:)=[1,0];
                    end
                    if trlabels(ti)==2
                        targets(ti,:)=[0,1];
                    end
                end
                [sn,mins,maxs,tn,mint,maxt]=premnmx(trfeatures',targets');%pn = 2*(p-minp)/(maxp-minp) - 1
                net=train(net,sn,tn,'useGPU','yes');
                % test
                s2n=tramnmx(vfeatures',mins,maxs);
                an=sim(net,s2n);
                testout=postmnmx(an,mint,maxt);
                [~, pred_labels] = max(testout', [], 2);
                %% evaluation
                [accuracy,F_measure]=evaluation(pred_labels,vlabels);
                caccuracy(i)=accuracy;
                cf_measure(i,:)=F_measure';
            end
            accuracymat(fnum,T)=mean(caccuracy);
        end
    end
    averageprecision=mean(accuracymat,2);
    [~,maxindex]=max(averageprecision);
    %% Normalization
     fmean=mean(traindata);
     fstd=std(traindata);
     traindata=normalize(traindata,fmean,fstd);
     testdata=normalize(testdata,fmean,fstd);
    %% PCA
     [coeff, score, latent]=pca(traindata);
     traindata=score(:,1:maxindex);
     project_v=testdata*coeff;
     testdata=project_v(:,1:maxindex);
    %% classifier
     targets=zeros(size(trainlabels,1),2);
     for ti=1:size(trainlabels,1)
         if trainlabels(ti)==1
             targets(ti,:)=[1,0];
         end
         if trainlabels(ti)==2
             targets(ti,:)=[0,1];
         end
     end
     [sn,mins,maxs,tn,mint,maxt]=premnmx(traindata',targets');%pn = 2*(p-minp)/(maxp-minp) - 1
     net=train(net,sn,tn,'useGPU','yes');
     % test
     s2n=tramnmx(testdata',mins,maxs);
     an=sim(net,s2n);
     testout=postmnmx(an,mint,maxt);
     [~, pred_labels] = max(testout', [], 2);
     %% evaluation
     [accuracy,F_measure]=evaluation(pred_labels,testlabels);
     tcaccuracy(tindex)=accuracy;
     tcf_measure(tindex,:)=F_measure';
end
mf1scores=mean(tcf_measure);
fprintf('Accuracy:%.2f%%  F_meansure(Good;Bad):%.2f;%.2f \n',mean(tcaccuracy)*100,mf1scores(1),mf1scores(2));

