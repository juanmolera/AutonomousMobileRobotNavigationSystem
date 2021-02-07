function [trayectoriaApolo]=voronoireplaner(x,y,xg,yg,mapa)

close all;

%Se fijan las posiciones iniciales en coordenadas del mapa de Voronoi
    escala_casilla=mapa.Resolution;
    N=(15/mapa.XWorldLimits(2));
    x=(x+8)/N;
    y=(y+7)/N;
    xg=(xg+8)/N;
    yg=(yg+7)/N;

%Se obtiene el grafo marcado por las fronteras del diagrama de Voronoi
    cont=1;
   
    for i=1:mapa.GridSize(1)
        for j=1:mapa.GridSize(2)
            if checkOccupancy(mapa,[i j],'grid')
                xMapa(cont,1)=i;
                yMapa(cont,1)=j;
                XY(cont,:)=grid2local(mapa,[i j]);
                cont=cont+1;
            end
        end
    end
    
    [vx,vy]=voronoi(XY(:,1),XY(:,2));
    %Obtención de grafo limpio de Voronoi
    [vx,vy]=limpia(vx,vy,mapa);
    %visualizar grafo voronoi
    % figure;
        % plot(XY(:,1),XY(:,2),'r.',vx,vy,'k-');
        % axis([0 mapa.GridSize(1)/escala_casilla 0 mapa.GridSize(2)/escala_casilla ]) ;
        % hold on;
        % plot(x,y,'*g',xg,yg,'g*');
%Voronoi a matriz dispersa   
    [B,puntos]=voronoi2graph(vx,vy);
%Se recogen puntos inicio y fin para conectar con voronoi 
%([xv,yv] y [xfv,yfv])
    [ini,fin]=conect2Vor([x,y],[xg,yg],puntos,mapa);
    
    xv=ini(1);
    yv=ini(2);
    xfv=fin(1);
    yfv=fin(2);
    
    %Se convierten a modo grafo (ini,fin)
        for i=1:length(puntos)
            if xv==puntos(i,1) && yv==puntos(i,2)
                ini=i;
            end
            if xfv==puntos(i,1) && yfv==puntos(i,2)
                fin=i;
            end
        end  
    %Se calcula ruta con dijkstra
        [dist,path,pred] = graphshortestpath(B,ini,fin);
        trayectoria=[x,y];
        for i=1:length(path)
            trayectoria=cat(1,trayectoria,[puntos(path(i),1), puntos(path(i),2)]);
        end
        trayectoria=cat(1,trayectoria,[xg,yg]);
        
       
    %Para visualizar nueva ruta    
        % hold on;
        % plot(trayectoria(:,1),trayectoria(:,2),'-b');
        %plot(path(1,:),path(2,:),'-b');
        % pause();

%Se fija la ruta a devolver        
    trayectoriaApolo=[N*trayectoria(:,1)-8,N*trayectoria(:,2)-7];
end