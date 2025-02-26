% Load the EMG data
data = load('ES1_emg.mat');  % Load the file
emg_signal = data.Es1_emg.matrix;      % Extract the EMG matrix
fs = 2000;  % Sampling frequency (assumed, change if needed)

% Design a band-pass FIR filter (30-450 Hz)
bpFilt = designfilt('bandpassfir', 'FilterOrder', 100, ...
    'CutoffFrequency1', 30, 'CutoffFrequency2', 450, ...
    'SampleRate', fs);

% Apply zero-phase filtering to avoid phase distortion
filtered_emg = filtfilt(bpFilt, emg_signal);

% Rectify the signal (full-wave rectification)
rectified_emg = abs(filtered_emg);

% Design a low-pass FIR filter for the envelope (3-6 Hz)
lpFilt = designfilt('lowpassfir', 'FilterOrder', 100, ...
    'CutoffFrequency', 6, 'SampleRate', fs);

% Apply zero-phase filtering for the envelope detection
envelope_emg = filtfilt(lpFilt, rectified_emg);

% Downsample the signal (reduce sampling rate)
downsample_factor = 10;  % Change this factor as needed
downsampled_emg = downsample(envelope_emg, downsample_factor);
new_fs = fs / downsample_factor;

% Plot results
t = (0:length(emg_signal)-1) / fs;
t_ds = (0:length(downsampled_emg)-1) / new_fs;

figure(2);
subplot(4,1,1);
plot(t, emg_signal);
title('Raw EMG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4,1,2);
plot(t, filtered_emg);
title('Band-pass Filtered EMG');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4,1,3);
plot(t, envelope_emg);
title('EMG Envelope');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4,1,4);
plot(t_ds, downsampled_emg);
title('Downsampled EMG Envelope');
xlabel('Time (s)');
ylabel('Amplitude');

% Save the processed EMG data
save('/mnt/data/processed_emg.mat', 'filtered_emg', 'rectified_emg', 'envelope_emg', 'downsampled_emg', 'new_fs');
