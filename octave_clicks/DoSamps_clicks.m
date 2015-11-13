## This script generates audio samples in directory samps/

function DoSamps_clicks()

[iwoke fs] = auload("source/iwoke.wav");

rand("seed",71077345);
[id noise] = fake_noise (rows(iwoke), 0.93, 0.65, 0.8, 10000);
iwclicks=iwoke+noise;
ind = abs(iwclicks) > 1;
iwclicks(ind) = sign(iwclicks(ind));

lead_in = 1024;
lead_out = 1024;

p = 31;
q = 31;
w = 1024;

count = floor((length(iwoke)-lead_out-lead_in)/w);  # number of windows
low = lead_in+1;
high = lead_in+count*w;

ausave("samps/iwclicks.wav", iwclicks(low:high), fs, "short")

##

threshold = 5;
fatness = 2;
interp_iters = 3;

[x id] = do_arsin_process(iwclicks, p, q, w, lead_in, lead_out, \
			  threshold, fatness, interp_iters);

ausave("samps/iwproc-50-02.wav", x(low:high), fs, "short")

##

threshold = 3;
fatness = 4;
interp_iters = 3;

[x id] = do_arsin_process(iwclicks, p, q, w, lead_in, lead_out, \
			  threshold, fatness, interp_iters);

ausave("samps/iwproc-30-04.wav", x(low:high), fs, "short")

##

threshold = 5;
fatness = 4;
interp_iters = 3;

[tina fs] = auload("source/tina.wav");

[x id] = do_arsin_process(tina, p, q, w, lead_in, lead_out, threshold, \
			  fatness, interp_iters);

ausave("samps/tina-proc-50-04.wav",x,fs,"short")

##

[hatari fs] = auload("source/hatari.wav");

[x id] = do_arsin_process(hatari, p, q, w, lead_in, lead_out, threshold, \
			  fatness, interp_iters);

ausave("samps/hatari-proc-50-04.wav",x,fs,"short")

##

[brady fs] = auload("source/brady.wav");

[x id] = do_arsin_process(brady, p, q, w, lead_in, lead_out, threshold, \
			  fatness, interp_iters);

ausave("samps/brady-proc-50-04.wav",x,fs,"short")

##

[cali fs] = auload("source/cali.wav");

[x id] = do_arsin_process(cali, p, q, w, lead_in, lead_out, threshold, \
			  fatness, interp_iters);

ausave("samps/cali-proc-50-04.wav",x,fs,"short")

