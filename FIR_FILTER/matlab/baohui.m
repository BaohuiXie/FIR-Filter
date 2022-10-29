a0=3600;
f0=0.08;
t=1:350;
origin=a0*sin(2*pi*f0*t);
figure(1);
subplot(4,1,1);
plot(t,origin);
title('base signal');

a1=2500;
f1=f0*20;
carry=a1*sin(2*pi*f1*t);
figure(1);
subplot(4,1,2);
plot(t,carry);
title('carrier signal');
inputSignal=fopen('inputSignal.txt','w');
signal=dec2bin(round(origin+carry+6100),16);
for i=1:350;
    fprintf(inputSignal, '%s\n',signal(i,:));
end
fclose(inputSignal);
figure(1);
subplot(4,1,3);
plot(t,bin2dec(signal));
title('input signal');

outputSignal=fopen('outputSignal.txt','r');
outSignal=fscanf(outputSignal,'%d');
subplot(4,1,4);
plot(t,outSignal);
title('FIR_outSignal');