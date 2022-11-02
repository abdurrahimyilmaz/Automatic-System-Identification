clc; clear all; 

% Actual Transfer Function 
num1 = [11.25];
den1 = [8 115 13];


% Simulation Configuration
startTime = '0';   %Starting 0 sec.
stepSize = '1e-3'; %1e-3 sec
outputInit = sim('init', 'StartTime', startTime, 'StopTime', '5', 'FixedStep', stepSize);


% Actual Transfer Function Output
t = outputInit.t; 
ref = outputInit.refSignal;
output = outputInit.outSignal;


% System Identification Configuration
data = iddata(output, ref, str2num(stepSize), 'Tstart', str2num(startTime)); %#ok<ST2NM>
opt = tfestOptions;
opt.InitializeMethod = 'iv';
opt.InitialCondition = 'zero';
opt.InitializeOptions.MaxIterations = 30;
% 'iv'    — Instrument Variable approach.
% 'svf'   — State Variable Filters approach.
% 'gpmf'  — Generalized Poisson Moment Functions approach.
% 'n4sid' — Subspace state-space estimation approach.
% 'all'   — Combination of all of the preceding approaches. 


% Desired Transfer Function as 
%           data, NP, NZ, opt
maxzero = 5
maxpole = 5
bestzeropole = []
i = 1

for pole = 1:maxpole
    for zero = pole:maxzero
        SYS = tfest(data, zero, pole, opt); 
        fittingAcc = SYS.Report.Fit.FitPercent;  %Goodness of estimation fitting.
        
        if fittingAcc > 95
            bestzeropole(i,:) = [zero pole];             
            i = i+1;
        end
    end
end

% System Identification Output
num = SYS.Numerator;
den = SYS.Denominator;
Gest = tf(num, den);  %TRANSFER FUNCTION


% Simulation Configuration
outputSYS = sim('sysout', 'StartTime', startTime, 'StopTime', '5', 'FixedStep', stepSize);


% RESULTS                 
tSYS = outputSYS.tout;                 
outSYS = outputSYS.actSYS;
estSYS = outputSYS.estSYS;


% FIGURE
myPlot(tSYS, outSYS, estSYS, 'Time [s]', 'Amplititude', 'Actual', 'Estimate')