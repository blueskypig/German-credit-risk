function [features,labels]= preprocessing2()
% Author: Qilin You
%Usage: [features,labels]= preprocessing()
    importdata2;
    %% labels
    labels=Class;

    %% features
    features=zeros(1000,20);
    
    % Status of existing checking account
    features(:,1)=mod(A1,10);

    % Duration in month
    features(:,2)=A2;
    
    % Credit history
    features(:,3)=mod(A3,10);
    
    % Purpose
    for index=1:size(A4,1)
        if A4(index)<100
            features(index,4)=mod(A4(index),10);
        else
            features(index,4)=10;
        end
    end
   
    
    % Credit amount
    features(:,5)=A5;
    
    % Savings account/bounds
    features(:,6)=mod(A6,10);
    
    % Present employment since
    features(:,7)=mod(A7,10);
    
    % Installment rate in percentage of disposable income
    features(:,8)=A8;
    
    % Personal status and sex
    features(:,9)=mod(A9,10);
    
    % Other debtors/guarantors
    features(:,10)=mod(A10,10);
    
    % present residence since
    features(:,11)=A11;
    
    % Property
    features(:,12)=mod(A12,10);
    
    % Age in years
    features(:,13)=A13;
    
    % Ohter installment plans
    features(:,14)=mod(A14,10);
    
    % Housing
    features(:,15)=mod(A15,10);
    
    % Number of existing credits at this bank
    features(:,16)=A16;
    
    % Job
    features(:,17)=mod(A17,10);
    
    % Number of people being liable to provide
    features(:,18)=A18;
    
    % Telephone
    features(:,19)=mod(A19,10);
    
    % foreign worker
    features(:,20)=mod(A20,10);

%% Handle missing data
%% drop out invalid data
    fstd=std(features);
    features(:,find(fstd==0))=[];
end


