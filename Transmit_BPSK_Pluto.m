
tx = sdrtx('Pluto', ...
    'CenterFrequency', 2.4e9, ...           % 2.4 GHz
    'BasebandSampleRate', 1e6, ...         % 1 MSps
    'Gain', -10);                          % Transmission gain in dB


N = 10000;                                 % Number of bits
bits = randi([0 1], 1, N);                 % Random binary sequence


symbols = 2*bits - 1;                      % BPSK mapping: 0 → -1, 1 → +1


samplesPerSymbol = 10;                     % Oversampling factor
txSignal = upsample(symbols, samplesPerSymbol);


txSignal = txSignal / max(abs(txSignal));  % Normalize to unit amplitude
txSignal = complex(txSignal, zeros(size(txSignal)));  % Make signal complex

transmitRepeat(tx, txSignal.');
disp('Transmitting BPSK signal via PlutoSDR...');
save('tx_bits.mat', 'bits');