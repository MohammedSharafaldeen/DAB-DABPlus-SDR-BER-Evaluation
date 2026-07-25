clc; clear;
N = 1024;
Rb = 1e3;
amplitude = 1;
Tb = 1 / Rb;
samplesPerBit = 100;
Fs = Rb * samplesPerBit;
Fc = 2 * Rb;
frameLength = N * samplesPerBit;


tx = sdrtx('Pluto', ...
    'CenterFrequency', 915e6, ...
    'BasebandSampleRate', Fs, ...
    'Gain', -10);

rx = sdrrx('Pluto', ...
    'CenterFrequency', 915e6, ...
    'BasebandSampleRate', Fs, ...
    'SamplesPerFrame', frameLength, ...
    'OutputDataType', 'double', ...
    'GainSource', 'Manual', ...
    'Gain', 30);

figure('Color', [0 0 0], 'Name', 'Live BPSK Simulation', 'NumberTitle', 'off');

disp('🔴 Live BPSK test started. Press Ctrl+C to stop.');

while true
    % Generate random data
    data = randi([0 1], 1, N);
    bits = 2 * data - 1; 
    txSignalNRZ = repelem(bits, samplesPerBit);
    t = 0 : 1/Fs : length(txSignalNRZ)/Fs - 1/Fs;

  
    carrier = cos(2 * pi * Fc * t);
    bpsk = txSignalNRZ .* carrier;
    txIQ = complex(bpsk.');

 
    tx(txIQ);

    % Receive
    try
        rxIQ = rx();
    catch
        disp("⚠️ RX timeout or Pluto error. Retrying...");
        continue;
    end

    received = real(rxIQ(:)).';
    t_rx = 0:1/Fs:(length(received)-1)/Fs;

    % Demodulate 
    phaseOffsets = linspace(-pi, pi, 16);
    bestBER = 1;
    bestY = zeros(1, N);

    for k = 1:length(phaseOffsets)
        rxCarrier = cos(2 * pi * Fc * t_rx + phaseOffsets(k));
        mixed = received .* rxCarrier;

        y = zeros(1, N);
        for i = 0:(N - 1)
            midSample = round((i + 0.5) * samplesPerBit);
            if midSample > length(mixed)
                break;
            end
            y(i + 1) = mixed(midSample);
        end

        estimatedBits = y >= 0;
        validLen = min(length(estimatedBits), length(data));
        currentBER = mean(xor(estimatedBits(1:validLen), data(1:validLen)));

        if currentBER < bestBER
            bestBER = currentBER;
            bestY = y;
            bestPhase = phaseOffsets(k);
        end
    end

    % Plot Transmitter
    subplot(2,1,1);
    stem(bits(1:20), 'filled', 'MarkerSize', 4, 'Color', 'cyan');
    title('Transmitted NRZ Bits', 'Color', 'white');
    ylim([-1.5 1.5]);
    grid on;
    set(gca, 'Color', 'k', 'XColor', 'white', 'YColor', 'white');

    % Plot Receiver
    subplot(2,1,2);
    stem(bestY(1:20) / max(abs(bestY)), 'filled', 'MarkerSize', 4, 'Color', 'magenta');
    title(['Received Samples - BER = ', num2str(bestBER, '%.4f'), ', Phase = ', num2str(bestPhase, '%.2f')], 'Color', 'white');
    ylim([-1.5 1.5]);
    grid on;
    set(gca, 'Color', 'k', 'XColor', 'white', 'YColor', 'white');

    drawnow;
end
