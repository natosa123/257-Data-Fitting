function G = AluminumRodHeaterSimulation(PoverC,k)

print = false;

CONDUCTION = true;
CONVECTION = false;
RADIATION  = false;

timeStep = 0.01;
runTime = 3600 * 3;                             %[s]

ROOM_TEMP = 22;                                 %[C]
numElements = 30;
STARTING_ROD_TEMP = ROOM_TEMP;                  %[C]
temps = ones(numElements, 1)*STARTING_ROD_TEMP; %[C]
length = 0.3048;                                %[m]
deltaX = length / numElements;                  %[m]
% K = 180;                                        %[W m^-1 K^-1]
K = k;                                        %[W m^-1 K^-1]
R = 0.0111;                                     %[m]
A_cross = pi*R^2;                               %[m^2]
A_surface = 2*pi*R*length;                      %[m^2]
% c = 902;                                        %[J kg^-1 K^-1]
c = PoverC;             %actually C over P                           %[J kg^-1 K^-1]
density = 2737.7;                               %[kg m^-3]
C = c * deltaX * A_cross * density;             %[J K^-1]
POWER_INPUT = 11^2/15.3;                        %[W]
HEAT_SINK_TEMP = STARTING_ROD_TEMP;             %[C]
ZERO_HEAT_THRESHOLD = 10^-6;                    %[W]
ZERO_TEMP_CHANGE_THRESHOLD = 10^-9;             %[K]

fprintf('\nc: %d\nk: %d', c,k)

numSteps = runTime / timeStep;
x = linspace(0, runTime, numSteps)';
Y = zeros(numSteps, numElements);
timeEQ = -1;
pastMidpoint = false;

for j=1:numSteps
    previousTemps = temps;
    for i=1:numElements
        %prepare for calculation
        thisElement = previousTemps(i);
        dQin = 0;
        dQout = 0;
        
        if (i ~= 1)
            leftElement = previousTemps(i-1);
        end
        
        if( i == numElements)
            rightElement = HEAT_SINK_TEMP;
        else
            rightElement = previousTemps(i+1);
        end
        
        if(CONDUCTION)
            if(i == 1)
                dQin = dQin + POWER_INPUT;
            else
                dQin = dQin - K*A_cross*(thisElement - leftElement)/deltaX;
            end
            dQout = dQout - K*A_cross*(thisElement - rightElement)/deltaX;
        end
        
        if(CONVECTION)
%             V*A_surface*
        end
        
        %add heat to increase temperature
        dQdt = dQin + dQout;
        Tfinal = thisElement + dQdt * timeStep / C;
        
        %update element's temperature
        temps(i) = Tfinal;
        
        %store for graph
        Y(j,i) = temps(i);
        
        %record time to reach EQ
        if(i == numElements && j > 2)
           if(pastMidpoint)
              if(timeEQ < 0)
                  %can use either threshold to say EQ
%                   if(dQdt < ZERO_HEAT_THRESHOLD)
                  if(Y(j,i) - Y(j-1,i) < ZERO_TEMP_CHANGE_THRESHOLD)
                      timeEQ = j*timeStep;
                  elseif(j == numSteps)
                      timeEQ = runTime;
                  end
              end
           else
              if((Y(j,i) - Y(j-1,i)) < (Y(j-1,i) - Y(j-2,i)))
                  pastMidpoint = true;
              end
           end
        end
    end
end

if(print)
    figure
    hold on;

    eightMark = floor(8/numElements*length*100);
    fifteenMark = floor(15/numElements*length*100);
    twentyThreeMark = floor(23/numElements*length*100);
    plot(x, Y(:,eightMark), 'r-');
    plot(x, Y(:,fifteenMark), 'g-');
    plot(x, Y(:,twentyThreeMark), 'b-');

    title('Aluminum Rod Conduction');
    xlabel('Time (sec)');
    ylabel('Temperature (^oC)');
    legend('8cm', '15cm', '23cm');
    yLimit = ylim;
    xLimit = xlim;
    text(xLimit(2)-(xLimit(2)-xLimit(1))/100,yLimit(1) + (yLimit(2)-yLimit(1))/100,sprintf('@End\nLeft Temp: %f ^oC\nRight Temp: %f ^oC\nRight dQ/dt: %f W\n@EQ\nTime to EQ: %f s\n8cm Temp: %f ^oC\n15cm Temp: %f ^oC\n23cm Temp: %f ^oC', Y(end,1), Y(end,end), dQdt, timeEQ, Y(timeEQ/timeStep,eightMark), Y(timeEQ/timeStep,fifteenMark), Y(timeEQ/timeStep,twentyThreeMark)), 'HorizontalAlignment','right', 'VerticalAlignment','bottom', 'EdgeColor','black','LineWidth',1, 'BackgroundColor','white');
    grid on;
    hold off;
end

G=Y;
end
