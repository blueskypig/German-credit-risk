clear;clc;close all;

%% import data
[features,labels]=preprocessing2();
costM=[0,1;1,0];

%% classification
disp('K-Nerest-Neighborhood')

foldnum=5;
% set aside testdata(20%)
[dfeatures,dlabels]=Partition(features,labels,foldnum);
tcaccuracy=zeros(5,1);tcf_measure=zeros(5,2);
for tindex=1:foldnum
    [traindata,trainlabels,testdata,testlabels]=redistribution(dfeatures,dlabels,tindex,0);
    ctimes=5;
    accuracymat=zeros(101,size(features,2),ctimes);
    for T=1:ctimes
        [tdfeatures,tdlabels]=Partition(traindata,trainlabels,foldnum);
        for knum=3:4:101
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
                    model=fitcknn(trfeatures,trlabels,'NumNeighbors',knum,'Cost',costM);
                    pred_labels=predict(model,vfeatures);

                    %% evaluation
                    [accuracy,F_measure]=evaluation(pred_labels,vlabels);
                    caccuracy(i)=accuracy;
                    cf_measure(i,:)=F_measure';
                end
            accuracymat(knum,fnum,T)=mean(caccuracy);
            end
        end
    end
    averageprecision=accuracymat(:,:,1);
    for n=2:ctimes
        averageprecision=averageprecision+accuracymat(:,:,n);
    end
    averageprecision=averageprecision/ctimes;
    meanmax=max(averageprecision);
    meanmax=max(meanmax);
    [kmax,fmax]=find(averageprecision==meanmax);
    %% Normalization
     fmean=mean(traindata);
     fstd=std(traindata);
     traindata=normalize(traindata,fmean,fstd);
     testdata=normalize(testdata,fmean,fstd);
    %% PCA
     [coeff, score, latent]=pca(traindata);
     traindata=score(:,1:fmax(1));
     project_v=testdata*coeff;
     testdata=project_v(:,1:fmax(1));
    %% classifier
     model=fitcknn(traindata,trainlabels,'NumNeighbors',kmax(1),'Cost',costM);
     pred_labels=predict(model,testdata);
     %% evaluation
     [accuracy,F_measure]=evaluation(pred_labels,testlabels);
     tcaccuracy(tindex)=accuracy;
     tcf_measure(tindex,:)=F_measure';
end
mf1scores=mean(tcf_measure);
fprintf('Accuracy:%.2f%%  F_meansure(Good;Bad):%.2f;%.2f \n',mean(tcaccuracy)*100,mf1scores(1),mf1scores(2));



