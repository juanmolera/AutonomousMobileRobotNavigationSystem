function bAtraviesaPared=atraviesaPared(Xant,Xsig,paso,grid)

    %Inicialización de dirección y de variables de retorno
        dirX=1;
        dirY=2;
        bAtraviesaPared=0;
        
    %Se mantienen solamente 2 decimales
        Xant=floor(Xant(1,:)*100)/100;
        Xsig=floor(Xsig(1,:)*100)/100;

    %Se definen puntos intermedios atendiendo a diferentes casos
        if Xant(1,1)>Xsig(1,1)
                Xint(:,1)=Xsig(1,1):paso:Xant(1,1);
        elseif Xant(1,1)<Xsig(1,1)
                Xint(:,1)=Xant(1,1):paso:Xsig(1,1);
        elseif Xant(1,1)==Xsig(1,1)
            %La coordenada x de ambos es igual, se "cambia" la x por la y
            dirX=2;
            dirY=1;
            if Xant(1,2)>=Xsig(1,2)
                Xint(:,2)=Xsig(1,2):paso:Xant(1,2);
            elseif Xant(1,2)<Xsig(1,2)
                Xint(:,2)=Xant(1,2):paso:Xsig(1,2);
            end
        end
    
    %Empleando la ecuación de una recta entre dos puntos se definen una 
    %serie de puntos intermedios con precision fijada por la variable PASO    
        for i=1:length(Xint(:,dirX))
            Xint(i,dirY)= ((Xint(i,dirX)-Xant(1,dirX))/(Xsig(1,dirX)-Xant(1,dirX))*(Xsig(1,dirY)-Xant(1,dirY)))+Xant(1,dirY);
            if checkOccupancy(grid,[Xint(i,1) Xint(i,2)])==1
                %Si atraviesa se levanta bandera y se vuelve a la funcion
                %llamada
                bAtraviesaPared=1;
                break;
            end
        end
        
    %Si no se ha levantado la bandera, no se atraviesa pared
end