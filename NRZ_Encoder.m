function [time, nrzData, Fs] = NRZ_Encoder(data, Rb, amplitude, type)
    Tb = 1 / Rb;
    samplesPerBit = 100;
    Fs = Rb * samplesPerBit;
    time = 0 : 1/Fs : length(data)*Tb - 1/Fs;
    nrzData = zeros(1, length(time));
    for i = 1:length(data)
        idx = (i-1)*samplesPerBit + 1 : i*samplesPerBit;
        if strcmpi(type, 'Polar')
            nrzData(idx) = amplitude * (2*data(i) - 1);
        elseif strcmpi(type, 'Unipolar')
            nrzData(idx) = amplitude * data(i);
        else
            error('Invalid NRZ type');
        end
    end
end
