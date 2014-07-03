function [Data] = getData( FilePath )
    
    fileID = fopen(FilePath, 'r');
    
    try
        fgetl(fileID);
        Data = fscanf(fileID, '%f', [7 inf])';
       
    catch exc   
        disp(getReport(exc));
        closeResult = fclose(fileID);
    end
    
    %Analog Reading to Temperature conversions
    Data(:,2) = 0.146201*Data(:,2)+1.527752;      %Thermocouple A
    Data(:,3) = 0.129779*Data(:,3)+6.412440;      %Thermocouple B
    Data(:,4) = 0.142888*Data(:,4)-0.940295;      %Thermocouple C
    Data(:,5) = 0.142366*Data(:,5)-2.767736;      %Thermocouple D
    Data(:,6) = 0.141995*Data(:,6)-2.113447;      %Thermocouple E
    
end