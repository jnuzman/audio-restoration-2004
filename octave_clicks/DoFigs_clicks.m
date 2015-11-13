## This script generates figures in directory figs/

function DoFigs_clicks()

do_longcalc = 0;

grid("on")

[iwoke fs] = auload("source/iwoke.wav");

w = 1024;
lead_in = 1024;
lead_out = 1024;

[AR C Freqs pe_ms_est sinresid_ms x_ms] = do_arsin_model(iwoke, 15, 0, \
							 w, lead_in, \
							 lead_out);

[PE x_init PE_back x_post] = do_arsin_filt(iwoke, AR, C, Freqs, w, \
					   lead_in, lead_out, 0);

PEvec = PE(:);
iwcrop = iwoke(1024+1:1024+length(PEvec));


range = 30721:31720;

##

plot(iwcrop(range))

xlabel("sample")
ylabel("amplitude")

legend("off")

print("-deps2", "figs/audiowav.eps")

##

plot([PEvec iwcrop](range,:))

legend("innovations process","audio waveform", 2)
legend("boxon")

print("-deps2", "figs/audio-innov.eps")

##

[AR C Freqs pe_ms_est sinresid_ms x_ms] = do_arsin_model(iwoke, 0, 31, \
							 w, lead_in, \
							 lead_out);

sinsynth = do_arsin_synth(AR, C, Freqs, zeros(rows(PE),columns(PE)), \
			  zeros(0,1));

plot([iwcrop sinsynth](range,:))

legend("original waveform", "sine approximation", 2)
legend("boxon")

print("-deps2", "figs/audio-sin.eps")

##

p = 31;
q = 31;
w = 1024;

[AR C Freqs pe_ms_est sinresid_ms x_ms] = \
    do_arsin_model(iwoke, p, q, w, lead_in, lead_out);

[PE x_init PE_back x_post] = \
    do_arsin_filt(iwoke, AR, C, Freqs, w, lead_in, lead_out, 1);

pe_std = std(PE);
pe_back_std = std(PE_back);

PE_norm = PE * diag(1./pe_std);
PE_back_norm = PE_back * diag(1./pe_back_std);

pe_vec = PE_norm(:);
pe_back_vec = PE_back_norm(:);

range = (-10:0.1:10)';
normpd = normal_pdf(range);

hist(pe_vec, 100, 1)
hold on
## 0.2 = (10 - -10) / 100
plot(range, 0.2*normpd)
hold off

xlabel("residual sample value (std devs)")
ylabel("probability")
legend("actual histogram","theoretical Gaussian",2)
legend("boxon")
grid("off")

print("-deps2","figs/gaussian.eps")

##

## use data from above

s_x = est_power(iwoke , 1024, 4);
s_n = est_power(pe_vec, 1024, 4);

semilogy([s_x s_n](1:513,:))

xlabel("frequency bin")
ylabel("power (log scale)")
legend("audio signal", "normalized residual", 2)
legend("boxon")
grid("on")

print("-deps2","figs/white.eps")

##

if (do_longcalc == 1)

  p = [0 1 5 15 31 61 121];
  q = p;
  w = 1024;

  ## took 35 mins on jugo
  [P_resid ps T_model T_filt] = testar(p, q, w, iwoke);

  save savedata/pq1024.mat p q w P_resid ps T_model T_filt

else

  load -force savedata/pq1024.mat p q w P_resid ps T_model T_filt

end

pdb = 10.*log10(P_resid ./ ps);

## for better looking graph, pretend 121 is 120
q1 = q;
q1(q == 121) = 120;
p1 = q1;

mesh(q1, p1, pdb)

view(120,15)

xlabel("sinusoid order Q")
ylabel("AR order P   ")
zlabel("dB")

grid("on")
legend("off")

print("-deps2","figs/pq1024.eps")

##

pdb(pdb > -30) = -30;

mesh(q1, p1, pdb)

view(120,15)

print("-deps2","figs/pq1024-clamp.eps")

##


if (do_longcalc == 1)

  p = 31;
  q = 31;
  w = [128 256 512 1024 2*1024 4*1024 8*1024 16*1024 32*1024 64*1024];

  ## took 6 mins on jugo
  [p_resid psw t_model t_filt] = testwin(p, q, w, iwoke);

  save savedata/winsize.mat p q w p_resid psw t_model t_filt

else

  load -force savedata/winsize.mat p q w p_resid psw t_model t_filt

end

plot(log2(w), (p_resid ./ psw))

xlabel("log_2(block size)")
ylabel("power ratio")

grid("on")
legend("off")

print("-deps2", "figs/winsize.eps")


##

rand("seed",71077345);
[id noise] = fake_noise (rows(iwoke), 0.93, 0.65, 0.8, 10000);
iwclicks=iwoke+noise;
ind = abs(iwclicks) > 1;
iwclicks(ind) = sign(iwclicks(ind));

idcropsum = sum(id(lead_in+1:lead_in+length(iwcrop)));

if (do_longcalc == 1)

  p = 31;
  q = 31;
  w = 1024;

  [idsums msdata ratiodata] = testdetect(p, q, w, iwoke, iwclicks, id); 

  save savedata/amplify3131.mat p q w idsums msdata ratiodata

##  [idsums msdata ratiodata] = testdetect(15, 31, 1024, iwoke, iwclicks, id);
##  save amplify1531.mat idsums msdata ratiodata

else

  load -force savedata/amplify3131.mat p q w idsums msdata ratiodata

end

table = ratiodata(1,:);   ## only deal with dirty/clean ratio
table = reshape(table,3,9);  ## each of 3 rows is an estimation method
table = table(:,[3 9]);  ## choose forward PE/robust stdev, min
			 ## PE/robust stddev
colnames = ["forward"; "minimum"];
rownames = ["noisy estimate"; "previous estimate"; "perfect estimate"];
save2tex(table,"figs/ratio31.tex",colnames,rownames,2,"c",1);


##

if ((do_longcalc == 1))

  p = 31;
  q = 31;
  w = 1024;


  ## use simple estimation
  [AR C Freqs pe_ms_est sinresid_ms x_ms] = \
      do_arsin_model(iwclicks, p, q, w, lead_in, lead_out);

  [PE x_init PE_back x_post] = \
      do_arsin_filt(iwclicks, AR, C, Freqs, w, lead_in, lead_out, 1);

  pestd_robust = median(abs(PE))./0.6745;
  pe_backstd_robust = median(abs(PE_back))./0.6745;

  PE = PE*diag(1./pestd_robust);
  PE_back = PE_back*diag(1./pe_backstd_robust);

  threshold = [2 2.5 3 3.5 4 5 6 8];
  fatness = [0 1 2 3 4 5 6 7 8 9 10];

  pe = abs(PE(:));

  id_cropped = id(lead_in+1:lead_in+length(pe));
  noise_cropped = noise(lead_in+1:lead_in+length(pe));

  [P_fp_f, P_fn_f, MA_fn_f] = testthresh(pe, id_cropped, threshold, \
					 fatness, noise_cropped);

  pe_min = min(pe,abs(PE_back(:)));

  [P_fp_m, P_fn_m, MA_fn_m] = testthresh(pe_min, id_cropped, \
					 threshold*0.602, fatness, \
					 noise_cropped);

  save savedata/detprob.mat threshold fatness P_fp_f P_fn_f MA_fn_f P_fp_m \
      P_fn_m MA_fn_m

else

  load -force savedata/detprob.mat threshold fatness P_fp_f P_fn_f MA_fn_f \
      P_fp_m P_fn_m MA_fn_m

end

mesh(threshold, fatness, P_fp_f')
view(30,30)

xlabel("threshold")
ylabel("pulse spread")
zlabel("proportion")

grid("on")
legend("off")

print("-deps2","figs/p_fp_f.eps")

#  mesh(threshold, fatness, P_fp_m')
#  view(30,30)

#  print("-deps2","figs/p_fp_m.eps")

mesh(threshold, fatness, P_fn_f')
view(210,30)

print("-deps2","figs/p_fn_f.eps")

#  mesh(threshold, fatness, P_fn_m')
#  view(210,30)

#  print("-deps2","figs/p_fn_m.eps")

#  mesh(threshold, fatness, MA_fn_f')
#  view(210,30)

#  print("-deps2","figs/ma_fn_f.eps")

#  mesh(threshold, fatness, MA_fn_m')
#  view(210,30)

#  print("-deps2","figs/ma_fn_m.eps")

ind=5;
plot(threshold', [P_fp_f(:,ind) P_fn_f(:,ind)])

ylabel("proportion")
legend("false positive", "false negative", 2)
legend("boxon")

print("-deps2","figs/det_thresh.eps")

ind=1;
plot(fatness', [P_fp_f(ind,:); P_fn_f(ind,:)]')

xlabel("pulse spread")
legend("false positive", "false negative", 2)
legend("boxon")

print("-deps2","figs/det_fat.eps")


##

if ((do_longcalc == 1))

  p = 31;
  q = 31;
  w = 1024;

  ## took 42 mins on jugo
  tic();
  [iwinterp sse] = do_arsin_interp(iwclicks, p, q, w, lead_in, lead_out, \
				   id, iwoke, 8);
  toc()

  save savedata/interpsse.mat p q w sse

else

  load -force savedata/interpsse.mat p q w sse

end

plot((0:length(sse)-1)', sse ./ idcropsum)

xlabel("iteration")
ylabel("mean squared error")
legend("off")

print("-deps2","figs/interpiter.eps")


##

iwcc = iwcrop;
iwc_ssq = sumsq(iwcc - iwclicks(lead_in+1:lead_in+length(iwcc)));

if ((do_longcalc == 1))

  p = 31;
  q = 31;
  w = 1024;

  threshold = [2.5 3 3.5 4 4.5 5 5.5 6 10 15 20 40];
  fatness=[2 4 8];

  ## took 6 hours on jugo
  [SSE] = testproc(iwclicks, p, q, w, lead_in, lead_out, threshold, \
		   fatness, 3, iwcc);


  save savedata/proc.mat p q w threshold fatness SSE

else

  load -force savedata/proc.mat p q w threshold fatness SSE

end

## semilogy(threshold, SSE ./ iwc_ssq )
semilogy(threshold(2:length(threshold)), SSE(2:length(threshold),:) ./ iwc_ssq)

xlabel("threshold")
ylabel("squared error ratio")
legend("spread=2","spread=4","spread=8")
legend("boxon")

print("-deps2","figs/fullsse.eps")
