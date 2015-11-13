function [idsums msdata ratiodata] = testdetect(p, q, w, iwoke, \
						iwclicks, id)

#  rand("seed",71077345); 

#  [id noise] = fake_noise (rows(iwoke), 0.93, 0.65, 0.8, 10000);

#  iwclicks=iwoke+noise;
#  ind = abs(iwclicks) > 1;
#  iwclicks(ind) = sign(iwclicks(ind));


#p=31;
#q=31;
#w=1024;
lead_in=1024;
lead_out=1024;

tic();
[ARp Cp Freqsp pe_ms_est sinresid_ms x_ms] = do_arsin_model(iwoke, p, q, \
							    w, \
							    lead_in, \
							    lead_out);
tpm=toc()

tic();
[ARn Cn Freqsn pe_ms_est sinresid_ms x_ms] = do_arsin_model(iwclicks, \
							    p, q, \
							    w, \
							    lead_in, \
							    lead_out);
tnm=toc()

count=columns(ARp);

## i'd have to deal with different phase for col 1 and the rest
#  ARo = [ARn(:,1) ARp(:,1:count-1)];
#  Co =  [Cn(:,1)  Cp(:,1:count-1)];
#  Freqso = [Freqsn(:,1) Freqsp(:,1:count-1)];

ARo = ARp(:,1:count-1);
Co =  Cp(:,1:count-1);
Freqso = Freqsp(:,1:count-1);

ARp = ARp(:,2:count);
Cp = Cp(:,2:count);
Freqsp = Freqsp(:,2:count);

ARn = ARn(:,2:count);
Cn = Cn(:,2:count);
Freqsn = Freqsn(:,2:count);

lead_in = lead_in + w;

tic();
[PEp x_init PE_backp x_post] = do_arsin_filt(iwclicks, ARp, Cp, \
					     Freqsp, w, lead_in, lead_out, \
					     1);
tpf = toc()

tic();
[PEn x_init PE_backn x_post] = do_arsin_filt(iwclicks, ARn, Cn, \
					     Freqsn, w, lead_in, lead_out, \
					     1);
tnf = toc()

tic();
[PEo x_init PE_backo x_post] = do_arsin_filt(iwclicks, ARo, Co, \
					     Freqso, w, lead_in, lead_out, \
					     1, 1);
tof = toc()

tic();

pedata = [PEn, PE_backn, PEo, PE_backo, PEp, PE_backp];

pestd = sqrt(meansq(pedata));
pestd_robust = median(abs(pedata))./0.6745;

pedata = [pedata, pedata*diag(1./pestd), pedata*diag(1./pestd_robust)];

pedata = reshape(pedata, w*(count-1), 18);
pedata = abs(pedata);

pedata = [pedata(:,1:2:17) pedata(:,2:2:18) \
	  min(pedata(:,1:2:17),pedata(:,2:2:18))];

id_dirty = id(lead_in+1:lead_in+rows(pedata));
id_clean = ~id_dirty;
id_affected = fatten(id_dirty, 0, p) & id_clean;
id_unaffected = id_clean & ~id_affected;

assert(sum(id_dirty)+sum(id_clean) == rows(pedata));
assert(sum(id_affected)+sum(id_unaffected) == sum(id_clean));

idsums = sum([id_dirty id_clean id_affected id_unaffected])';

msdata=[meansq(pedata(find(id_dirty>0),:)); \
	meansq(pedata(find(id_clean>0),:)); \
	meansq(pedata(find(id_affected>0),:)); \
	meansq(pedata(find(id_unaffected>0),:))];

ratiodata = [msdata(1,:)./msdata(2,:); msdata(1,:)./msdata(3,:); \
	     msdata(1,:)./msdata(4,:)];

t=toc()

