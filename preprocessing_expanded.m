function [features,labels]= preprocessing()
% Author: Qilin You
%Usage: [features,labels]= preprocessing()
    importdata;
    %% labels
    labels=Class;
    
    %% features
    % Age
    features=Age;

    % Sex
    subf=zeros(0,0);
    for i=1:size(Sex,1)
        if  isequal(Sex{i},'female')
           subf(i,:)=0;
        end
        if  isequal(Sex{i},'male')
           subf(i,:)=1;
        end
    end
    features=[features,subf];

    % Job
    features=[features,Job];

    
    % Housing
    subf=zeros(0,0);
    for i=1:size(Housing,1)
        if  isequal(Housing{i},'free')
            subf(i,:)=[1,0,0];
        end
        if  isequal(Housing{i},'rent')
            subf(i,:)=[0,1,0];
        end
        if  isequal(Housing{i},'own')
            subf(i,:)=[0,0,1];
        end
    end
    features=[features,subf];
    
    % Savingaccounts
    subf=zeros(0,0);
    for i=1:size(Savingaccounts,1)
        if  isequal(Savingaccounts{i},'NA')
            subf(i,:)=-1;
        end
        if  isequal(Savingaccounts{i},'little')
            subf(i,:)=0;
        end
        if  isequal(Savingaccounts{i},'moderate')
            subf(i,:)=1;
        end
        if  isequal(Savingaccounts{i},'rich')
            subf(i,:)=2;
        end
        if  isequal(Savingaccounts{i},'quite rich')
            subf(i,:)=3;
        end
    end
    features=[features,subf];

    % Checkingaccount
    subf=zeros(0,0);
    for i=1:size(Checkingaccount,1)
        if  isequal(Checkingaccount{i},'NA')
            subf(i,:)=-1;
        end
        if  isequal(Checkingaccount{i},'little')
            subf(i,:)=0;
        end
        if  isequal(Checkingaccount{i},'moderate')
            subf(i,:)=1;
        end
        if  isequal(Checkingaccount{i},'rich')
            subf(i,:)=2;
        end
        if  isequal(Checkingaccount{i},'quite rich')
            subf(i,:)=3;
        end
    end
    features=[features,subf];

    % Creditamount
    features=[features,Creditamount];

    % Duration
    features=[features,Duration];

    % Purpose
    subf=zeros(0,0);
    for i=1:size(Purpose,1)
        if  isequal(Purpose{i},'business')
            subf(i,:)=[1,0,0,0,0,0,0,0];
        end
        if  isequal(Purpose{i},'car')
            subf(i,:)=[0,1,0,0,0,0,0,0];
        end
        if  isequal(Purpose{i},'domestic appliances')
            subf(i,:)=[0,0,1,0,0,0,0,0];
        end
        if  isequal(Purpose{i},'education')
            subf(i,:)=[0,0,0,1,0,0,0,0];
        end
        if  isequal(Purpose{i},'furniture/equipment')
            subf(i,:)=[0,0,0,0,1,0,0,0];
        end
        if  isequal(Purpose{i},'radio/TV')
            subf(i,:)=[0,0,0,0,0,1,0,0];
        end
        if  isequal(Purpose{i},'repairs')
            subf(i,:)=[0,0,0,0,0,0,1,0];
        end
        if  isequal(Purpose{i},'vacation/others')
            subf(i,:)=[0,0,0,0,0,0,0,1];
        end
    end
    features=[features,subf];
    
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



