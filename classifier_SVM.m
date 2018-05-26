clear;clc;close all;

%% import data
[features,labels]=preprocessing();
costM=[0,1;1,0];

%% classification
disp('Support-Vector-Machine')
g=logspace(-3,3,50);c=g;
foldnum=5;
% set aside testdata(20%)
[dfeatures,dlabels]=Partition(features,labels,foldnum);
tcaccuracy=zeros(5,1);tcf_measure=zeros(5,2);
for tindex=1:foldnum
    [traindata,trainlabels,testdata,testlabels]=redistribution(dfeatures,dlabels,tindex,0);
    ctimes=5;
    accuracymat=zeros(50,50,ctimes);
    for T=1:ctimes
        [tdfeatures,tdlabels]=Partition(traindata,trainlabels,foldnum);
        for cnum=1:50
            for gnum=1:50
                % reinitial
                caccuracy=zeros(5,1);cf_measure=zeros(5,2);
                for i=1:foldnum 
                    [trfeatures,trlabels,vfeatures,vlabels]=redistribution(tdfeatures,tdlabels,i,0);
                    %% Normalization
                    fmean=mean(trfeatures);
                    fstd=std(trfeatures);
                    trfeatures=normalize(trfeatures,fmean,fstd);
                    vfeatures=normalize(vfeatures,fmean,fstd);
%                     %% PCA
%                     [coeff, score, latent]=pca(trfeatures);
%                     trfeatures=score(:,1:fnum);
%                     project_v=vfeatures*coeff;
%                     vfeatures=project_v(:,1:fnum);
                    %% classifier
                    options=sprintf('%s %d %s %d %s','-t 2 -c',c(cnum),'-g',g(gnum),'-d 3 -q');
                    model=svmtrain(trlabels,trfeatures,options);
                    %validation result
                    [pred_labels, vaccuracy, vdecision_values]=svmpredict(vlabels, vfeatures, model, '-q');
                    %% evaluation
                    [accuracy,F_measure]=evaluation(pred_labels,vlabels);
                    caccuracy(i)=accuracy;
                    cf_measure(i,:)=F_measure';
                end
            accuracymat(cnum,gnum,T)=mean(caccuracy);
            end
        end
    end
    averageprecision=accuracymat(:,:,1);
    for n=2:ctimes
        averageprecision=averageprecision+accuracymat(:,:,n);
    end
    averageprecision=averageprecision/ctimes;
    surf(c,g,averageprecision); title('ACC');
    set(gca,'Xscale','log','Yscale','log');
    meanmax=max(averageprecision);
    meanmax=max(meanmax);
    [cmax,gmax]=find(averageprecision==meanmax);
    %% Normalization
     fmean=mean(traindata);
     fstd=std(traindata);
     traindata=normalize(traindata,fmean,fstd);
     testdata=normalize(testdata,fmean,fstd);
%     %% PCA
%      [coeff, score, latent]=pca(traindata);
%      traindata=score(:,1:fmax(1));
%      project_v=testdata*coeff;
%      testdata=project_v(:,1:fmax(1));
     %% classifier
     options=sprintf('%s %d %s %d %s','-t 2 -c',c(cmax),'-g',g(gmax),'-d 3 -q');
     model=svmtrain(trainlabels,traindata,options);
     %validation result
     [pred_labels, vaccuracy, vdecision_values]=svmpredict(testlabels, testdata, model, '-q');
     %% evaluation
     [accuracy,F_measure]=evaluation(pred_labels,testlabels);
     tcaccuracy(tindex)=accuracy;
     tcf_measure(tindex,:)=F_measure';
end
mf1scores=mean(tcf_measure);
fprintf('Accuracy:%.2f%%  F_meansure(Good;Bad):%.2f;%.2f \n',mean(tcaccuracy)*100,mf1scores(1),mf1scores(2));



