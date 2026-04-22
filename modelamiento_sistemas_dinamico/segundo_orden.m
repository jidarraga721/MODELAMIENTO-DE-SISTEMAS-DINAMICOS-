% ==========================================================
% LIMPIAR ENTORNO
% ==========================================================
clc;
clear;
close all;

%% =========================================================
% LECTURA DE DATOS
% ==========================================================
Datos = xlsread('Datosppp.xls');

t = Datos(:,1);        % vector de tiempo
U = Datos(:,2);        % señal de entrada
T = Datos(:,3);  

T1 = T - 25.2688172;
%% =========================================================
% PARÁMETROS DEL MODELO (SEGUNDO ORDEN)
% ==========================================================
K   = 0.84291;
tp1 = 142.9955;
tp2 = 27.929;
td  = 20;   % retardo (no utilizado)

%% =========================================================
% DEFINICIÓN DE LA FUNCIÓN DE TRANSFERENCIA
% G(s) = K / [(tp1*s + 1)(tp2*s + 1)]
% ==========================================================
s = tf('s');
Gp = K * exp(-td*s) / ((tp1*s + 1)*(tp2*s + 1));

%% =========================================================
% SIMULACIÓN DEL SISTEMA
% ==========================================================
A = max(U);                      % amplitud de la señal
y_model = step(Gp * A, t);       % respuesta del modelo

% Ajuste opcional de condición inicial
% y_model = y_model + T(1);

%% =========================================================
% ELIMINACIÓN DE OFFSET
% ==========================================================


%% =========================================================
% GRÁFICA COMPARATIVA
% ==========================================================
figure;

plot(t, T1, 'y', 'LineWidth', 2); hold on;
plot(t, y_model, '--c', 'LineWidth', 2);

grid on;
title('Modelo de Segundo Orden');
xlabel('Tiempo (s)');
ylabel('Temperatura (°C)');

legend('Datos reales ', 'Modelo', 'Location', 'best');

xlim([0 max(t)]);

%% =========================================================
% CÁLCULO DE ERRORES
% ==========================================================
ECM = immse(T1, y_model);
RMSE = sqrt(ECM);

fprintf('Error cuadrático medio: %.6f\n', ECM);
fprintf('RMSE: %.6f °C\n', RMSE);