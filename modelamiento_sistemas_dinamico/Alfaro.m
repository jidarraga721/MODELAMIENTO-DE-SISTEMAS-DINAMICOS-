% =========================================================================
% IDENTIFICACIÓN DE SISTEMAS: VALIDACIÓN DEL MÉTODO DE ALFARO (1ER ORDEN)
% Proyecto: Laboratorio de Sistemas Dinámicos
% =========================================================================

clc; clear; close all;

%% 1. CARGA DE DATOS EXPERIMENTALES
% -------------------------------------------------------------------------
try
    % Carga del archivo (Asegúrate de que 'Datosppp.xls' esté en tu carpeta)
    Datos = readmatrix('Datosppp.xls');
    t_raw = Datos(:,1);   % Tiempo (s)
    u_raw = Datos(:,2);   % Entrada (Escalón)
    y_raw = Datos(:,3);   % Temperatura medida (°C)
catch
    error('Error: No se encontró "Datosppp.". Verifica la ubicación del archivo.');
end

%% 2. PARÁMETROS IDENTIFICADOS (MÉTODO DE ALFARO)
% -------------------------------------------------------------------------
Kp     = 0.86205;   % Ganancia estática del sistema
tau    = 152.414;   % Constante de tiempo (s)
tdead  = 28.3295;   % Tiempo muerto (s)
t_step = 4.5;       % Instante de aplicación del escalón (s)
A      = 57.0;      % Amplitud del escalón de entrada

%% 3. PRE-PROCESAMIENTO: ELIMINACIÓN DE OFFSET
% -------------------------------------------------------------------------
% y0: Temperatura inicial en el punto de operación antes del escalón
y0     = 25.61094819;      
y_norm = y_raw - y0;  % Normalizamos la señal para que inicie en 0

%% 4. DEFINICIÓN DEL MODELO MATEMÁTICO (FOPDT)
% -------------------------------------------------------------------------
% Función de Transferencia: G(s) = [Kp / (tau*s + 1)] * e^(-L*s)
s = tf('s');
Gp = (Kp / (tau*s + 1)) * exp(-tdead*s);

% Simulación de la respuesta del modelo ante el escalón de amplitud A
% Ajustamos el tiempo restando t_step para alinear con el inicio real
y_model = step(Gp * A, t_raw - t_step);

% Limpieza: Forzamos a cero los valores previos al tiempo de retardo total
y_model(t_raw < (t_step + tdead)) = 0;

%% 5. GRÁFICA DE COMPARACIÓN PROFESIONAL
% -------------------------------------------------------------------------
figure('Name', 'Identificación Alfaro', 'Color', [1 1 1], 'NumberTitle', 'off');
hold on;

% Definición de colores 
color_real   = [1, 1, 0];    
color_alfaro = [0, 0, 0];   

% Graficación de señales
p1 = plot(t_raw, y_norm, 'Color', color_real, 'LineWidth', 1.6);
p2 = plot(t_raw, y_model, '--', 'Color', color_alfaro, 'LineWidth', 2.2);

% Configuración estética del área de trazado (Ejes y Grid)
grid on;
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.5, 'FontSize', 11);
set(gca, 'TickLabelInterpreter', 'latex');
box on;

% Títulos y Etiquetas con intérprete LaTeX
title(' Modelo Alfaro', ...
      'Interpreter', 'latex', 'FontSize', 14);
xlabel('Tiempo (s)', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('Temperatura °C', ...
       'Interpreter', 'latex', 'FontSize', 12);

% Leyenda 
legend([p1, p2], {'Datos reales', 'Modelo de Alfaro '}, ...
       'Location', 'SouthEast', 'FontSize', 10, 'Interpreter', 'latex');

hold off;

%% 6. CÁLCULO DE MÉTRICAS DE ERROR Y RESULTADOS
% -------------------------------------------------------------------------
ECM = mean((y_norm - y_model).^2); % Error Cuadrático Medio

fprintf('\n================================================\n');
fprintf('       RESUMEN DE IDENTIFICACIÓN (ALFARO)\n');
fprintf('================================================\n');
fprintf(' Ganancia Estática (Kp):     %.5f\n', Kp);
fprintf(' Constante de Tiempo (tau):  %.2f s\n', tau);
fprintf(' Tiempo Muerto (tdead):      %.2f s\n', tdead);
fprintf('------------------------------------------------\n');
fprintf(' Error Cuadrático Medio (ECM): %.6f\n', ECM);
fprintf('================================================\n');