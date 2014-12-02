clear all
x = linspace(-20,-1,10);
y = linspace(0,10);
[X,Y] = meshgrid(x,y);
%%Planta del Doble Integrador
A=[0 1;0 0]
%A=rand(3)
B=[0;1]
%B=rand(3,1)
C=[1 0]
%C=rand(1,3)
D=[0]

n=size(A,2)
h=1
p1=-1+0.5i
p2=p1'
p3=-2
digits(4)
taux=[];
I=[];
c=1;
Z=[];
ys=Y(:)';
for j=X(:)'
     k=ys(c)
        polos= exp([j+k*i,p3]*h);
        [k,tau]=gacker(A,B,h,polos);
        Z(c)=tau(1);
        c=c+1;
end
Z=reshape(Z,size(X))'
%GRAFICAR
contour(X,Y,Z)%CHECK DIMENSIONS!

