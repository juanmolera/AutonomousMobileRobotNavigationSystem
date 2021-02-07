function [xMapa,yMapa]=getCoordenadasMapa(xApolo,yApolo,L)

    %cambia coordenadas Apolo a cuadrante positivo
    xPositiva = xApolo + 8;
    yPositiva = yApolo + 7;
    
    %cambia a coordenadas de la matriz del mapa [LxL]
    xMapa = round(xPositiva*(L/15)+1);
    yMapa = round((15-yPositiva)*(L/15)+1);

end