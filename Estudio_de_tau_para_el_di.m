syms a b
A=[0 1;0 0];
B=[0;1];
h=0.32
[k,tau,p]=gacker(A,B,h,[a+b*i,-20]);
ff= matlabFunction(tau(1),'vars',[a b]);
X=linspace(-1,-0.1);
Y=linspace(-1,1);
[X,Y]=meshgrid(X,Y);
Z=ff(X,Y);
Z=real(Z);
figure
surfc(X,Y,Z);
ff= matlabFunction(tau(2),'vars',[a b]);
Z=ff(X,Y);
Z=real(Z);
hold on 
%surfc(X,Y,Z);
