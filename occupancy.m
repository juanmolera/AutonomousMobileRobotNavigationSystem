function banderaObs = occupancy(xApolo,yApolo,mapa)

%Se obtiene la matriz del mapa de Obstáculo
    matrixMap= occupancyMatrix(mapa);

%Se cambia la posición estimada del objeto de coordenadas de Apolo al mapa
    [xMapa ,yMapa] = getCoordenadasMapa(xApolo,yApolo,mapa.GridSize(1));

%Se comprueba si dicha posición se corresponde con un obstáculo conocido
    if matrixMap(yMapa,xMapa)
        %es pared/conocido
            banderaObs = 0;
            return;
                
    else
        %no es conocido
            banderaObs = 1;
            
            %Para mostrar posición aproximada en mapa de Obstáculos
                %figure;
                %show(mapa)
                %hold on;
                %plot((xApolo+8)/5,(yApolo+7)/5,'*r');
                %pause
                %close all;        
    end  

end