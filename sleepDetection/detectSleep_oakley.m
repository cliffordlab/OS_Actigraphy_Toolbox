function A = detectSleep_oakley(epoch, threshold)
%
%   Overview
%       Using Oakley algorithm on activity epochs to detect sleep 
%
%   Input
%       epoch: a vector that contains epochs of activity count
%       threshold: Actiwatch has 3 settings: 20, 40 or 80
%
%   References
%       [1] Borazio, Marko, et al. "Towards benchmarked sleep detection with 
%       wrist-worn sensing units." Healthcare Informatics (ICHI), 2014 IEEE 
%       International Conference on. IEEE, 2014.
%

j = 1;
epoch = epoch(:); %Ensure it is a vector, otherwise it throws an error
epoch =[nan; nan; epoch; nan; nan];
for i = 3:length(epoch)-2
    A(j) = 0.04*epoch(i-2)+0.2*epoch(i-1)+2*epoch(i)...
        +0.2*epoch(i+1)+0.04*epoch(i+2);
    j = j+1;
end

A(A <= threshold) = 0;
A(A > threshold) = 1;
A = A(:);

end

