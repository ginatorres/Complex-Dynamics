syms a b
A=[0 1;0 0];
B=[0;1];
h=0.32
[k,tau,p]=gacker(A,B,h,[a+b*i,0.5]);
ff= matlabFunction(tau(1),'vars',[a b]);
X=linspace(-1,1);
Y=linspace(-1,1);
[X,Y]=meshgrid(X,Y);
ZZ=ff(X,Y);
Z=real(ZZ).*(imag(ZZ)<0.0001);
figure
surfc(X,Y,Z);
figure 
%ezplot(tau(1)-h,[-1 1 -1 1])
hold on
ezplot(tau(1),[-1 1 -1 1])
