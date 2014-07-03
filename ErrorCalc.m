function [ Error ] = ErrorCalc( Data, P, Q, C, kappa )
    TOLERANCE = 0.001;
    tic
    SimData = ConductionSimulation(Data, P, Q, C, kappa);
    toc
    disp('simulation Done');
    Error = zeros(1,size(Data,2)-4);
    tic
    for index = 1:20:size(Data,1)
        SimDataPoint = SimData(abs(SimData(:,1)-Data(index,1))<TOLERANCE, 2:end);   
        if isempty(SimDataPoint)
            break
        end
        Error = Error + abs(Data(index,3:5)-SimDataPoint);
    end
    toc
    disp('Error Calculation Done')

    Error=sum(Error);
end

