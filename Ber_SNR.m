
N = 1e5;                          
SNR_dB_range = 0:2:14;         
ber_vals = zeros(size(SNR_dB_range));  


for i = 1:length(SNR_dB_range)
    % 1. Bit generation
    tx_bits = randi([0 1], 1, N);
    
    % 2. BPSK modulation
    tx_symbols = 2*tx_bits - 1;
    
    % 3. AWGN channel
    rx_symbols = awgn(tx_symbols, SNR_dB_range(i), 'measured');
    
    % 4. BPSK demodulation
    rx_bits = rx_symbols > 0;
    
    % 5. BER calculation
    [~, ber_vals(i)] = biterr(tx_bits, rx_bits);
end

% Plotting
figure;
semilogy(SNR_dB_range, ber_vals, 'bo-', 'LineWidth', 1.5);
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs. SNR for BPSK over AWGN Channel');
