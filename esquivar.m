function [puntos]=esquivar(Xk,Xini,Xfin,PosObs,mapaObs,mapaVor,bObs) 
    
%Compruebo que sensor ha detectado obstáculo 
%1-central
%2-izquierdo
%3-derecho
    switch bObs
        case 1
            ang=Xk(3);
        case 2
            ang=Xk(3)-41/180*pi;
        case 3
            ang=Xk(3)+41/180*pi;
    end

%Añado un cuadrado en la posición estimada del obstáculo (en ambos mapas)
    ptosObs=Cuadrado(PosObs,ang,0.7,0.02,-0.05);
    ptosVor=Cuadrado(PosObs,ang,0.4,0.02,-0.05);
    close all;
    
    %Modificación el mapaObs
        for i=1:length(ptosObs)
            [yMapaObs(i,1),xMapaObs(i,1)]=getCoordenadasMapa(ptosObs(i,1),ptosObs(i,2),mapaObs.GridSize(1));
        end
        setOccupancy(mapaObs,[xMapaObs yMapaObs],1,'Grid');
    %     show(mapaObs);

    %Modificación el mapaVor
        for i=1:length(ptosVor)
            [yMapaVor(i,1),xMapaVor(i,1)]=getCoordenadasMapa(ptosVor(i,1),ptosVor(i,2),mapaVor.GridSize(1));
        end
        setOccupancy(mapaVor,[xMapaVor yMapaVor],1,'Grid');
    %     show(mapaVor);
    %    pause();
    
    %Una vez fijados los obstáculos nuevos se reflanifica la ruta
        [puntos]=voronoireplaner(Xini(1),Xini(2),Xfin(1),Xfin(2),mapaVor);


    close all;
    
end
