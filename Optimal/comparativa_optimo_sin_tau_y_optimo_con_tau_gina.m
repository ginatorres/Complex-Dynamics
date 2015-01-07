clear all
close all
A=[0 1;0 0];
B=[0;1];
C=[1 0];
tau=0.9;
h=1;
n=size(A,2)
Q=[1 -0.3;-0.3 1];
R=1;
N=[0;0];

%El control Óptimo directo...
[Kd,Sd,Ed]=lqrd(A,B,Q,R,N,h);


%Contruimos las matrices optimas ampliadas
%esto deberia estar en un archivo separado
addpath ../;
[phia,gammaa]=dl2extended(A,B,C,tau,h,1); %modelo extendido
phia=double(phia);
gammaa=double(gammaa);

syms t;
phi=expm(A*t);
gamma=int(phi,t,0,t)*B;
q1=int(phi'*Q*phi,t,0,t);
q1=matlabFunction(q1,'vars',[t]);
q12=int(phi'*(Q*gamma+N),t,0,t);
q12=matlabFunction(q12,'vars',[t]);
q2=int(gamma'*Q*gamma+2*gamma'*N+R);
q2=matlabFunction(q2,'vars',[t]);
phi=matlabFunction(phi,'vars',[t]);
gamma=matlabFunction(gamma,'vars',[t]);


Q1a=[q1(tau)+phi(tau)'*q1(h-tau)*phi(tau);q12(tau)'*phi(tau)];% En el paper dice q12(tau)'+phi(tau)
Q1b=[phi(tau)'*q12(tau);q2(tau)+gamma(tau)'*q1(h-tau)*gamma(tau)];%En el paper dice q12(tau)+phi(tau)'
Q1=[Q1a Q1b];
Q12=[phi(tau)'*q12(h-tau);gamma(tau)'*q12(h-tau)];
Q2=q2(h-tau);
Qd=[Q1 Q12;Q12' Q2];
[Ka,Sa,Ea]=dlqr(phia,gammaa,Q1,Q2,Q12)

polos=[Ea(1,1), Ea(3,1)]
%[new_k,new_tau,px]=gacker(A,B,h,Ea(1:2));
[new_k,new_tau,px]=gacker(A,B,h,polos);
new_k

rmpath ../;

%% Resolviendo Q,R dado Kcompleja
global phi
global phi
global gamma
global Kcomplex
global caso
[phi,gamma]=c2d(A,B,h);
%Tomando dos de los 3 polos del modelo ampliado
poles=[Ea(1,1), Ea(3,1)]
%Diseñamos una Kcompleja la cual es óptima
Kcomplex=place(phi,gamma,poles)
%%Valores propios con Kcomplex
%phi_cl=phi-gamma*Kcomplex
%E=eig(phi_cl);

%Usamos esta Kcompleja para ver la forma que tendría R y Q en el control
%óptimo a través de la Ecuación de Riccati. 
%Optimizamoz para encontrar un Q y un R dado una Kcompleja, la cual es
%óptima.
%options = optimset('MaxFunEvals',10^9,'TolFun',10^-6,'MaxIter',10^9,'Algorithm','active-set');
options = optimset('MaxFunEvals',10^9,'MaxIter',10^9,'Algorithm','active-set');
x0=[10 100 100 1 100]
%x0=[3 1 1 1 1 -1 3 -1 10 1]
%Seleccionar los casos para buscar 
caso='1'
%Optimización sin restricciones
%[XOUT,FVAL,EXITFLAG]=fminsearch(@obj2,x0,options) %Encuentra valores pero en algunos casos R es 0.
%Optimización con reestricciones
[XOUT,FVAL,EXITFLAG]=fmincon(@objfun,x0,[],[],[],[],[],[],@confun,options) 
% No optimiza!!!!  No active inequalities, revisar.

%%Comentarios  obtenidos a travès del Fminsearch
% %Caso 1. Q simétrica compleja conjugada,R real
% 1. 
% Qc=1.0e+14 *[2.2517 - 1.1707i   0.0054 + 0.0000i; 
%      -0.0056 + 0.0000i   2.2517 + 1.1707i]
%  R= [ 4.8845e+12]
%* 2.
% Qc =1.0e+03 *[ 2.5030 - 1.2615i   0.2742 + 0.0000i;
%    0.0562 + 0.0000i   2.5030 + 1.2615i]
% R =  1.7043e-06

%%Caso 2. Q simétrica compleja contraria conjugada,R real
% Qc = [   1.7362 + 0.0000i   0.9475 + 0.8124i;
%    0.9475 - 0.8124i   1.8766 + 0.0000i]
% R = [3.8828e-08]
%R es casi 0 debería usar una optimización con reestricciones

%Caso 3. Q y R pueden ser reales y complejas
%Para este caso R nos da 0, deberìa usar una optimización con
%reestricciones

  
%% Comprobamos que la Q y R dadas por fminsearch nos den Kcomplex
switch(caso)
   %Caso 1
    case '1' 
        %Q=Diagonal Simétrica, R=Real
        Qc=[XOUT(1,1)+XOUT(1,2)*i  XOUT(1,3);
            XOUT(1,4) XOUT(1,1)-XOUT(1,2)*i]; %Simètrica conjugada
        R=[XOUT(1,5)];
   % %Caso 2
    case '2' 
         % %Q=Diagonal Simétrica Contraria, R=Real
         Qc=[XOUT(1,1)  XOUT(1,2)+XOUT(1,3)*i;
             XOUT(1,2)-XOUT(1,3)*i XOUT(1,4)] %Simètrica conjugada
         R=[XOUT(1,5)];
    %Caso 3
    case '3' 
        %Q y R pueden ser Reales o complejas.
        Qc=[XOUT(1,1)+XOUT(1,2)*i  XOUT(1,3)+XOUT(1,4)*i;
             XOUT(1,5)+XOUT(1,6)*i XOUT(1,7)+XOUT(1,8)*i] %Simètrica conjugada
         R=[XOUT(1,9)+XOUT(1,10)*i];
    otherwise
     fprintf('Invalid case\n' );
   end
%Comprabar Qc y R
P=diag([2,2]);
k=50
while k>=1
K(k,:)=inv(R+gamma'*P*gamma)*gamma'*P*phi;
P=(phi-gamma*K(k,:))'*P*(phi-gamma*K(k,:))+Qc+K(k,:)'*R*K(k,:); %equivalente a la matriz P
k=k-1;
end
%dlqr(phi,gamma,Qc,R)


 
