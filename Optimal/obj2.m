function result=obj2(Qx)
global phi;
global gamma;
global Kcomplex
k=50;
Qc=[Qx(1,1) Qx(1,2);Qx(1,3) Qx(1,4)]
R=[Qx(1,5)+Qx(1,6)*i]
%Solución de la Ecuación de Riccatti
k=50;
P=diag([2,2]);
while k>=1
K(k,:)=inv(R+gamma'*P*gamma)*gamma'*P*phi;
P=(phi-gamma*K(k,:))'*P*(phi-gamma*K(k,:))+Qc+K(k,:)'*R*K(k,:); %equivalente a la matriz P
k=k-1;
end
%Función objetivo.
result=norm(K(1,:)-Kcomplex).^2