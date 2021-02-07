function [Xk,Xrealk,Pk,odometria_ant]=filtroKalman(velocidadL,velocidadA,timestep,odometria_ant,Xk,Pk)

% Rrayectoria a seguir
        trayectoriaD=velocidadL*timestep;
        trayectoriaB=velocidadA*timestep;

% Varianza en la medida
        R1 = 2.9e-4;
        R2 = 2.9e-4;
        R3 = 2.9e-4;
        Rk = [R1 0 0; 0 R2 0; 0 0 R3];
 
% Varianza del ruido del proceso 
        Qd = (1e-6)*velocidadL^2;
        Qb = (5e-6)*velocidadA^2;
        Qk_1 = [Qd 0; 0 Qb];    

%Avanzo el robot en Apolo
        apoloMoveMRobot('Marvin', [velocidadL, velocidadA], timestep);
        pause(0.005);
        apoloUpdate();

% Avance real del robot
        location=apoloGetLocationMRobot('Marvin');
        Xrealk(1) = location(1);
        Xrealk(2) = location(2);
        Xrealk(3) = location(4);
        
% Observacion de las balizas
        a=apoloGetLaserLandMarks('LMS100');

        for r=1:length(a.distance)
            Zk(r,1) = a.distance(r); 
        end
        len=length(a.id);

% Para acortar el nombre de la variable
        Uk = [trayectoriaD; trayectoriaB];

% Nuevo ciclo, k-1 = k.
        Xk_1 = Xk;
        Pk_1 = Pk;

% Prediccion del estado
        odometria = apoloGetOdometry('Marvin')';
        var_odometria=odometria-odometria_ant;
        odometria_ant=odometria;
        
        X_k = Xk+var_odometria;
        
        Ak = [1 0 (-Uk(1)*sin(Xk_1(3)+Uk(2)/2));
              0 1 (Uk(1)*cos(Xk_1(3)+Uk(2)/2));
              0 0 1                             ];
          
        Bk = [(cos(Xk_1(3)+Uk(2)/2)) (-0.5*Uk(1)*sin(Xk_1(3)+Uk(2)/2));
              (sin(Xk_1(3)+Uk(2)/2)) (0.5*Uk(1)*cos(Xk_1(3)+Uk(2)/2));
               0                     1                                 ];
           
        P_k = Ak*Pk_1*((Ak)') + Bk*Qk_1*((Bk)');

        %Por si acaso no se ven 3 balizas desde alguna posición
            if len < 3
               if len < 2
                   if len <1
                    
                    %No se observa ninguna baliza
                        Zk  = [0;0;0];
                        Zk_ = [0;0;0];
                        Hk = [0 0 0;
                              0 0 0;   
                              0 0 0];  
                   else
                   %Se observa una sola baliza
                   %Obtengo coordenadas de la baliza, segun su id
                        [t1x,t1y]=getPosBal_simple(a.id(1));

                    %Pongo el resto de medidas a cero, tanto estimación 
                    %como observacion(sino sería nulo)
                        aux1x=t1x-X_k(1)-0.1*cos(X_k(3));
                        aux1y=t1y-X_k(2)-0.1*sin(X_k(3));
                        Zk(3,1)=0;
                        Zk(2,1)=0;
                        Zk_ =   [sqrt((aux1x)^2+(aux1y)^2);
                                0;
                                0];
                        Hk =    [-aux1x/sqrt((aux1x)^2+(aux1y)^2) -aux1y/sqrt((aux1x)^2+(aux1y)^2) (aux1x*0.1*sin(X_k(3))-aux1y*0.1*cos(X_k(3)))/sqrt((aux1x)^2+(aux1y)^2);
                                0 0 0;   
                                0 0 0];
                   end
               else
                    %Se observan dos balizas
                    %Obtengo coordenadas de las 2 balizas, segun su id
                        [t1x,t1y]=getPosBal_simple(a.id(1));
                        [t2x,t2y]=getPosBal_simple(a.id(2));

                    %pongo la 3ª medida a cero, tanto la estimación, como la
                    %observacion(sino sería nulo)
                        aux1x=t1x-X_k(1)-0.1*cos(X_k(3));
                        aux1y=t1y-X_k(2)-0.1*sin(X_k(3));
                        aux2x=t2x-X_k(1)-0.1*cos(X_k(3));
                        aux2y=t2y-X_k(2)-0.1*sin(X_k(3));

                    Zk(3,1)=0;
                    Zk_ = [sqrt((aux1x)^2+(aux1y)^2);
                           sqrt((aux2x)^2+(aux2y)^2);
                           0];
                    Hk = [-aux1x/sqrt((aux1x)^2+(aux1y)^2) -aux1y/sqrt((aux1x)^2+(aux1y)^2) (aux1x*0.1*sin(X_k(3))-aux1y*0.1*cos(X_k(3)))/sqrt((aux1x)^2+(aux1y)^2);
                          -aux2x/sqrt((aux2x)^2+(aux2y)^2) -aux2y/sqrt((aux2x)^2+(aux2y)^2) (aux2x*0.1*sin(X_k(3))-aux2y*0.1*cos(X_k(3)))/sqrt((aux2x)^2+(aux2y)^2);   
                          0 0 0];
                end
            else
                %Se observan 3 balizas
                %Obtengo coordenadas de las 3 balizas , segun su id
                    [t1x,t1y]=getPosBal_simple(a.id(1));
                    [t2x,t2y]=getPosBal_simple(a.id(2));
                    [t3x,t3y]=getPosBal_simple(a.id(3));

                %me quedo solo con 3 observaciones (por si hay más)
                    Zk  = Zk(1:3);
                % Prediccion de la medida
                    aux1x=t1x-X_k(1)-0.1*cos(X_k(3));
                    aux1y=t1y-X_k(2)-0.1*sin(X_k(3));
                    aux2x=t2x-X_k(1)-0.1*cos(X_k(3));
                    aux2y=t2y-X_k(2)-0.1*sin(X_k(3));
                    aux3x=t3x-X_k(1)-0.1*cos(X_k(3));
                    aux3y=t3y-X_k(2)-0.1*sin(X_k(3));
                    Zk_ = [sqrt((aux1x)^2+(aux1y)^2);
                           sqrt((aux2x)^2+(aux2y)^2);
                           sqrt((aux3x)^2+(aux3y)^2)];
                    Hk = [-aux1x/sqrt((aux1x)^2+(aux1y)^2) -aux1y/sqrt((aux1x)^2+(aux1y)^2) (aux1x*0.1*sin(X_k(3))-aux1y*0.1*cos(X_k(3)))/sqrt((aux1x)^2+(aux1y)^2);
                          -aux2x/sqrt((aux2x)^2+(aux2y)^2) -aux2y/sqrt((aux2x)^2+(aux2y)^2) (aux2x*0.1*sin(X_k(3))-aux2y*0.1*cos(X_k(3)))/sqrt((aux2x)^2+(aux2y)^2);   
                          -aux3x/sqrt((aux3x)^2+(aux3y)^2) -aux3y/sqrt((aux3x)^2+(aux3y)^2) (aux3x*0.1*sin(X_k(3))-aux3y*0.1*cos(X_k(3)))/sqrt((aux3x)^2+(aux3y)^2)];
            end
            
% Comparacion
        Yk = Zk-Zk_;
        Sk = Hk*P_k*((Hk)') + Rk;
        Wk = P_k*((Hk)')*inv(Sk);
        Auxk= Wk*Yk;
        
% Correccion        
        Xk = X_k + Wk*Yk;
        
        %Ajusto angulo igual que apolo
            if Xk(3)>(pi)
                    Xk(3) = Xk(3) - 2*pi;
            elseif Xk(3)<(-pi)
                    Xk(3) = Xk(3) + 2*pi;
            end
            
        Pk = (eye(3)-Wk*Hk)*P_k;
end