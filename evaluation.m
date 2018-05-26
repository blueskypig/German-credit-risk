function [accuracy,F_measure]=evaluation(pred_labels,vlabels)
accuracy=size(find(pred_labels==vlabels),1)/(size(vlabels,1));
C=confusionmat(vlabels,pred_labels);
precision=diag(C)./sum(C,2);
recall=diag(C)./sum(C,1)';
F_measure=2*(precision.*recall)./(precision+recall);
end