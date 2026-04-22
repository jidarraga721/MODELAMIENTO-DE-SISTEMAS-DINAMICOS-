%% ==========================================================
% COMPARACION: DATOS EXPERIMENTALES vs MODELO (TOOLBOX)
% ==========================================================
clc;
clear;
close all;

%% ==========================================
% (1) LECTURA DE DATOS
% ==========================================
Datos = xlsread('Datosppp.xls');

t = Datos(:,1);        % vector de tiempo
U = Datos(:,2);        % señal de entrada
T = Datos(:,3);        % salida medida

%% ==========================================
% (2) PARAMETROS DEL MODELO IDENTIFICADO
% ==========================================
K     = 0.86205;
tau   = 152.4145;
tdead = 28.3295;


%% ==========================================
% (3) DEFINICION DEL SISTEMA
% G(s) = K * e^(-Td*s) / (tau*s + 1)
% ==========================================
s = tf('s');
Gp = K * exp(-tdead*s) / (tau*s + 1);

%% ==========================================
% (4) SIMULACION DE RESPUESTA
% ==========================================
A = max(U);                     % magnitud del escalón
y_model = step(A * Gp, t);

%% ==========================================
% (5) AJUSTE DE SEÑAL REAL
% ==========================================
T1 = T - 25.2688172;

%% ==========================================
% (6) VISUALIZACION COMPARATIVA
% ==========================================
figure('Name','Comparacion Modelo vs Real', ...
       'NumberTitle','off');

plot(t, T1, 'y', 'LineWidth', 2); hold on;
plot(t, y_model, '--red', 'LineWidth', 2);

xlabel('Tiempo (s)');
ylabel('Temperatura (°C)');
title('Modelo de Primer Orden');

legend('Datos reales', 'Modelo Toolbox', 'Location', 'best');
grid on;

xlim([0 max(t)]);

%% ==========================================
% (7) METRICA DE ERROR
% ==========================================
ECM = mean((T1 - y_model).^2);

disp(['ECM calculado = ', num2str(ECM)]);