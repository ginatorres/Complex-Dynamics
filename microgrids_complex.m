%Controlador "DISTRIBUTED SECONDARY CONTROL FOR AUTONOMOUS MICROGRIDS"
syms kp ki kd k z
k4=(kp+ki)
k5=-kp
k1=(kp*kd+1+kp*k+kd*ki+k*ki)
k2=(-2*kp*kd-1-kp*k-kd*ki)
k3=-kp*kd
%Controlador
%PI=tf([k4 k5],[k1 k2 k3])%No funciona en simbólico
num=k4*z^2+k5*z
den=k1*z^2+k2*z+k3
PImicro=num/den
%Espacio de estados
%[A,B,C,D]=tf2ss([k4 k5],[k1 k2 k3]')
A=[0 1 0;0 0 1;-k3 -k2 -k1]
B=[0 0 1]
C=[(-k4*k3)/k1 k5-(k4*k2)/k1 0]
D=[k4/k1]
%Ts=1
%sys = ss(A,B,C,D,Ts)%Con simbólico no funciona 
%Paso 2: Buscar valores para a,b,c,k para revisar el sistema complejo.
