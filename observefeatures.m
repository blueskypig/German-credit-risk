clear;clc;close all;
[features,labels]=preprocessing2;
x=features(:,9)';y=labels';
content=unique(x);
y1=zeros(1,size(content,2));
y2=y1;y=y1;
for i=1:size(content,2)
    tmp=labels(find(x==content(i)));
    y1(i)=size(find(tmp==1),1);
    y2(i)=size(find(tmp==2),1);
    y(i)=size(tmp==2,1);
end
% hold on
% stem(y1/700,'go');
% stem(-y2/300,'rx');
% hold off
y/10