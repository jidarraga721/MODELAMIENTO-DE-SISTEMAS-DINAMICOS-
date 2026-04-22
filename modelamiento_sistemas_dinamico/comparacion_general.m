% ==========================================================
% COMPARACIÓN GENERAL:
% Datos Reales + 3 Modelos Identificados
% ==========================================================
close all;
clear;
clc;

%% ===============================
% Cargar datos experimentales
% ===============================
Datos = readmatrix('Datosppp.xls');

t = Datos(:,1);      
U = Datos(:,2);      
T = Datos(:,3);      

% Normalización de la señal real
T1 = T - 25.2688172;

A = max(U);

s = tf('s');

%% ==========================================================
% MODELO 1: ALFARO (IMPLEMENTACIÓN CORRECTA EN TIEMPO)
% ==========================================================
K1     = 0.86205;
tau1   = 152.414;
td1    = 28.3295;
t_step = 4.5;

y1 = zeros(size(t));

for i = 1:length(t)
    
    t_eff = t(i) - t_step - td1;
    
    if t_eff > 0
        y1(i) = K1 * A * (1 - exp(-t_eff / tau1));
    else
        y1(i) = 0;
    end
    
end

%% ==========================================================
% MODELO 2: Primer Orden Toolbox
% ==========================================================
K2   = 0.86205;
tau2 = 152.4145;
td2  = 28.3295;

G2 = K2 * exp(-td2*s) / (tau2*s + 1);

% Normalizar tiempo para toolbox
t_tool = t - t(1);

[y2, t2] = step(A * G2, t_tool);

%% ==========================================================
% MODELO 3: Segundo Orden Toolbox
% ==========================================================
K3  = 0.84291;
tp1 = 142.9955;
tp2 = 27.929;
td3 = 20;

G3 = K3 * exp(-td3*s) / ((tp1*s + 1)*(tp2*s + 1));

[y3, t3] = step(A * G3, t_tool);

%% ==========================================================
% ERRORES
% ==========================================================
ECM1 = mean((T1 - y1).^2);
ECM2 = mean((T1 - y2).^2);
ECM3 = mean((T1 - y3).^2);

%% ==========================================================
% GRÁFICA FINAL
% ==========================================================
figure('Name','Comparación General de Modelos', ...
       'NumberTitle','off');

plot(t, T1, 'y', 'LineWidth', 2); hold on;

%  Alfaro (correcto y desplazado)
plot(t, y1, '--black', 'LineWidth', 3);

%  Primer orden toolbox
plot(t2, y2, '--red', 'LineWidth', 2);

%  Segundo orden
plot(t2, y3, '--c', 'LineWidth', 2);

grid on;
xlabel('Tiempo (s)');
ylabel('Temperatura (°C)');
title('Comparación entre Datos Reales y Modelos');

legend('Datos reales', ...
       'Alfaro ', ...
       'Primer Orden Toolbox', ...
       'Segundo Orden Toolbox', ...
       'Location','best');

xlim([0 max(t)])

%% ==========================================================
% MOSTRAR ERRORES
% ==========================================================
disp('============== ERRORES CUADRÁTICOS MEDIOS ==============')
disp(['Modelo Alfaro           = ', num2str(ECM1)])
disp(['Primer Orden Toolbox    = ', num2str(ECM2)])
disp(['Segundo Orden Toolbox   = ', num2str(ECM3)])