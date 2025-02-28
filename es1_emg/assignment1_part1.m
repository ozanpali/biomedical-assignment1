clear;clc;

%Part 1 Upload and filter the raw EMG signal
load('ES1_emg.mat')

% Sampling frequency (Hz) - replace with your actual EMG sampling frequency
fs = 1000;

% Bandpass filter specifications
low_cutoff = 30; % lower cutoff frequency in Hz
high_cutoff = 450; % upper cutoff frequency in Hz
filter_order = 100; % order of the FIR filter (adjust as needed)

% Design the FIR filter
bp_filter = designfilt('bandpassfir', 'FilterOrder', filter_order, ...
                       'CutoffFrequency1', low_cutoff, 'CutoffFrequency2', high_cutoff, ...
                       'SampleRate', fs);

% Initialize filtered signal matrix
filtered_emg_signal = zeros(size(Es1_emg.matrix));

% Apply zero-phase filtering to each channel (each column)
for col = 1:size(Es1_emg.matrix, 2)
    filtered_emg_signal(:, col) = filtfilt(bp_filter, Es1_emg.matrix(:, col));
end

% Plot the original and filtered signals for the first channel as an example
% figure;
subplot(5,1,1);
plot(Es1_emg.matrix(:,1));
title('Raw EMG Signal - Channel 1');
xlabel('Sample');
ylabel('Amplitude');

subplot(5,1,2);
plot(filtered_emg_signal(:,1));
title('Filtered EMG Signal (30-450 Hz) - Channel 1');
xlabel('Sample');
ylabel('Amplitude');


% Rectify signal

rectified_filtered_emg_signal = abs(filtered_emg_signal);

% Plot the rectified signal for the first channel as an example
% figure;
subplot(5,1,3);
plot(rectified_filtered_emg_signal(:,1));
title('Rectified EMG Signal - Channel 1');
xlabel('Sample');
ylabel('Amplitude');



% Part 4 Compute the envelope

% Sampling frequency (Hz) - replace with your actual EMG sampling frequency
fs = 1000;

% Low-pass filter specifications for the envelope (3-6 Hz)
low_cutoff = 3; % lower cutoff frequency in Hz
high_cutoff = 6; % upper cutoff frequency in Hz
filter_order = 100; % order of the FIR filter

% Design the low-pass FIR filter for the envelope
lp_filter = designfilt('lowpassfir', 'FilterOrder', filter_order, ...
                       'CutoffFrequency', high_cutoff, 'SampleRate', fs);

% Apply the filter to each channel of the rectified signal to get the envelope
envelope_signal = zeros(size(rectified_filtered_emg_signal));
for col = 1:size(rectified_filtered_emg_signal, 2)
    envelope_signal(:, col) = filtfilt(lp_filter, rectified_filtered_emg_signal(:, col));
end

% Plot the envelope for the first channel as an example
% figure;
subplot(5,1,4);
plot(envelope_signal(:,1));
title('EMG Signal Envelope - Channel 1');
xlabel('Sample');
ylabel('Amplitude');


% Part 5 Down-sample the signal

% Down-sampling factor (adjust as needed)
downsample_factor = 10;

% Down-sample the envelope signal for each channel
downsampled_envelope_signal = downsample(envelope_signal, downsample_factor);

% Plot the down-sampled envelope for the first channel as an example
% figure;
subplot(5,1,5);
plot(downsampled_envelope_signal(:,1));
title('Down-sampled EMG Signal Envelope - Channel 1');
xlabel('Sample');
ylabel('Amplitude');