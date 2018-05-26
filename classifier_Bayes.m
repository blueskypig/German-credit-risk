clear;clc;close all;

%% import data
[features,labels]=preprocessing();
costM=[0,1;1,0];

%% classification
disp('Naive-Bayes-Classification')

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
                model=fitcnb(trfeatures,trlabels,'Cost',costM);
                pred_labels=predict(model,vfeatures);
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
     model=fitcnb(traindata,trainlabels,'Cost',costM);
     pred_labels=predict(model,testdata);
     %% evaluation
     [accuracy,F_measure]=evaluation(pred_labels,testlabels);
     tcaccuracy(tindex)=accuracy;
     tcf_measure(tindex,:)=F_measure';
end
mf1scores=mean(tcf_measure);
fprintf('Accuracy:%.2f%%  F_meansure(Good;Bad):%.2f;%.2f \n',mean(tcaccuracy)*100,mf1scores(1),mf1scores(2));

