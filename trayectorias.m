    
function trayectorias(xIni,yIni,xFin,yFin)
   
    close all;

    %obtención de la ruta a seguir y el mapa del entorno para Obs[150x150] y
    %Voronoi[80x80]
    
        [ruta,gridObs,gridVor]=getvoronoi(xIni,yIni,xFin,yFin);
    
    %Se posiciona el robot en su ubicación inicial y se inicializan los
    %parametros para el filtro de kalman
    
        apoloPlaceMRobot('Marvin',[xIni yIni 0],0);
        apoloResetOdometry('Marvin',[xIni yIni 0]);
        apoloUpdate;
        odometria_ant=apoloGetOdometry('Marvin')';

    %posición inicial para kalman
        Xk = [ruta(1,1); ruta(1,2); 0];

    %Incertidumbre inicial para kalman
        Pxini = 0.00005;
        Pyini = 0.00005;
        Pthetaini = 0.00005;
        Pk = [Pxini 0 0; 0 Pyini 0 ; 0 0 Pthetaini];

    %visualización de mapas
    
         % show(gridObs);
         % show(gridVor);
         %pause(0) 
         close all;

     %inicio bucle hasta llegar al final   
        
        bFin=0;
        
        while ~bFin
            [ruta,bFin,Xk,Pk,odometria_ant]=puntoapunto(ruta,0.1,1,Xk,Pk,odometria_ant,gridObs,gridVor);
        end
end