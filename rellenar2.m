function puntos=rellenar(esquina1,esquina2,esquina3,esquina4,r,L)
%Función que rellena de forma discretizada un cuadrado determinado por 4
%esquinas
puntos=[];
maxx=max([esquina1(1),esquina2(1),esquina3(1),esquina4(1)]);
minx=min([esquina1(1),esquina2(1),esquina3(1),esquina4(1)]);
maxy=max([esquina1(2),esquina2(2),esquina3(2),esquina4(2)]);
miny=min([esquina1(2),esquina2(2),esquina3(2),esquina4(2)]);
%Como cambia la numeración de cada esquina dependiendo de la ubicación del
%robot, se desarrolla un tipo de relleno para cada una de las 4
%combinaciones posibles
if (esquina2(1)-esquina1(1))~=0
    m1=(esquina2(2)-esquina1(2))/(esquina2(1)-esquina1(1));
    m2=(esquina3(2)-esquina1(2))/(esquina3(1)-esquina1(1));
    if esquina1(1)<esquina3(1)
        if m1<0
            for i= minx:r:maxx
                for j= miny:r:maxy
                    %Combinacion 1
                    if (j>=m1*(i-esquina1(1))+ esquina1(2)) && (j<=m1*(i-esquina3(1))+ esquina3(2)) && (j<=m2*(i-esquina1(1))+ esquina1(2)) && (j>=m2*(i-esquina2(1))+ esquina2(2))
                        puntos=cat(1,puntos,[i,j]);
                    end
                end    
            end
        else
            for i= minx:r:maxx
                for j= miny:r:maxy
                    %Combinacion 2
                    if (j<=m1*(i-esquina1(1))+ esquina1(2)) && (j>=m1*(i-esquina3(1))+ esquina3(2)) && (j<=m2*(i-esquina1(1))+ esquina1(2)) && (j>=m2*(i-esquina2(1))+ esquina2(2))
                        puntos=cat(1,puntos,[i,j]);
                    end
                end    
            end
        end
    elseif esquina1(1)>esquina3(1)
        if m1<0
            for i= minx:r:maxx
                for j= miny:r:maxy
                    %Combinacion 3
                    if (j<=m1*(i-esquina1(1))+ esquina1(2)) && (j>=m1*(i-esquina3(1))+ esquina3(2)) && (j>=m2*(i-esquina1(1))+ esquina1(2)) && (j<=m2*(i-esquina2(1))+ esquina2(2))
                        puntos=cat(1,puntos,[i,j]);
                    end
                end    
            end
        else
            for i= minx:r:maxx
                for j= miny:r:maxy
                    %Combinacion 4
                    if (j>=m1*(i-esquina1(1))+ esquina1(2)) && (j<=m1*(i-esquina3(1))+ esquina3(2)) && (j>=m2*(i-esquina1(1))+ esquina1(2)) && (j<=m2*(i-esquina2(1))+ esquina2(2))
                        puntos=cat(1,puntos,[i,j]);
                    end
                end    
            end
        end
    end
else
    for i= minx:r:maxx
        for j= miny:r:maxy
            puntos=cat(1,puntos,[i,j]);
        end
    end
end
if isempty(puntos)
    for i= minx:r:maxx
        %Esta última opción es para los casos en que el cuadrado se
        %encuentre sin girar, por lo que se rellena tal y como se haría con
        %una matriz
        for j= miny:r:maxy
            puntos=cat(1,puntos,[i,j]);
        end
    end
end
end

