function G = ConvectionRadiationSim(V,E)

PRINT = true;

CONVECTION = true;
RADIATION  = true;

timeStep = 0.01;
runTime = 3600 * 0.1;                             %[s]
v = V;
e = E;
sigma = 5.67*10^(-8);
ICE_TEMP = 0;                                 %[C]
STARTING_ROD_TEMP = ICE_TEMP;                  %[C]
length = 0.3048;                                %[m]
R = 0.0111;                                     %[m]
A_surface = 2*pi*R*length;                      %[m^2]
A_cross = pi*R^2;                               %[m^2]
density = 2737.7;                               %[kg m^-3]
c = 902;
C = c * length* A_cross*density;
ZERO_HEAT_THRESHOLD = 10^-6;                    %[W]
ZERO_TEMP_CHANGE_THRESHOLD = 10^-9;             %[K]

numSteps = runTime / timeStep;
x = linspace(0, runTime, numSteps)';
Y = zeros(numSteps);
timeEQ = -1;

for j=1:numSteps
    temp = 0;
    if(CONVECTION)
%             V*A_surface*
        dQinC = v * A_surface * timeStep * (23 - temp);
    end
    
    if(RADIATION)
        dQoutR = e * sigma * timeStep * A_surface * ((temp+273)^4);
    end     
        %add heat to increase temperature
    temp = temp + (dQinC - dQoutR)/(C);
    Y(j) = temp
        %update element's temperature        
end

if(PRINT)
    figure
    hold on;
    plot(x, Y, 'r-');

    title('Aluminum Rod Convection and Radiation');
    xlabel('Time (sec)');
    ylabel('Temperature (^oC)');
    yLimit = ylim;
    xLimit = xlim;
    text(xLimit(2)-(xLimit(2)-xLimit(1))/100,yLimit(1) + (yLimit(2)-yLimit(1))/100,sprintf('@End\nLeft Temp: %f ^oC\nRight Temp: %f ^oC\nRight dQ/dt: %f W\n@EQ\nTime to EQ: %f s\n8cm Temp: %f ^oC\n15cm Temp: %f ^oC\n23cm Temp: %f ^oC', Y(end,1), Y(end,end), dQdt, timeEQ, Y(timeEQ/timeStep,eightMark), Y(timeEQ/timeStep,fifteenMark), Y(timeEQ/timeStep,twentyThreeMark)), 'HorizontalAlignment','right', 'VerticalAlignment','bottom', 'EdgeColor','black','LineWidth',1, 'BackgroundColor','white');
    grid on;
    hold off;
end

G=Y;
end
