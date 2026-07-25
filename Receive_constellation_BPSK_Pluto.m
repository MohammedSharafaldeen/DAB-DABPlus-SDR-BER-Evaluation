% Load received signal from previous Pluto capture
rx = sdrrx('Pluto', ...
    'CenterFrequency', 2.4e9, ...
    'BasebandSampleRate', 1e6, ...
    'SamplesPerFrame', 100000, ...
    'OutputDataType', 'double');

rxSignal = rx();
release(rx);

samplesPerSymbol = 10;

% --------- PLOT 1: Time-Domain Received Signal ---------
figure;
plot(real(rxSignal));
title('Received Signal from PlutoSDR');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% --------- PLOT 2: Constellation Diagram ---------------
rxDown = rxSignal(1:samplesPerSymbol:end);  % Downsample

figure;
plot(real(rxDown), imag(rxDown), 'o');
title('Received Constellation from PlutoSDR');
xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
axis equal;
grid on;
