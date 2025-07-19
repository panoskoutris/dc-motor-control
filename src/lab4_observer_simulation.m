% The input setpoint is in Volts and can vary from 0 to 10 Volts because the position pot is refered to GND
V_7805=5.48;
Vref_arduino=5;

if ~exist('a','var')    
    a= arduino;   
end

% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR  %
writePWMVoltage(a, 'D6', 0)
writePWMVoltage(a, 'D9', 0)

% Initialization of arrays
positionData = [];
est_positionData = [];
velocityData = [];
est_velocityData = [];
timeData = [];
t=0;

% CLOSE ALL PREVIOUS FIGURES FROM SCREEN
close all

% WAIT A KEY TO PROCEED
disp(['Connect cable from Arduino to Input Power Amplifier and then press enter to start controller']);
pause()



% START CLOCK
tic


while(t<5)
    
    position = readVoltage(a, 'A5'); % position
    velocity = readVoltage(a,'A3'); % velocity
    theta = 3 * Vref_arduino * position / 5;
    vtacho = 2 * (2 * velocity * Vref_arduino / 5 - V_7805);
 
   
lamda1 = 10; lamda2 = 10;        

p1 = lamda1 + lamda2;  
p2 = lamda1*lamda2; 

l1 = p1 - 0.94;
l2 = -p1 + 1.94 + 0.53*p2;
 
% Estimated values 
   if t==0
        est_theta_dot = -l1*theta + 1.86*vtacho + l1*theta ;  
        est_vtacho_dot = -l2*theta - 1.94*vtacho + 11.2 + l2*theta;  
        est_theta = theta + est_theta_dot*toc;
        est_vtacho = vtacho + est_vtacho_dot*toc;
    else
        est_theta_dot = -l1*est_positionData(end) + 1.86*est_velocityData(end) + l1*theta; 
        est_theta = est_positionData(end) + est_theta_dot*( toc - timeData(end) );
        est_vtacho_dot = -l2*est_positionData(end) - 1.94*est_velocityData(end) + 11.2 + l2*theta; 
        est_vtacho = est_velocityData(end) + est_vtacho_dot*( toc - timeData(end) );
    end

    

 % We set u as 7
 u = 7;
 
if u > 0
    writePWMVoltage(a, 'D6', 0); 
    writePWMVoltage(a, 'D9', min(abs(u) / 2, 5)); 
else         
    writePWMVoltage(a, 'D9', 0);
    writePWMVoltage(a, 'D6', min(abs(u) / 2, 5));   
end


t=toc;

    
timeData = [timeData t];
positionData = [positionData theta];
velocityData = [velocityData vtacho];
est_positionData = [est_positionData est_theta];
est_velocityData = [est_velocityData est_vtacho];
end

% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR  %
writePWMVoltage(a, 'D6', 0) %before
writePWMVoltage(a, 'D9', 0) %before



disp(['End of control Loop. Press enter to see diagramms']);
pause();


figure
plot(timeData,positionData);
title('position')

figure
plot(timeData,velocityData);
title('velocity')

figure
yline(u,"LineWidth",2);
title('controller')

figure
plot(timeData,positionData);
title('real vs estimated position')
hold on
plot(timeData,est_positionData);
hold off;

figure
plot(timeData,velocityData);
title('real vs estimated velocity')
hold on
plot(timeData,est_velocityData);
hold off;


disp('Disonnect cable from Arduino to Input Power Amplifier and then press enter to stop controller');
pause();
