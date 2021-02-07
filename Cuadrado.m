function puntos=Cuadrado(asterisco,theta,L,r,dist)
%Array vacío donde se almacenarán un cuadrado discretizado que represente
%el obstáculo
puntos=[];
%El lado del cuadrado que visualiza el robot será perpendicular a la
%dirección de este, y estará retrasado con respecto a la ubicación donde
%fue localizado dist metros
aux(1)=asterisco(1)+dist*cos(theta);
aux(2)=asterisco(2)+dist*sin(theta);
%Calculamos las esquinas del cuadrado
if theta==0 || theta==pi ||theta==-pi
    %Razones trigonométricas problemáticas tratadas a parte
    esquina1=[cuadrar([aux(1),aux(2)+L/2],r)];
    esquina2=[cuadrar([aux(1),aux(2)-L/2],r)];
    esquina3=[cuadrar([aux(1)+cos(theta)*L,aux(2)+L/2],r)];
    esquina4=[cuadrar([aux(1)+cos(theta)*L,aux(2)-L/2],r)];
else    
    m=tan(theta-pi/2);
    esquina1=[cuadrar([aux(1)-L/2*cos(theta-pi/2),m*(aux(1)-L/2*cos(theta-pi/2)-aux(1))+aux(2)],r)];
    esquina2=[cuadrar([aux(1)+L/2*cos(theta-pi/2),m*(aux(1)+L/2*cos(theta-pi/2)-aux(1))+aux(2)],r)];
    aux(1)=aux(1)+L*cos(theta);
    aux(2)=aux(2)+L*sin(theta);
    esquina3=[cuadrar([aux(1)-L/2*cos(theta-pi/2),m*(aux(1)-L/2*cos(theta-pi/2)-aux(1))+aux(2)],r)];
    esquina4=[cuadrar([aux(1)+L/2*cos(theta-pi/2),m*(aux(1)+L/2*cos(theta-pi/2)-aux(1))+aux(2)],r)]; 
end
%Función para rellenar el cuadrado
puntos=rellenar2(esquina1,esquina2,esquina3,esquina4,r,L);
end