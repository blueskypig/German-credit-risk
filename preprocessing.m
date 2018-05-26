function [features,labels]= preprocessing()
% Author: Qilin You
%Usage: [features,labels]= preprocessing()
    importdata;
    %% labels
    labels=Class;

    %% features
    features=zeros(1000,9);

    % Age
    features(:,1)=Age;

    % Sex
    for i=1:size(Sex,1)
        if  isequal(Sex{i},'female')
            features(i,2)=0;
        end
        if  isequal(Sex{i},'male')
            features(i,2)=1;
        end
    end

    % Job
    features(:,3)=Job;

    % Housing
    for i=1:size(Housing,1)
        if  isequal(Housing{i},'free')
            features(i,4)=0;
        end
        if  isequal(Housing{i},'rent')
            features(i,4)=1;
        end
        if  isequal(Housing{i},'own')
            features(i,4)=2;
        end
    end

    % Savingaccounts
    for i=1:size(Savingaccounts,1)
        if  isequal(Savingaccounts{i},'NA')
            features(i,5)=-1;
        end
        if  isequal(Savingaccounts{i},'little')
            features(i,5)=0;
        end
        if  isequal(Savingaccounts{i},'moderate')
            features(i,5)=1;
        end
        if  isequal(Savingaccounts{i},'rich')
            features(i,5)=2;
        end
        if  isequal(Savingaccounts{i},'quite rich')
            features(i,5)=3;
        end

    end

    % Checkingaccount
    for i=1:size(Checkingaccount,1)
        if  isequal(Checkingaccount{i},'NA')
            features(i,6)=-1;
        end
        if  isequal(Checkingaccount{i},'little')
            features(i,6)=0;
        end
        if  isequal(Checkingaccount{i},'moderate')
            features(i,6)=1;
        end
        if  isequal(Checkingaccount{i},'rich')
            features(i,6)=2;
        end
    end

    % Creditamount
    features(:,7)=Creditamount;

    % Duration
    features(:,8)=Duration;

    % Purpose
    for i=1:size(Purpose,1)
        if  isequal(Purpose{i},'radio/TV')
            features(i,9)=0;
        end
        if  isequal(Purpose{i},'repairs')
            features(i,9)=1;
        end
        if  isequal(Purpose{i},'domestic appliances')
            features(i,9)=2;
        end
        if  isequal(Purpose{i},'furniture/equipment')
            features(i,9)=3;
        end
        if  isequal(Purpose{i},'vacation/others')
            features(i,9)=4;
        end
        if  isequal(Purpose{i},'education')
            features(i,9)=5;
        end
        if  isequal(Purpose{i},'business')
            features(i,9)=6;
        end
        if  isequal(Purpose{i},'car')
            features(i,9)=7;
        end

    end
    
%% Handle missing data
    for col=1:size(features,2)
        temp=features(:,col);
        temp(find(temp==-1))=[];
        sdata=mean(temp);
        for row=1:size(features,1)
            if features(row,col)==-1
                features(row,col)=sdata;
            end
        end
    end
%% drop out invalid data
    fstd=std(features);
    features(:,find(fstd==0))=[];
end



