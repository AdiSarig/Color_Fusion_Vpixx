
function [Fitted_Curve]=gabor_fit_fun(params,Input) 
% ,Actual_Output)
%
%
%
    
    Fitted_Curve = sigmoid(params,Input);

%     Error_Vector=(Fitted_Curve - Actual_Output); %.*log([1:length(Fitted_Curve)]);
% 
%     % add to the error if A > 1 or A < 0
%     sse=sum(Error_Vector.^2);
% 

end