function r24 = autocorrelationCoeff(subject)
% 
% Overview
%     
% Input
%   inputVar
%
% Output
%   outputVar
%
% Dependencies
%   https://github.com/cliffordlab/
%
% Reference(s)
%   Mormont, M.C., Waterhouse, J., Bleuzen, P., Giacchetti, S., Jami, A., 
%   Bogdan, A., Lellouch, J., Misset, J.L., Touitou, Y. and Lévi, F., 2000. 
%   Marked 24-h rest/activity rhythms are associated with better quality of 
%   life, better response, and longer survival in patients with metastatic 
%   colorectal cancer and good performance status. Clinical Cancer Research, 
%   6(8), pp.3038-3045.
%
% Authors
%   Ayse Cakmak <acakmak3@gatech.edu>
% 
% Copyright (C) 2018 Authors, all rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license. See the LICENSE file in this repo for details.
%

r24 = zeros(length(subject),1);
for i = 1:length(subject) 
    for n = 24 % n = 1:1:48
        k = n * 60 * 60 / 30; % Calculating r24

        Xcur = subject(i).activity;
        Xlagged =  Xcur(k:end);
        Xcur = Xcur(1:length(Xlagged));

        A = [Xcur Xlagged];

        R = corrcoef(A, 'rows','complete');
        r24(i) = R(1,2); % r24(n) = R(1,2);
    end
end

%{
% Plotting
color = loadGoogleColors();
plot(1:1:48, r24, 'o', 'MarkerFaceColor', color.blue);
hold on;
plot(24, r24(24), 'o', 'MarkerFaceColor', color.red);
set(gcf,'color','w');
set(gca,'FontSize',18)
xlabel('Hours')
%}

end