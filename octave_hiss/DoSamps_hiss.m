## This script generates audio samples in directory samps/

function DoSamps_hiss()

[iwoke fs] = auload("source/iwoke.wav");

rand("seed",71077345);
white = randn(length(iwoke),1);
white = white .* sqrt(0.0015); # variance 0.0015

iwhiss = iwoke + white;

ausave("samps/iwhiss.wav", iwhiss, fs, "short")

##

iwideal = do_idealzerophase(iwhiss, 2048, 4, iwoke);

ausave("samps/iwideal.wav", iwideal, fs, "short")

##

s_d = est_power(white, 2048, 4);

iwwien = do_wiener(iwhiss, 2048, 4, s_d, 1, 0);

ausave("samps/iwwien.wav", iwwien, fs, "short")

##

iwwien = do_wiener(iwhiss, 2048, 4, s_d, 5, 0.1);

ausave("samps/iwwien-50-10.wav", iwwien, fs, "short")

##

iwem = do_em(iwhiss, 2048, 4, s_d, 0.98, 0, 0);

ausave("samps/iwem.wav", iwem, fs, "short")

##

#white_em = do_em(white,  2048, 4, s_d, 0.98, 0, 0);
#meansq(white_em)/meansq(white)

iwem = do_em(iwhiss, 2048, 4, s_d, 0.98, 0.06, 0);

ausave("samps/iwem-06.wav", iwem, fs, "short")

##

iwemq = do_em(iwhiss, 2048, 4, s_d, 0.99, 0.0, 0.2);

ausave("samps/iwemq.wav", iwemq, fs, "short")

##

#white_emq = do_em(white,  2048, 4, s_d, 0.99, 0, 0.2);
#meansq(white_emq)/meansq(white)

iwemq = do_em(iwhiss, 2048, 4, s_d, 0.99, 0.016, 0.2);

ausave("samps/iwemq-016.wav", iwemq, fs, "short")

##

[gma_noise fs] = auload("source/gma-silence.wav");

s_d = est_power(gma_noise, 2048, 4);

[gma_letter fs] = auload("source/gma-letter.wav");

gma_letter_emq = do_em(gma_letter, 2048, 4, s_d, 0.99, 0.016, 0.2);

ausave("samps/gma-letter-emq-016.wav", gma_letter_emq, fs, "short")

##

[gma_utah fs] = auload("source/gma-utah.wav");

gma_utah_emq = do_em(gma_utah, 2048, 4, s_d, 0.99, 0.016, 0.2);

ausave("samps/gma-utah-emq-016.wav", gma_utah_emq, fs, "short")






