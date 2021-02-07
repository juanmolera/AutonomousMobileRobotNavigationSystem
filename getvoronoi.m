function [trayectoriaApolo,mapaObs,mapaVor]=getvoronoi(x,y,xg,yg)

%Se obtienen dos mapas del entorno: 
%-mapaObs[150x150] permite hacer obstáculos más grandes
%-mapaVor[80x80] permite mayor velocidad de planificación con Voronoi
image = imread('imageMap.png');
imageR=imresize(image,[80 80]);
grayimage = rgb2gray(image);
grayimageR = rgb2gray(imageR);
bwimage = grayimage <250;
bwimageR = grayimageR <250;
    
escala_casilla=50; %division de cada casilla
mapaObs = binaryOccupancyMap(bwimage,escala_casilla);
mapaVor = binaryOccupancyMap(bwimageR,escala_casilla);
inflate(mapaObs,0.06); %se inflan objetos
    
%     show(mapaObs)
%     figure
%     show(mapaVor)

%Parametros necesarios de cada mapa para cambiar entre coordenadas de
%Apolo<->Mapa
Nobs=15/mapaObs.XWorldLimits(2);
Nvor=15/mapaVor.XWorldLimits(2);

%Se cambia de coordenadas de Apolo a mapaVor    
x=(x+8)/Nvor;
y=(y+7)/Nvor;
xg=(xg+8)/Nvor;
yg=(yg+7)/Nvor;

close all;
    
      
%tic;
cont=1;
% inflate(grid,0.05);
for i=1:mapaVor.GridSize(1)
    for j=1:mapaVor.GridSize(2)
        if checkOccupancy(mapaVor,[i j],'grid')
           xMapa(cont,1)=i;
           yMapa(cont,1)=j;
           XY(cont,:)=grid2local(mapaVor,[i j]);
           cont=cont+1;
        end
     end
end
[vx,vy]=voronoi(XY(:,1),XY(:,2));
%figure;
%Obtención de grafo limpio
[vx,vy]=limpia(vx,vy,mapaVor);
plot(XY(:,1),XY(:,2),'r.',vx,vy,'k-');
axis([0 mapaVor.GridSize(1)/escala_casilla 0 mapaVor.GridSize(2)/escala_casilla ]) ;
%hold on;
plot(x,y,'*g',xg,yg,'g*');
%voronoi a matriz dispersa
[B,puntos]=voronoi2graph(vx,vy);
%recoger puntos inicio y fin voronoi ([xv,yv] y [xfv,yfv])
[ini,fin]=conect2Vor([x,y],[xg,yg],puntos,mapaVor);
xv=ini(1);
yv=ini(2);
xfv=fin(1);
yfv=fin(2);
%Convertirlos a modo grafo (ini,fin)
for i=1:length(puntos)
    if xv==puntos(i,1) && yv==puntos(i,2)
        ini=i;
    end
    if xfv==puntos(i,1) && yfv==puntos(i,2)
        fin=i;
    end
end  
%Dijkstra
[dist,path,pred] = graphshortestpath(B,ini,fin);
%Trayectoria a seguir
trayectoria=[x,y];
for i=1:length(path)
    trayectoria=cat(1,trayectoria,[puntos(path(i),1), puntos(path(i),2)]);
end
trayectoria=cat(1,trayectoria,[xg,yg]);
% hold on;
% plot(trayectoria(:,1),trayectoria(:,2),'-b');
%plot(path(1,:),path(2,:),'-b');
%Se convierte la trayectoria a coordenadas de Apolo
trayectoriaApolo=[Nvor*trayectoria(:,1)-8,Nvor*trayectoria(:,2)-7];

