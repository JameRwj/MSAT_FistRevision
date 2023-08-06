    SUBROUTINE ROUND_R_1D(i,variableR,variable)

    USE BasicData ,ONLY: p2,id,ghostLayers,half,zero,one,two

    IMPLICIT NONE

    INTEGER i

    REAL(p2) :: variableR
    REAL(p2) :: delta
    REAL(p2) :: faiR_bar,variableR_bar
    REAL(p2) :: omega0,omega1
    REAL(p2) :: gamma0,gamma1,lambda1
    REAL(p2) :: Temp1,Temp2,Temp3,Temp4
    REAL(p2) :: variable(1-ghostLayers:id+ghostLayers)
    REAL(p2) :: alpha1,alpha2,alpha3

    delta = 1.0E-16
    
    gamma0  = 1100.0_p2
    gamma1  = 800.0_p2
    lambda1 = 0.15_p2
    
    faiR_bar = (variable(i)-variable(i+1))/(variable(i-1)-variable(i+1))
    
    omega0 = one/(one+gamma0*(faiR_bar-one)**4)**2
    omega1 = one/(one+gamma1*(faiR_bar-one)**4)**2
    
    Temp1 = (one/3.0_p2 + 5.0_p2/6.0_p2*faiR_bar)*omega0&
        + two*faiR_bar*(one-omega0)
    Temp2 = two*faiR_bar
    Temp3 = (one/3.0_p2 + 5.0_p2/6.0_p2*faiR_bar)*omega1&
        + (lambda1*faiR_bar-lambda1+one)*(one-omega1)
    Temp4 = lambda1*faiR_bar-lambda1+one
    
    IF ((faiR_bar > 0.0) .AND. (faiR_bar <= half)) THEN
        variableR_bar = MIN(Temp1,Temp2)
    ELSEIF ((faiR_bar > half) .AND. (faiR_bar <= one)) THEN
        variableR_bar = MIN(Temp3,Temp4)
    ELSE
        variableR_bar = faiR_bar
    END IF
    
    variableR = variableR_bar*(variable(i-1)-variable(i+1))+variable(i+1)
    
    IF (variable(i-1)-variable(i+1)==0)THEN
        variableR = variable(i)
    END IF
    END SUBROUTINE ROUND_R_1D