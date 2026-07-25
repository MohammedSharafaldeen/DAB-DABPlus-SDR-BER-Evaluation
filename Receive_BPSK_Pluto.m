rx = sdrrx('Pluto', ...
    'CenterFrequency', 2.4e9, ...
    'BasebandSampleRate', 1e6, ...
    'SamplesPerFrame', 100000, ...
    'OutputDataType', 'double');

rxSignal = rx();
release(rx);

samplesPerSymbol = 10;

% Matched filter: rectangular pulse
mfilt = ones(1, samplesPerSymbol);
filtered = conv(real(rxSignal), mfilt, 'same');

% Trim beginning and end to avoid convolution edge effects
trimmed = filtered(5000:end-5000);

% Downsample at symbol rate
rxDown = trimmed(1:samplesPerSymbol:end);

% Demodulate
rxBits = rxDown > 0;

% Load original bits
load('tx_bits.mat', 'bits');
minLen = min(length(rxBits), length(bits));
rxBits = rxBits(1:minLen);
txBits_trimmed = bits(1:minLen);

[~, ber_hw] = biterr(txBits_trimmed(:).', rxBits(:).');
fprintf('BER after matched filtering = %.5f\n', ber_hw);

figure;
plot(real(rxSignal));
title('Received Signal from PlutoSDR');
xlabel('Sample Index'); ylabel('Amplitude');
grid on;
