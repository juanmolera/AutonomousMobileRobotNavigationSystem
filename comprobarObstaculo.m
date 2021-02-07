function [banderaObs,PosApxObs]=comprobarObstaculo(sens,PosAct,mapa)

%Se inicializan variables
    PosApxObs=zeros(4,1);
    PosApxObsCent=zeros(4,1);
    PosApxObsDer=zeros(4,1);
    PosApxObsIzq=zeros(4,1);

    banderaObsCent=0;
    banderaObsDer=0;
    banderaObsIzq=0;
    
%Se ajusta el cuadrante del ángulo de avance del robot
    if PosAct(3)>pi/4
            ang=PosAct(3)-pi;
        else
            if PosAct(3)<-pi/4
            ang=PosAct(3)+pi;
            else

            end
    end
    
    ang=PosAct(3); 
    
%Se comprueba que sensor ha causado la llamada,se estima la posicióna 
%aproximada del objeto y se comprueba si el mapa de obstáculos muestra 
%algun objeto en esa posición
    
    if sens(1)<=0.7  %sensor central
        PosApxObsCent= [PosAct(1)+sens(1)*cos(ang),
                    PosAct(2)+sens(1)*sin(ang),
                    0,
                    PosAct(3)];
        banderaObsCent = occupancy(PosApxObsCent(1), PosApxObsCent(2),mapa);
    end       
       
    if sens(2)<=0.7 %sensor Izquierdo
        
        PosApxObsIzq= [PosAct(1)+sens(2)*cos(ang+(41/180*pi)),
                    PosAct(2)+sens(2)*sin(ang+41/180*pi),
                    0,
                    PosAct(3)];
        banderaObsIzq  = occupancy(PosApxObsIzq(1), PosApxObsIzq(2),mapa);
    end
    if sens(3)<=0.7 %sensor derecho

        PosApxObsDer= [PosAct(1)+sens(3)*cos(ang-(41/180*pi)),
                    PosAct(2)+sens(3)*sin(ang-(41/180*pi)),
                    0,
                    PosAct(3)];
        banderaObsDer  = occupancy(PosApxObsDer(1), PosApxObsDer(2),mapa);
    end

%Se asignan las variables de retorno con orden de prioridad según el sensor:
% central --> izquierdo --> derecho
    if banderaObsCent
        banderaObs=1;
        PosApxObs=PosApxObsCent;
        return;
    elseif banderaObsIzq
        banderaObs=2;
        PosApxObs=PosApxObsIzq;
        return;
    elseif banderaObsDer
        banderaObs=3;
        PosApxObs=PosApxObsDer;
        return;
    else
        banderaObs=0;
        return;
    end
    
end