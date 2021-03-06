function [ SimDataAtLocation ] = ConductionSimulation( Data, P, Q, C, kappa )
    TOLERANCE = 0.001;
    %properties from bar
    L=0.3048;           %[m]
    R=0.0111;           %[m]
    M = 0.323;          %[kg]

    %properties from experiment
    Location = [8 15 23]/100;       %location of sensors in experiment. the 100 is to convert from cm to m. (return values corresponding to these locatiosn)
    Voltage = 10;
    Resistance = 15.3;
    HeaterTemp = Data(:,2);
    HeatSinkTemp = Data(:,6);
    StartingTemp = 35;
    
    %properties from simulation
    sectionNumber = 30;
    maxTime = 3600*3;
    timeInterval = 0.01;        %set to correspond to so that every time in the collected data has a corresponding point in the simulation.
    
    %derived properties
    ResistorPower = (Voltage)^2/Resistance;
    sectionLength = L/sectionNumber;        %length of section
    sectionMass = M/sectionNumber;          %mass of section
    area = pi*R^2;                          %cross section
    locationIndices = ceil(Location/sectionLength);
   
    
    %start of simulation
    M = (P*ResistorPower*timeInterval)/(sectionMass*C);                %Constant values for the heat trsnfer from resistor to the bar.
    N = (timeInterval*area)/(sectionMass*sectionLength)*(kappa/C);        %Constant values in for heat transfer between rod sections.
    SimData = StartingTemp*ones(maxTime/timeInterval,sectionNumber);    %Array holding temperature values along the bar (rows are over time, columns are position along the bar)
    
    %Simulation for Constant Heat input
    CurrentHeatSinkTemp = HeatSinkTemp(1);
    DataIndex = 0;
    nextDataTime = Data(1,1);
    for time=1:maxTime/timeInterval-1
        if time == nextDataTime
            DataIndex=DataIndex+1;
            nextDataTime = Data(1,DataIndex);
            LeftTemp = Data(DataIndex);
        end
        for position = 1:sectionNumber;
            if position==1
                SimData(time+1,1) = M-N*(SimData(time,1)-SimData(time,2))+SimData(time,1);
            elseif position==sectionNumber
                SimData(time+1,sectionNumber) = N*(SimData(time,sectionNumber-1)-(1+Q)*SimData(time,sectionNumber)+Q*CurrentHeatSinkTemp)+SimData(time,sectionNumber);
            else
                SimData(time+1,position) = N*(SimData(time,position-1)-2*SimData(time,position)+SimData(time,position+1))+SimData(time,position);
            end
        end
    end
    timeValues = 0:timeInterval:maxTime-timeInterval;
    cla reset
    plot(timeValues,SimData(:,locationIndices(1)), 'r')
    hold on
    plot(Data(:,1), Data(:,3))
    drawnow
    SimDataAtLocation = [timeValues' SimData(:,locationIndices(1)) SimData(:,locationIndices(2)) SimData(:,locationIndices(3))];
    
    
end

