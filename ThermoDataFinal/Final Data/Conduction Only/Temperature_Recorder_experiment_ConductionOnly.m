clear all
clc

RUNTIME_SECS = 3600*12;
MAX_TEMP = 120;
X_AXIS_LABEL = 'Time(s)';
Y0_AXIS_LABEL = 'TA(C)'; %end of rod
Y1_AXIS_LABEL = 'TB(C)'; %8cm from A
Y2_AXIS_LABEL = 'TC(C)'; %15cm from A
Y3_AXIS_LABEL = 'TD(C)'; %23cm from A
Y4_AXIS_LABEL = 'TE(C)'; %inside of box
Y5_AXIS_LABEL = 'Ambient(C)';

Y0_CHAN = 4;
Y1_CHAN = 0;
Y2_CHAN = 1;
Y3_CHAN = 2;
Y4_CHAN = 3;
Y5_CHAN = 5;

GATE_SWITCH_CHAN = 7;

a = arduino('COM9');
a.pinMode(GATE_SWITCH_CHAN, 'output');
c = clock;
date = sprintf('%d-%02d-%02d [%02d][%02d][%02.0f]', c(1),c(2),c(3),c(4),c(5),c(6));
fileID = fopen(sprintf('%s\\%s.txt', pwd,date), 'w');

figure
hold on
grid on;

disp('Starting collecting data...')
fprintf(fileID,'%12s %12s %12s %12s %12s %12s %12s\r\n', X_AXIS_LABEL,Y0_AXIS_LABEL,Y1_AXIS_LABEL,Y2_AXIS_LABEL,Y3_AXIS_LABEL,Y4_AXIS_LABEL,Y5_AXIS_LABEL);
t0=tic;
while(toc(t0) < RUNTIME_SECS)
%     powerR = (a.analogRead(POWER_R_CHAN)-34.7163)/6.5296;
%     TB = (a.analogRead(Y1_CHAN)-44.217)/6.5713;
%     TC = (a.analogRead(Y2_CHAN)-26.617)/6.9282;
%     TD = (a.analogRead(Y3_CHAN)-37.431)/6.7412;
%     TE = (a.analogRead(Y4_CHAN)-34.512)/6.6479;
%     ambientT = 22.5 + (a.analogRead(Y5_CHAN)-570.0)/20.0;

    TA = a.analogRead(Y0_CHAN);
    TB = a.analogRead(Y1_CHAN);
    TC = a.analogRead(Y2_CHAN);
    TD = a.analogRead(Y3_CHAN);
    TE = a.analogRead(Y4_CHAN);
    ambientT = a.analogRead(Y5_CHAN);
    
    %control temp
    if((TA*0.146201+1.527752) > MAX_TEMP)
       a.digitalWrite(GATE_SWITCH_CHAN, 0);
    else
       a.digitalWrite(GATE_SWITCH_CHAN, 1);
    end
    
    x = toc(t0);
    fprintf(fileID,'%12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f\r\n', x,TA,TB,TC,TD,TE,ambientT);
    
    disp('Ambient temp:');
    disp(ambientT);
    
    disp('Sensor A temp:');
    disp(TA);
    fprintf('Converted: %f\n', TA*0.146201+1.527752);
    plot(x,TA, '.r')
    
    disp('Sensor B temp:');
    disp(TB);
    plot(x,TB, '.g')
    
    disp('Sensor C temp:');
    disp(TC);
    plot(x,TC, '.k')
    
    disp('Sensor D temp:');
    disp(TD);
    plot(x,TD, '.y')
    
    disp('Sensor E temp:');
    disp(TE);
    plot(x,TE, '.')
    pause(1);
    drawnow;
end
disp('Done collecting data.');

disp('Saving results to file...')
fclose(fileID);
disp('Done saving.');

disp('END');