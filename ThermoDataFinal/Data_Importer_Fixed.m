FILEPATH = 'C:\Users\p253\Desktop\2014-06-26 [14][28][41].txt';

fileID = fopen(FILEPATH, 'r')
closeResult = -1;

try
    x_title = fscanf(fileID, '%s', 1);
    y1_title = fscanf(fileID, '%s', 1);
    y2_title = fscanf(fileID, '%s', 1);
    y3_title = fscanf(fileID, '%s', 1);
    y4_title = fscanf(fileID, '%s', 1);
    y5_title = fscanf(fileID, '%s', 1);
    y6_title = fscanf(fileID, '%s', 1);
    [raw,count] = fscanf(fileID,'%12f', [7 inf]);
    
    x = raw(1,:);
    y1 = raw(2,:);
    y2 = raw(3,:);
    y3 = raw(4,:);
    y4 = raw(5,:);
    y5 = raw(6,:);
    y6 = raw(7,:);
    
    figure
    hold on
    plot(x,y1, 'r.')
    plot(x,y2, 'k.')
    plot(x,y3, 'g.')
    plot(x,y4, 'c.')
    plot(x,y5, 'b.')
    plot(x,y6, 'm.')
    xlabel(x_title)
    legend(sprintf('%s', y1_title), sprintf('%s', y2_title), sprintf('%s', y3_title), sprintf('%s', y4_title), sprintf('%s', y5_title), sprintf('%s', y6_title));
    hold off
catch EX
    disp('Error, closing file.');
    disp(getReport(EX))
    closeResult = fclose(fileID);
end

if(closeResult ~= 0)
    fclose(fileID)
end