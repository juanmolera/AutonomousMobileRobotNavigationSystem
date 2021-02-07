function aux=cuadrar(aux,r)
%Cálculo manual de vértices del cuadrado para razones trigonométricas
%problemáticas
restox=mod(aux(1),r);
restoy=mod(aux(2),r);
if(restox)>0
    if restox>r/2
        aux(1)=aux(1)+(r-restox);
    else
        aux(1)=aux(1)-restox;
    end
end
if(restoy)>0
    if restoy>r/2
        aux(2)=aux(2)+(r-restoy);
    else
        aux(2)=aux(2)-restoy;
    end
end
