## This script generates figures in directory figs/

function DoFigs_hiss()

do_longcalc = 0;

grid("on")

[iwoke fs] = auload("source/iwoke.wav");

##

rand("seed",71077345);
white = randn(length(iwoke),1);
white = white .* sqrt(0.0015); # variance 0.0015

iwhiss = iwoke + white;

s_d = est_power(white, 2048, 4);

iwwien = do_wiener(iwhiss, 2048, 4, s_d, 1, 0);

range = 30721:31220;
range = range + 1024;

axis([0 500 -0.6 0.6])

plot(iwoke(range))

xlabel("sample")
ylabel("amplitude")

legend("off")

print("-deps2", "figs/cleanwav.eps")

plot(iwhiss(range))

xlabel("sample")
ylabel("amplitude")

legend("off")

print("-deps2", "figs/hisswav.eps")

plot(iwwien(range))

xlabel("sample")
ylabel("amplitude")

legend("off")

print("-deps2", "figs/wienwav.eps")

axis("auto")

##

dbrange = (-20:20)';
psnrange = 10.^(dbrange./10);

powdb=20.*log10(sqrt((1-1./(psnrange +1))));
wiendb=20.*log10(1-1./(psnrange +1));

axis([-20 20 -45 5])

plot(dbrange,[powdb wiendb])

legend("power subtraction","Wiener",2)
legend("boxon")
ylabel("gain (db)")
xlabel("a posteriori SNR (db)")

print("-deps2", "figs/wienpowgain.eps")


psn20 = 10^(20/10);
psn0 = 10^(0/10);
psnn20 = 10^(-20/10);

em20db = 20.*log10(test_emcalc(psnrange, psn20, 0, 0));
em0db = 20.*log10(test_emcalc(psnrange, psn0, 0, 0));
emn20db = 20.*log10(test_emcalc(psnrange, psnn20, 0, 0));

plot(dbrange , [emn20db em0db em20db])

legend("R_{post} = -20dB","R_{post} =    0dB","R_{post} =  20dB",2)
legend("boxon")
ylabel("gain (db)")
xlabel("a priori SNR (db)")

print("-deps2", "figs/emsrgain.eps")


emeqdb = 20.*log10(test_emcalc(psnrange, psnrange, 0, 0));

plot(dbrange , [powdb emeqdb])

legend("power subtraction","Ephraim Malah",2)
legend("boxon")
ylabel("gain (db)")
xlabel("a posteriori = a priori SNR (db)")

print("-deps2", "figs/emsrgain_eq.eps")


axis("auto")
