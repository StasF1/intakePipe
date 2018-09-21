% Data of intake pipe & gas 

%% Directories

% Path to inlet pressures file
pathToDataVer1 =...
    '~/Downloads/intakePipe-master/version1/inletPatchPressures.txt';
% pathToDataVer2 =...
%     '~/Downloads/intakePipe-master/version2/inletPatchPressures.txt';
% pathToDataVer3 =...
%     '~/Downloads/intakePipe-master/version3/inletPatchPressures.txt';

% Path to save the results (to save to the current folder set 0)
pathToSave = 0; %'~/Downloads/intakePipe/Results/';

%% Boundary conditions
F_inlet = 0.000840365; % square metres, version one
u_Ver1 = 15; % m/s, inlet speed for version one
u_Ver2 = 12.1409; % m/s, inlet speed for version two
u_Ver3 = 9.9852; % m/s, inlet speed for version three

%% Intake air/gas
ro_gas = 1.205; % kg/m^3
p_atm = 101325; % Pa, atmospheric pressure

%% Stroke
strokeStart = 3; % mm, initial valve stroke
strokeEnd = 14; % mm, final valve stroke
strokeDelta = 1; % mm, stroke step

%% Pipe geometry
d_pipe = 25.688; % mm, the minimum diameter of intake pipe
d_2Pipe = 29.756; % mm, chamfer diameter of valve neck

%% Valve geometry
d_bar = 6.96; % mm, bar diameter
d_1 = 26.782; % mm, valve diameter
d_2 = 29.206; % mm, head valve diameter
teta = 45; % chamfer angle




