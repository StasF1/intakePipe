% Calculates flow coefficient for different valve strokes
projectFolder = pwd;
flowCoefDict;

%% Initialising arrays
h = ((strokeStart:strokeDelta:strokeEnd)*1e-03).';
f_valve = zeros(length(h), 1);      p_delta = zeros(length(h), 1);

mufVer1 = zeros(length(h), 1);
mufVer2 = zeros(length(h), 1);
mufVer3 = zeros(length(h), 1);

%% Precalculations
% Converting data to metres from sectorAngleDict.m
d_pipe = d_pipe*1e-03;		d_2Pipe = d_2Pipe*1e-03;
d_1 = d_1*1e-03;			d_2 = d_2*1e-03;            d_bar = d_bar*1e-03;

for i = 1:length(numberOfProjects)
    p_inletVer1 = importdata( pathToDataVer1 ); % m^2/s^2, importing data for version one
    p_inletVer2 = importdata( pathToDataVer2 ); % m^2/s^2, importing data for version two
    p_inletVer3 = importdata( pathToDataVer3 ); % m^2/s^2, importing data for version three
end

%% Calculating minimal area of intake
fid = fopen('cutNumberForStroke.log', 'w'); fprintf(fid, 'Stroke, mm       Cut №\n');

h_crI = (d_pipe - d_1)/sind(2*teta);      h_crII = (d_2Pipe - d_1)/sind(2*teta);

% Critiacal area, min area is placed in the pipe
f_critical = pi*power(d_pipe, 2)/4 - pi*power(d_bar, 2)/4;
for i = 1:length(h)
	if h(i) <= h_crI  % cut I
		f_valve(i) = pi*h(i)*cosd(teta)*( d_pipe - h(i)*sind(teta)*cosd(teta) );
        fprintf(fid, '%10.0f           I\n', h(i)*1e+03);
        
    elseif h(i) > h_crI && h(i) <= h_crII % cut II
		f_valve(i) = pi*h(i)*cosd(teta)*( d_1 + h(i)*sind(teta)*cosd(teta) );
        fprintf(fid, '%10.0f          II\n', h(i)*1e+03);
        
	else % cut III
		f_valve(i) = pi/4*(d_2Pipe + d_1)*sqrt(  power(d_2Pipe - d_1, 2)...
            + power(2*h(i) - (d_2Pipe - d_1)*tand(teta), 2) );
        fprintf(fid, '%10.0f         III\n', h(i)*1e+03);
        
    end
	
	if f_valve(i) > f_critical
		f_valve(i) = f_critical;
		
    end
    
end

%% Calculating flow coefficients
G = ro_gas*F_inlet*u_Ver1;

muVer1 = flowCoef(u_Ver1, G, h, f_valve, p_inletVer1);
muVer2 = flowCoef(u_Ver2, G, h, f_valve, p_inletVer2);
muVer3 = flowCoef(u_Ver2, G, h, f_valve, p_inletVer3);

for i = 1:length(h)
    mufVer1(i) = muVer1(i)*f_valve(i);
    mufVer2(i) = muVer2(i)*f_valve(i);
    mufVer3(i) = muVer3(i)*f_valve(i);
end

%% Displaing the results
figure; plot(h*1e+03, f_valve*1e+04, 'LineWidth', 5); grid on;
xlabel('h, mm'); ylabel('f_к_л, cm^2'); set(gca,'fontsize', 20);
saveas(gcf, 'valveArea.png');

figure; hold on;
plot(h*1e+03, p_inletVer1.data(:,2)*ro_gas*1e-03, 'LineWidth', 5); grid on;
plot(h*1e+03, p_inletVer2.data(:,2)*ro_gas*1e-03, 'g', 'LineWidth', 5);
plot(h*1e+03, p_inletVer3.data(:,2)*ro_gas*1e-03, 'r', 'LineWidth', 5);
xlabel('h, mm'); ylabel('p_i_n_l_e_t, kPa'); set(gca,'fontsize', 20);
ylim([0, max(p_inletVer1.data(:,2))*ro_gas*1e-03]+0.5);
legend('Version 1', 'Version 2', 'Version 3');
saveas(gcf, 'p_inlet.png');

figure; hold on;
plot(h/d_pipe, muVer1, 'LineWidth', 5); grid on;
plot(h/d_pipe, muVer2, 'g', 'LineWidth', 5);
plot(h/d_pipe, muVer3, 'r', 'LineWidth', 5);
xlabel('h/d_г'); ylabel('\mu'); set(gca,'fontsize', 20);
legend('Version 1', 'Version 2', 'Version 3');
saveas(gcf, 'mu.png');

figure; hold on;
plot(h/d_pipe, mufVer1*1e+04, 'LineWidth', 5); grid on;
plot(h/d_pipe, mufVer2*1e+04, 'g', 'LineWidth', 5);
plot(h/d_pipe, mufVer3*1e+04, 'r', 'LineWidth', 5);
xlabel('h/d_г'); ylabel('\muf, cm^2'); set(gca,'fontsize', 20);
ylim([0, max(mufVer3)*1e+04]+0.1);
legend('Version 1', 'Version 2', 'Version 3', 'Location', 'southeast'); 
saveas(gcf, 'muf.png');

fclose(fid); type('cutNumberForStroke.log');

%% Moving results to the results folder
if isa(pathToSave, 'double') == 1 % Saving the results to the folder in current directory
    mkdir flowCoefficient.Results;
    copyfile('flowCoefDict.m', 'flowCoefficient.Results/');
    movefile('p_inlet.png', 'flowCoefficient.Results/');
    movefile('valveArea.png', 'flowCoefficient.Results/');
    movefile('muf.png', 'flowCoefficient.Results/');
    movefile('mu.png', 'flowCoefficient.Results/');
    movefile('cutNumberForStroke.log', 'flowCoefficient.Results/');
    
else % Saving the results to the folder in setted directory
    copyfile('flowCoefDict.m', pathToSave);
    movefile('p_inlet.png', pathToSave);
    movefile('valveArea.png', pathToSave);
    movefile('muf.png', pathToSave);
    movefile('mu.png', pathToSave);
    movefile('cutNumberForStroke.log', pathToSave);
    
    cd(pathToSave); mkdir('flowCoefficient.Results');
    movefile('flowCoefDict.m', 'flowCoefficient.Results/');
    movefile('p_inlet.png', 'flowCoefficient.Results/');
    movefile('valveArea.png', 'flowCoefficient.Results/');
    movefile('muf.png', 'flowCoefficient.Results/');
    movefile('mu.png', 'flowCoefficient.Results/');
    movefile('cutNumberForStroke.log', 'flowCoefficient.Results/');
    
    cd(projectFolder);

end

%%
clear; %clc;
