function [features,labels]= preprocessing2_expanded()
% Author: Qilin You
%Usage: [features,labels]= preprocessing()
    importdata2;
    %% labels
    labels=Class;

    %% features
    
    % Status of existing checking account
    features=mod(A1,10);
%     features(find(features(:,end)==4))=3;
    
    % Duration in month
    features=[features,A2];
    
    % Credit history
    features=[features,mod(A3,10)];
%     features(find(features(:,end)==1))=0;
%     features(find(features(:,end)==2))=1;
%     features(find(features(:,end)==3))=2;
%     features(find(features(:,end)==4))=2;
    
    % Purpose
    subf=zeros(0,0);
    for i=1:size(A4,1)
        if  A4(i)==40
            subf(i,:)=[1,0,0,0,0,0,0,0,0,0,0];
        end
        if  A4(i)==41
            subf(i,:)=[0,1,0,0,0,0,0,0,0,0,0];
        end
        if  A4(i)==42
            subf(i,:)=[0,0,1,0,0,0,0,0,0,0,0];
        end
        if  A4(i)==43
            subf(i,:)=[0,0,0,1,0,0,0,0,0,0,0];
        end
        if  A4(i)==44
            subf(i,:)=[0,0,0,0,1,0,0,0,0,0,0];
        end
        if  A4(i)==45
            subf(i,:)=[0,0,0,0,0,1,0,0,0,0,0];
        end
        if  A4(i)==46
            subf(i,:)=[0,0,0,0,0,0,1,0,0,0,0];
        end
        if  A4(i)==47
            subf(i,:)=[0,0,0,0,0,0,0,1,0,0,0];
        end
        if  A4(i)==48
            subf(i,:)=[0,0,0,0,0,0,0,0,1,0,0];
        end
        if  A4(i)==49
            subf(i,:)=[0,0,0,0,0,0,0,0,0,1,0];
        end
        if  A4(i)==410
            subf(i,:)=[0,0,0,0,0,0,0,0,0,0,1];
        end
    end
    features=[features,subf];
    
    % Credit amount
    features=[features,A5];
    
    % Savings account/bounds
    features=[features,mod(A6,10)];
%     features(find(features(:,end)==4))=3;
%     features(find(features(:,end)==5))=4;
    
    % Present employment since
    features=[features,mod(A7,10)];
%     features(find(features(:,end)==2))=1;
    
    % Installment rate in percentage of disposable income
    features=[features,A8];
    
    % Personal status and sex
    subf=zeros(0,0);
    for i=1:size(A9,1)
        if  A9(i)==91
            subf(i,:)=[1,0,0,0,0];
        end
        if  A9(i)==92
            subf(i,:)=[0,1,0,0,0];
        end
        if  A9(i)==93
            subf(i,:)=[0,0,1,0,0];
        end
        if  A9(i)==94
            subf(i,:)=[0,0,0,1,0];
        end
        if  A9(i)==95
            subf(i,:)=[0,0,0,0,1];
        end
    end
    features=[features,subf];
    
    % Other debtors/guarantors
    features=[features,mod(A10,10)];
%     features(find(features(:,end)==3))=2;
    
    % present residence since
    features=[features,A11];
    
    % Property
    features=[features,5-mod(A12,10)];
    
    % Age in years
    features=[features,A13];
    
    % Other installment plans
    subf=zeros(0,0);
    for i=1:size(A14,1)
        if  A14(i)==141
            subf(i,:)=[1,0,0];
        end
        if  A14(i)==142
            subf(i,:)=[0,1,0];
        end
        if  A14(i)==143
            subf(i,:)=[0,0,1];
        end
    end
    features=[features,subf];
    
    % Housing
    subf=zeros(0,0);
    for i=1:size(A15,1)
        if  A15(i)==151
            subf(i,:)=[1,0,0];
        end
        if  A15(i)==152
            subf(i,:)=[0,1,0];
        end
        if  A15(i)==153
            subf(i,:)=[0,0,1];
        end
    end
    features=[features,subf];
    
    % Number of existingcredits at this bank
    features=[features,A16];
%     features(find(features(:,end)==3))=2;
%     features(find(features(:,end)==4))=2;
    
    % Job
    features=[features,mod(A17,10)];
%     features(find(features(:,end)==2))=1;
    
    % Number of people being liable to provide
    features=[features,A18];
    
    % Telephone
    features=[features,mod(A19,10)];
    
    % foreign worker
    features=[features,mod(A20,10)];

%% Handle missing data
%% drop out invalid data
    fstd=std(features);
    features(:,find(fstd==0))=[];
end


