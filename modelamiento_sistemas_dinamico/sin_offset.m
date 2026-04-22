% ==========================================================
% DATOS SIN OFFSET + ESCALÓN BIEN POSICIONADO
% ==========================================================
clc;
clear;
close all;

%% ===============================
% (1) CARGA DE DATOS
% ===============================
Datos = readmatrix('Datosppp.xls');

t = Datos(:,1);
U = Datos(:,2);
T = Datos(:,3);

%% ===============================
% (2) DETECTAR ESCALÓN
% ===============================
idx_step = find(U > 0, 1);

%% ===============================
% (3) ELIMINAR OFFSET
% ===============================
y0 = mean(T(1:idx_step-1));
T_sin_offset = T - y0;

%% ===============================
% (4) ESCALAR ESCALÓN (AJUSTE FINO)
% ===============================
% Escalamos un poco por debajo del máximo
factor = 0.95;   %  AJUSTA ESTE VALOR (0.9 – 1.0)

U_plot = (U / max(U)) * max(T_sin_offset) * factor;

%% ===============================
% (5) GRÁFICA
% ===============================
figure('Color',[1 1 1]);
hold on;

plot(t, T_sin_offset, 'y', 'LineWidth', 1.6);
plot(t, U_plot, '--b', 'LineWidth', 2.2);

grid on;
box on;

xlabel('Tiempo (s)');
ylabel('Temperatura (°C)');
title('Datos experimentales sin offset');

legend('Datos reales','Señal escalón','Location','best');

xlim([0 max(t)]);

hold off;