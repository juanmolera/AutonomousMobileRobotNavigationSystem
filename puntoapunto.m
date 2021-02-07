function [puntos,bFin,Xk,Pk,odometria_ant]=puntoapunto(puntos,precL,precA,Xk,Pk,odometria_ant,mapaObs,mapaVor)

% Definimos una trayectoria circular
Max_velocidadL = 1.5;  % Velocidad lineal 0.2 m/seg
kp_lineal=5;
kd_lineal=0;
timestep = 0.1;  % Actualizacion de sensores
Max_velocidadA = 1; % Velocidad angular
kp_angular=5;
kd_angular=0;

% Algoritmo 
bNuevaRuta=0;
l=0;
Nsig=0;
%Registramos en error_distancia_ant y en error_angulo_ant los errores en
%iteraciones anteriores (en este caso solo es inicialización) para el
%control derivativo
error_distancia_ant=(sqrt((puntos(1,1)-Xk(1))^2+(puntos(1,2)-Xk(2))^2));
avancex=(puntos(1,1)-Xk(1));
avancey=(puntos(1,2)-Xk(2));
%angulo_orientado indica el ángulo que debe tener el robot para poder
%dirigirse al siguiente punto en línea recta
angulo_orientado=atan2(avancey,avancex);
error_angulo_ant=angulo_orientado-Xk(3);
for i=2:length(puntos(:,1))
    x_fin=puntos(i,1);
    y_fin=puntos(i,2);
    %Mientras que el robot no se encuentre en una zona de error admisible
    %entorno al punto objetivo, no se considerará que se ha llegado a este
    while not(abs(Xk(1)-x_fin)<precL && abs(Xk(2)-y_fin)<precL)   
        l=l+1;
        avancex=(x_fin-Xk(1));
        avancey=(y_fin-Xk(2));
        angulo_orientado=atan2(avancey,avancex);
        if angulo_orientado>(pi)
                angulo_orientado = angulo_orientado - 2*pi;
        end
        angulos(l)=angulo_orientado;
        error_angulo=angulo_orientado-Xk(3);
        if error_angulo>(pi)
                error_angulo = angulo_orientado - 2*pi;
        elseif error_angulo<(-pi)
                error_angulo = angulo_orientado + 2*pi;
        end
        %Mientras que el robot no se encuentre con una orientación admisible
        %la velocidad lineal se mantendrá a cero
        if abs(error_angulo)>(pi/(180/precA))
            %Control PD
            velocidadA=kp_angular*error_angulo+kd_angular*(error_angulo-error_angulo_ant);
            error_angulo_ant=error_angulo;
            velocidadL=0;
            if velocidadA>Max_velocidadA
                velocidadA=Max_velocidadA;
            elseif velocidadA<-1*Max_velocidadA
                velocidadA=-1*Max_velocidadA;
            end
            trayectoriaD(l) = 0;
            trayectoriaB(l) = velocidadA*timestep;
        else
            error_distancia=(sqrt((x_fin-Xk(1))^2+(y_fin-Xk(2))^2));
            %Control PD
            velocidadL=kp_lineal*error_distancia+kd_lineal*(error_distancia-error_distancia_ant);
            error_distancia_ant=error_distancia;
            if velocidadL>Max_velocidadL
                velocidadL=Max_velocidadL;
            elseif velocidadL<-1*Max_velocidadL
                velocidadL=-1*Max_velocidadL;
            end
            %Control PD
            velocidadA=kp_angular*error_angulo+kd_angular*(error_angulo-error_angulo_ant);
            error_angulo_ant=error_angulo;
            if velocidadA>Max_velocidadA
                velocidadA=Max_velocidadA;
            elseif velocidadA<-1*Max_velocidadA
                velocidadA=-1*Max_velocidadA;
            end
            trayectoriaD(l) = velocidadL*timestep;
            trayectoriaB(l) = velocidadA*timestep;
        end
        
        %mido distancias con sensores ultrasonido
            sens=apoloGetAllultrasonicSensors('Marvin');
            
            if (sens(1) <0.7 || sens(2) <0.7 || sens(3) <0.7) 
                %Si detectan algo cercano compruebo en el mapa de Obs si es
                %pared o un obstáculo no registrado
                    [bObs,PosObs]=comprobarObstaculo(sens,Xk,mapaObs); 
                    
                    if bObs                
                       %si es obstáculo busco evitarlo 
                        [puntos]=esquivar(Xk,puntos(max(i-2,1),:),puntos(end,:),PosObs,mapaObs,mapaVor,bObs);
                       %como la función de evitar me devuelve una ruta
                       %nueva, finalizo la ejecución de la ruta actual
                       %pero mantengo la bandera de finalización bajada
                        bFin=0;
                        return;
                    else    
                       %si es obstáculo ya registrado(pared) procedo normal
                        [Xk,Xrealk,Pk,odometria_ant]=filtroKalman(velocidadL,velocidadA,timestep,odometria_ant,Xk,Pk);
                    end
            else    
                %si no es obstáculo, procedo normal
                    [Xk,Xrealk,Pk,odometria_ant]=filtroKalman(velocidadL,velocidadA,timestep,odometria_ant,Xk,Pk);
            end
    end

end

%Cuand se llegue a la distancia marcada del punto final se saldrá del bucle
%y se activa la bandera de finalización

    bFin=1;
    % show(mapaObs);
    % show(mapaVor);

end