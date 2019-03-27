function cosData = cosinorRhymometry(subject, tau)
% 
% Overview
%   Uses code by Casey Cox for Cosinor Rhymometry analysis
%     
% Input
%   subject: Struct that contains data for all subjects. Has field
%   activity. Activity should be in 30 second epoch format.
%   tau: Length of period
%
% Output
%   cosData: Struct with fields mesor, amplitude and acrophase.
%
% Reference(s)
%   https://www.mathworks.com/matlabcentral/fileexchange/20329-cosinor-analysis
%   
%
cosData = struct;
for i = 1:length(subject) 
    act = subject(i).activity;
    time = 0:30:(length(subject(i).activity) -1) * 30;
    idx = isnan(act);
    act(idx) = [];
    time(idx) = [];

    % Resample
    ts = timeseries(act, time);
    ts1 = resample(ts, 0:60:round(time(end)/60)*60);
    ts1.time = ts1.time / (60*60); % Convert from seconds to hours

    % Define cycle length and alpha
    w = 2*pi/tau;
    alpha = .05;
    
    y2 = ts1.data;
    t2 = ts1.time;
    t2(isnan(y2)) = []; y2(isnan(y2)) = []; 
    y2(isnan(t2)) = []; t2(isnan(t2)) = [];
    
    % Cosinor rhymometry
    [M,Amp,phi] = cosinor(t2, y2, w, alpha);
    cosData(i).mesor = M;
    cosData(i).amplitude = Amp;
    cosData(i).acrophase = phi;
end

end