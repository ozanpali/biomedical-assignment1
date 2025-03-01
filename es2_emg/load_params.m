    % Step 1: Load the data

Fs = 2000;  % Sampling frequenc
load('ES2_emg.mat') %loading data to matlab
data.time = ES2_emg.time;  % Assign time vector
data.signals.values = ES2_emg.signals;  % Assign signal values



% Step 2: Design a bandpass FIR filter (30-450 Hz)
nyquist = Fs / 2;
low = 30 / nyquist;
high = 450 / nyquist; %adjust the freq as giving.

filter_order = 100;  % Adjust as needed

% calculating the coefficient of bandpass filter 
b = fir1(filter_order, [low, high], 'band'); 

% Step 3    : Design a low-pass FIR filter (3-6 Hz)
lowpass_low = 3 / nyquist;
lowpass_high = 6 / nyquist;
lp_filter_order = 50;  % Adjust as needed

% calculating the coefficient of lowband filter 
lp_b = fir1(lp_filter_order, lowpass_high, 'low'); 

