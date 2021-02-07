function [vx,vy]=limpia(vx,vy,grid)
%Función para eliminar las aristas del grafo de voronoi que tengan puntos
%en obstáculos
 aux1x=vx(1,:);
 aux1y=vy(1,:);
 aux2x=vx(2,:);
 aux2y=vy(2,:);
 k=0;
    for i=1:length(aux1x)
        if checkOccupancy(grid,[aux1x(i-k) aux1y(i-k)],'local')
            aux1x(i-k)=[];
            aux1y(i-k)=[];
            aux2x(i-k)=[];
            aux2y(i-k)=[];
            k=k+1;
        end
    end
 k=0;
    for i=1:length(aux2x)
        if checkOccupancy(grid,[aux2x(i-k) aux2y(i-k)],'local')
            aux1x(i-k)=[];
            aux1y(i-k)=[];
            aux2x(i-k)=[];
            aux2y(i-k)=[];
            k=k+1;
        end
    end
 vx=[];
 vy=[];
 vx(1,:)=aux1x;
 vy(1,:)=aux1y;
 vx(2,:)=aux2x;
 vy(2,:)=aux2y;
end