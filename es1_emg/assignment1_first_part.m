%% Step 1: Load the .mat file
load('ES1_emg.mat');

% Extract EMG signal and sampling frequency
Fs = 2000; % Sampling frequency
emg_signal = Es1_emg.matrix(:, 1);

t = (0:length(emg_signal)-1)/Fs; % Time vector

%% Step 2: Band-pass Filtering (30-450 Hz FIR filter)
filter_order = 200;
low_cutoff = 30 / (Fs/2); % Normalize by Nyquist frequency
high_cutoff = 450 / (Fs/2);
bp_fir = fir1(filter_order, [low_cutoff, high_cutoff], 'bandpass');
filtered_emg = filtfilt(bp_fir, 1, emg_signal);

%% Step 3: Rectification
rectified_emg = abs(filtered_emg);

%% Step 4: Envelope Computation (Low-pass filter at 3-6 Hz)
env_cutoff = 6 / (Fs/2);
env_fir = fir1(filter_order, env_cutoff, 'low');
envelope = filtfilt(env_fir, 1, rectified_emg);

%% Step 5: Down-sampling (Reduce by factor of 10)
down_factor = 10;
downsampled_time = t(1:down_factor:end);
downsampled_env = envelope(1:down_factor:end);
downsampled_emg = filtered_emg(1:down_factor:end);
downsampled_movement = Es1_emg.matrix(1:down_factor:end, 3); % Assume Acc:Y as movement signal

%% Plot results
figure(1);

% Panel 1: Raw vs. Filtered EMG
subplot(3,1,1);
plot(t, emg_signal, 'k'); hold on;
plot(t, filtered_emg, 'r');
title('Raw EMG vs. Filtered EMG');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Raw EMG', 'Filtered EMG');

% Panel 2: Rectified vs. Envelope
subplot(3,1,2); 
plot(t, rectified_emg, 'k'); hold on;
plot(t, envelope, 'r');
title('Rectified EMG vs. Envelope');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Rectified EMG', 'Envelope');

% Panel 3: Movement vs. Envelope
subplot(3,1,3);
plot(downsampled_time, (downsampled_movement*100)+70, 'k'); hold on;
plot(downsampled_time, downsampled_env, 'r');
title('Movement(Y axis) vs. Envelope');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Movement Signal', 'Envelope');

hold off;


%%  Questions
% Question1: Why is the down-sampling performed after the envelope computation?
% Answer1: 
% The envelope is computed using a low-pass filter, which requires a sufficient 
% number of samples to achieve a smooth and accurate representation.
% If down-sampling were performed BEFORE envelope computation, 
% the raw EMG would lose high-frequency details, making the rectified 
% signal less accurate also it could introduce aliasing.
% We ensured an accurate envelope by filtering and reduced computational
% load only at the final step


% Question2: Based on the motion signal, when does the muscle activation 
% commence in relation to the movement?
% Answer2: Muscle activation commences before the movement.
% This happens because the nervous system sends signals to the muscles 
% in advance to prepare for the motion. This pre-activation is essential 
% for stability, coordination, and efficient movement execution