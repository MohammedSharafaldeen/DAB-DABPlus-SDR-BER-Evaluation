% Step 1: Generate Random Bits
N = 10000;                          % Number of bits
tx_bits = randi([0 1], 1, N);       % Random binary bit stream

% Step 2: BPSK Modulation
tx_symbols = 2*tx_bits - 1;       
% Step 3: AWGN Channel
SNR_dB = 5;                         
rx_symbols = awgn(tx_symbols, SNR_dB, 'measured');  % Add white Gaussian noise

% Step 4: Matched Filtering 

matched_rx = rx_symbols;          

% Step 5: BPSK Demodulation
rx_bits = matched_rx > 0;         

% Step 6: BER Calculation
[num_errors, ber] = biterr(tx_bits, rx_bits);  % Count bit errors
fprintf('BER = %f, Number of Errors = %d\n', ber, num_errors);
figure;
stem(tx_symbols(1:100), 'filled');
title('Transmitted BPSK Symbols (First 100)');
xlabel('Symbol Index'); ylabel('Amplitude');
grid on;

% Plot Received Noisy Signal (First 100 samples)
figure;
stem(rx_symbols(1:100), 'filled');
title(['Received Signal with AWGN (SNR = ', num2str(SNR_dB), ' dB)']);
xlabel('Symbol Index'); ylabel('Amplitude');
grid on;
