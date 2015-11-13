## SINEWAV generate sine wave of amplitude 1 at given frequency

function [s] = sinewav(n, freq, fs)

## freq, fs in hertz

t=0:n-1;

s = sin((2*pi*freq/fs).*(t'));

