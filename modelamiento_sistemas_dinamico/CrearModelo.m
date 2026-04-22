% modelos
close all;
clear all;

Datos = xlsread('Datosppp.xls');
%Gráfica_datos_originales
t = Datos(:,1);
U = Datos(:,2);
T = Datos(:,3);

figure ('Name','DatosOrig', 'NumberTitle','off');
plot(t,U,'--k', t,T,'LineWidth',1);
title('Datos originales')
xlim([0 1500]);
xlabel('t(s)')
ylabel('u [%], T[°C]')
grid;
legend('u(t)', 'T(t)');

%Gráfica_sin_offset
T1 = T-25.61;

figure ('Name','DatoNoOff', 'NumberTitle','off');
plot(t,U,'--k', t,T1,'LineWidth',1);
title('Datos sin offset')
xlim([0 1500]);
grid;
xlabel('t(s)')
ylabel('u [%], T[°C]')
legend('u1(t)', 'T1(t)');

%Probar_modelo
A = 57
tesc=5
tfin= 10
num=k;
den=[ta]
sim("SimPrueba2.slx", t)






