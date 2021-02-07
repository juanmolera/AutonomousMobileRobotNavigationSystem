function [tx,ty]=getPosBal_simple(idBal)

    % Posicion de las balizas
    switch idBal
        case 1
            tx = -7.9;
            ty = 7.9;
        case 2
            tx = -7.9;
            ty = 0;
        case 3
            tx = -7.9;
            ty = -6.9; 
        case 4
            tx = -6.1;
            ty = 6.1;
        case 5
            tx = -6.1;
            ty = 0;
        case 6
            tx = -6.1;
            ty = -5.1;
        case 7
            tx = -5.9;
            ty = 5.9;
        case 8
            tx = -5.9;
            ty = 0; 
        case 9
            tx = -5.9;
            ty = -4.9;
        case 10
            tx = -5.1;
            ty = 4.1; 
        case 11
            tx = -4.9;
            ty = 0.1;
        case 12
            tx = -3.1;
            ty = -1.9;
        case 13
            tx = -3.1;
            ty = -3.1; 
        case 14
            tx = -1.1;
            ty = 4;
        case 15
            tx = -1.1;
            ty = 0.1; 
        case 16
            tx = -0.9;
            ty = -0.1;
        case 17
            tx = -1.1;
            ty = -5;
        case 18
            tx = -1.1;
            ty = -6.9; 
        case 19
            tx = 0;
            ty = 7.9;
        case 20
            tx = 0;
            ty = 6.1; 
        case 21
            tx = 0;
            ty = 5.9;
        case 22
            tx = 0.9;
            ty = -0.1;
        case 23
            tx = 1.1;
            ty = 0.1; 
        case 24
            tx = 1.9;
            ty = 4;
        case 25
            tx = 3.1;
            ty = -1.9; 
        case 26
            tx = 3.1;
            ty = -3.1;
        case 27
            tx = 5.1;
            ty = 6;
        case 28
            tx = 4.9;
            ty = 0.1; 
        case 29
            tx = 5.1;
            ty = 0;
        case 30
            tx = 4.9;
            ty = -4.9; 
        case 31
            tx = 5.1;
            ty = -5.1;
        case 32
            tx = 6.9;
            ty = 7.9;
        case 33
            tx = 6.9;
            ty = 0; 
        case 34
            tx = 6.9;
            ty = -6.9;

    end

end