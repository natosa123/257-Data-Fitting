function [ P, Q, C, kappa ] = DataVerifier( FilePath )
    TOLERANCE = 0.001;
    

    P_START = 1;
    Q_START = 0.045;
    C_START = 900;
    KAPPA_START = 200;

    
    P_STEP = 0.1;
    Q_STEP = 0.005;
    KAPPA_STEP = 20;
    C_STEP = 90;
    
    Data = getData(FilePath);

    Error=zeros(8,5); %column 1 is P: column 2 is Q: column 3 is C: coulunm 4 is kappa: column 5 is error.
    lastpoint = [Inf, Inf, Inf, Inf];
    currentpoint=[P_START, Q_START, C_START, KAPPA_START, ErrorCalc(Data, P_START, Q_START, C_START, KAPPA_START)];
    P = P_START;
    Q = Q_START;
    C = C_START;
    kappa = KAPPA_START;
    

    while (1)

        P_Up = P+P_STEP;
        P_Down = P-P_STEP;
        Q_Up = Q+Q_STEP;
        Q_Down = Q-Q_STEP;
        C_Up = C+C_STEP;
        C_Down = C-C_STEP;
        kappa_Up = kappa+KAPPA_STEP;
        kappa_Down =kappa-KAPPA_STEP;
    
        if ~isequal(lastpoint(:,1:2),[P_Up, C, kappa])
            Error(1,:) = [P_Up, Q, C, kappa, ErrorCalc(Data, P_Up, Q, C, kappa)];
        else
            Error(1,:)=lastpoint;
        end
    
        if ~isequal(lastpoint(:,1:2),[P_Down, C, kappa])
            Error(2,:) = [P_Down, Q, C, kappa, ErrorCalc(Data, P_Down, Q, C, kappa)];
        else
            Error(2,:)=lastpoint;
        end
        
        if ~isequal(lastpoint(:,1:2),[P, C_Up, kappa])
            Error(3,:) = [P, Q_Up, C, kappa, ErrorCalc(Data, P, Q_Up, C, kappa)];
        else
            Error(3,:)=lastpoint;
        end
    
        if ~isequal(lastpoint(:,1:2),[P, C_Down, kappa])
            Error(4,:) = [P, Q_Down, C, kappa, ErrorCalc(Data, P, Q_Down, C, kappa)];
        else
            Error(4,:)=lastpoint;
        end
    
        if ~isequal(lastpoint(:,1:2),[P, C_Up, kappa])
            Error(5,:) = [P, Q, C_Up, kappa, ErrorCalc(Data, P, Q, C_Up, kappa)];
        else
            Error(5,:)=lastpoint;
        end
    
        if ~isequal(lastpoint(:,1:2),[P, C_Down, kappa])
            Error(6,:) = [P, Q, C_Down, kappa, ErrorCalc(Data, P, Q, C_Down, kappa)];
        else
            Error(6,:)=lastpoint;
        end
        
        if ~isequal(lastpoint(:,1:2),[P, C, kappa_Up])
            Error(7,:) = [P, Q, C, kappa_Up, ErrorCalc(Data, P, Q, C, kappa_Up)];
        else
            Error(7,:)=lastpoint;
        end
        
        if ~isequal(lastpoint(:,1:2),[P, C, kappa_Down])
            Error(8,:) = [P, Q, C, kappa_Down, ErrorCalc(Data, P, Q, C, kappa_Down)];
        else
            Error(8,:)=lastpoint;
        end
        Error(:,end)
        lastpoint = currentpoint;
        if currentpoint(1,end)<Error(:,end)
            break
        else
            currentpoint = Error(find(abs(Error(:,end)-min(Error(:,end)))<TOLERANCE,1),:);
        end
        
        P = currentpoint(1,1);
        Q = currentpoint(1,2);
        C = currentpoint(1,3);
        kappa = currentpoint(1,4);
        [P Q C kappa]
     
    end

end




