%% Specifications of the Filter
fsamp = 4200;
fcuts = [700 1000 1500 1700];
mags = [0 1 0];
devs = [db2mag(-58) db2mag(0.16) db2mag(-58)];
%% Designing the Kaiser window
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
%% Magnitude Response of the Filter
figure;
[H,f] = freqz(hh,1,1024,fsamp);
f1=f/4200;
plot(f1,(mag2db(abs(H))))
title("Magnitude of the Filter")
xlabel("Frequency (rad/s)")
ylabel("Magnitude (dB)")
grid("minor")%% Kaiser Window
figure;
w = kaiser(n,beta);
stem(w)
title("Kaiser Window")
xlabel("Samples")
ylabel("")
grid("minor")
%% Impulse response of the filter
figure;
impz(hh,100)
title("Impulse of the Filter")
xlabel("Samples")
ylabel("Amplitude")
grid("minor")
%% Passband Magnitude response
figure;
[H,f] = freqz(hh,1,1024,fsamp);
plot(f1,(mag2db(abs(H))))
axis ([ 900 , 1600 , -0.2 , 0.2]);
title("Magnitude response of the Passband ")
xlabel("Frequency (rad/s)")
ylabel("Magnitude (dB)")
grid("minor")