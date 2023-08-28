%% Filter Specifications
Wp = [1000 1500];
Ws = [700 1700];
Rp = 0.16;
Rs = 58;
%% Designing the Analog Filter
[n,Wn] = cheb2ord(Wp,Ws,Rp,Rs,"s");
[b,a]=cheby2(n,Rs,Ws,"s");
filtera = tf(b,a);
Wsm=4200;
tsm=2*pi/Wsm;
%% Magnitude Response of the Analog Filter
W=linspace(-1600,1600,3200);
H = freqs(b,a,W);
mag = abs(H);
figure(1)
plot(W,mag2db(mag))
title("Magnitude of the Analog Filter")
xlabel("Frequency (rad/s)")
ylabel("Magnitude (dB)")
grid("minor")
%% Prewrapping frequencies
Wp(1)=2/tsm*tan(Wp(1)*tsm/2); Wp(2)=2/tsm*tan(Wp(2)*tsm/2);
Ws(1)=2/tsm*tan(Ws(1)*tsm/2); Ws(2)=2/tsm*tan(Ws(2)*tsm/2);
%% normalizing frequencies
Wp=[Wp(1)/(Wsm/2) Wp(2)/(Wsm/2)];
Ws=[Ws(1)/(Wsm/2) Ws(2)/(Wsm/2)];
%% Transforming into Digital filter
[n,Wc] = cheb2ord(Wp,Ws,Rp,Rs,'s');
[z,p,k] = cheb2ap(n,Rs);
[A,B,C,D] = zp2ss(z,p,k);
[At,Bt,Ct,Dt] = lp2bp(A,B,C,D,sqrt(Wp(1)*Wp(2)),Wp(2)-Wp(1));W=linspace(-1600/(Wsm/2),1600/(Wsm/2),3200);
[Ad,Bd,Cd,Dd] = bilinear(At,Bt,Ct,Dt,1/pi); % Bilinear Transformation
filter = ss2sos(Ad,Bd,Cd,Dd);
[b,a] = sos2tf(filter);
filter = tf(b,a); % Coefficients of the transfer function
[num,den] = tfdata(filter)
[hd,f] = freqz(b,a,W,2);
%% magnitude response of the Digital Filter
magd = abs(hd);
figure(2)
plot(W,mag2db(magd))
title("Magnitude of the Digital Filter")
xlabel("Frequency (rad/samples)")
ylabel("Magnitude (dB)")
grid("minor")
%% Magnitude response of the passband
figure(3)
plot(W,mag2db(magd))
axis ([ 0.53 , 0.68 , -0.1 , 0.1]);
title("Magnitude response of the passband")
xlabel("Frequency (rad/samples)")
ylabel("Magnitude (dB)")
grid("minor")