% Qilin You 2017/03/11
% example:[dfeature,dlabel]=Partition(feature,label,foldnum)
function [dfeature,dlabel]=Partition(feature,label,foldnum)
numclass=size(unique(label),1);
dfeature=zeros(1,size(feature,2),foldnum);dlabel=zeros(1,1,foldnum);
for i=1:numclass
    subdata=feature((find(label==i)),:);sublabel=label((find(label==i)),:);
    bsize=size(subdata,1);rbsize=bsize;
    for m=1:foldnum
    %divide into bins
    for numpick=1:bsize/foldnum
    randpick=unidrnd(rbsize); %generate random index
    for col=1:size(subdata,2)
    dfeature(size(find(dlabel(:,1,m)~=0),1)+1,col,m)=subdata(randpick,col);%store feature
    end
    dlabel(size(find(dlabel(:,1,m)~=0),1)+1,1,m)=sublabel(randpick,1);%store label
    subdata(randpick,:)=[]; sublabel(randpick,:)=[]; %remove picked data
    rbsize=rbsize-1; %record the rest data
    end 
    end
    %divide the rest data
    for m=1:mod(bsize,foldnum)
    randpick=unidrnd(rbsize); %generate random index
    for col=1:size(subdata,2)
    dfeature(size(find(dlabel(:,1,m)~=0),1)+1,col,m)=subdata(randpick,col);%store feature
    end
    dlabel(size(find(dlabel(:,1,m)~=0),1)+1,1,m)=sublabel(randpick,1);%store label
    subdata(randpick,:)=[]; sublabel(randpick,:)=[]; %remove picked data
    rbsize=rbsize-1;    
    end    
end

end