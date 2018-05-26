function [ feature ] = normalize(infeature,fmean,fstd)
%normalize
    for n=1:size(infeature,2)
    feature(:,n)=infeature(:,n)-fmean(n);
    if fstd~=0
    feature(:,n)=feature(:,n)/fstd(n);
    end
    end   
end

