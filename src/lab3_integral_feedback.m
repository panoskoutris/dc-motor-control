% Set the desired position
des_pos = 5;

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
velocityData = [];
uData = [];
timeData = [];
zData = [];
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


    z_dot = theta - des_pos; %derivative of z
    if t==0
        z = z_dot*toc;
    else    
        z = zData(end) + z_dot*( toc - timeData(end) );
    end
    

    k1 = 0.28; k2 = 1; kz = 1; %a
    k1 = 4.5; k2 = 1; kz = 4.5; %b
     

 %My Controllers  
 u = -k1*theta -k2*vtacho -kz*z; 
 

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
uData = [uData u];
zData = [zData z];

end

% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR  %
writePWMVoltage(a, 'D6', 0)
writePWMVoltage(a, 'D9', 0)



disp(['End of control Loop. Press enter to see diagramms']);
pause();


figure
plot(timeData,positionData);
title('position')

figure
plot(timeData,velocityData);
title('velocity')

figure
plot(timeData,uData);
title('controller')

figure
plot(timeData,positionData);
title('current vs desirable position')
hold on
yline(des_pos,"LineWidth",2);
hold off;

figure
plot(timeData,zData);
title('z')


disp('Disonnect cable from Arduino to Input Power Amplifier and then press enter to stop controller');
pause();
