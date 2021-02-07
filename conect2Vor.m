function [vorIni,vorFin] = conect2Vor(Ini,Fin,S,grid)

    %Se busca punto mas cercano al Inicio dentro del grafo que contiene los 
    %puntos de Voronoi

        Idx(1,1) = knnsearch(S,[Ini(1,1) Ini(1,2)]);
        
    %Se fija inicialmente la siguiente posición como la del punto Vor más
    %cercano
        Xsig=S(Idx,:);
    
    %Se comprueba si el cambio de la posición actual a la siguiente
    %atraviesa pared
        bAtraviesaPared=atraviesaPared(Ini,Xsig,0.001,grid);
        cont=2;
        
        %Si atraviesa se busca el punto de Vor más cercano que no lo haga     
            while bAtraviesaPared
                    Aux = knnsearch(S,[Ini(1,1) Ini(1,2)],'k',cont);
                    Xsig=S(Aux(1,cont),:);
                    bAtraviesaPared=atraviesaPared(Ini,Xsig,0.001,grid);
                    cont=cont+1;
            end
        
    %Se fija el punto de enganche inicial con Vor    
        vorIni=Xsig;
    
    %Se repite el mismo proceso para unir el punto final al grafo de Vor
    
        Idx(1,1) = knnsearch(S,[Fin(1,1) Fin(1,2)]);
        Xsig=S(Idx,:);
        bAtraviesaPared=atraviesaPared(Fin,Xsig,0.001,grid);
        cont=2;
        while bAtraviesaPared
                Aux = knnsearch(S,[Fin(1,1) Fin(1,2)],'k',cont);
                Xsig=S(Aux(1,cont),:);
                bAtraviesaPared=atraviesaPared(Fin,Xsig,0.001,grid);
                cont=cont+1;
        end
        vorFin=Xsig;
    
end

