function [B,puntos]=voronoi2graph(vx,vy)
%Función para convertir el grafo de voronoi (aristas determinadas por
%puntos) en un grafo simple sin dirigir

%Obtención de lista de nodos
    puntos= [vx(1,1),vy(1,1);
            vx(2,1),vy(2,1)];
        %En s se almacena el primer nodo de la arista, y en t el segundo
    s=[1];
    t=[2];
    %Los pesos de cada arista se almacenan en el array weights, en la misma
    %posición que la de la propia arista
    weights=[sqrt((vx(1,1)-vx(2,1))^2+(vy(1,1)-vy(2,1))^2)];
    nodes=2;
    for i=2:length(vx(1,:))
        candidato=[vx(1,i),vy(1,i)];
        for j=1:length(puntos(:,1))
            %Nodo ya guardado, se busca en la lista y se registra para la
            %nueva arista
            if puntos(j,1)==candidato(1) && puntos(j,2)==candidato(2) 
                s=cat(2,s,j);
                break;
            end
            %Nuevo nodo
            if j==length(puntos(:,1))
                puntos=cat(1,puntos,[candidato(1),candidato(2)]);
                nodes=nodes+1;
                s=cat(2,s,j+1);
            end
        end
        candidato=[vx(2,i),vy(2,i)];
        for j=1:length(puntos(:,1))
            %Nodo ya guardado, se busca en la lista y se registra para la
            %nueva arista
            if puntos(j,1)==candidato(1) && puntos(j,2)==candidato(2)
                t=cat(2,t,j);
                break;
            end
            %Nuevo nodo
            if j==length(puntos(:,1))
                puntos=cat(1,puntos,[candidato(1),candidato(2)]);
                nodes=nodes+1;
                t=cat(2,t,j+1);
            end
        end
        weight=sqrt((vx(1,i)-vx(2,i))^2+(vy(1,i)-vy(2,i))^2);
        weights=cat(2,weights,weight);
    end
    %Creación del grafo simple
    G = graph(s,t,weights);
    G=simplify(G);
    %Obtención de matriz dispersa
    B=adjacency(G,'weighted');
end


