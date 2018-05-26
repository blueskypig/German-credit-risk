function [bdata,blabels,sdata,slabels]=redistribution(ddata,dlabels,i,sflag)
% number of fold
foldnum=size(ddata,3);
% data
bdata=zeros(0,0);blabels=zeros(0,0);
sdata=zeros(0,0); slabels=zeros(0,0);   
% small bin
sdata=ddata(find(dlabels(:,1,i)~=0),:,i);slabels=dlabels(find(dlabels(:,1,i)~=0),:,i);
% big bins
for j=1:foldnum
    if j~=i
    bdata=cat(1,bdata,ddata(find(dlabels(:,1,j)~=0),:,j)); blabels=cat(1,blabels,dlabels(find(dlabels(:,1,j)~=0),:,j));
    end
end
if sflag
    % shuffle data
    % small bin
    oldt=[sdata,slabels];
    newt=oldt(randperm(size(oldt,1)),:);
    slabels=newt(:,end);
    newt(:,end)=[];
    sdata=newt;
    % big bin
    oldt=[bdata,blabels];
    newt=oldt(randperm(size(oldt,1)),:);
    blabels=newt(:,end);
    newt(:,end)=[];
    bdata=newt;
end 
end