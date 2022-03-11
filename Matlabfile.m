clear all;
close all;
%transmitter
[y,fs]=audioread('sound.mp3');
sound(y,fs);%playing the audio file
pause (10);
clear sound;%puase the audio after 10 seconds then clear it 
y = y(1: 8*fs, 1);%to deal with mono signal
t=linspace ( 0 , 8 , 8*fs );%Time domain of the original signal
f=linspace( -fs/2 , fs/2 , length(y));%Frequency domain of the original signal
% we create new linspace its range = (range of original sound*2)-1 : 
convT= linspace ( 0 , 16 , 16*fs-1);
convF=  linspace( -fs/2 , fs/2 , length(convT));
x= fftshift(fft(y));%Fourier transform to the signal
figure (1);
plot(t, y,'y');
title('The original signal with the time domain','color','k');
ymag= abs(x);%Magnitude of fourier transform
yphase= angle (x);%Phase of fourier transform
figure (2);
plot(f , ymag,'m');
title('Magnitude of fourier transform of the original signal with the frequncy domain','color','k');
figure (3);
plot(f, yphase,'b');
title('Phase of fourier transform of the original signal with the frequncy domain','color','k');


%Channels
m=input('please enter th number the channel impulse response:');
y = transpose(y);

switch m    
        case 1 
            %Convolution using delta function
            convT=t;
            convF=f;
            x1=[1 zeros(1,length(y)-1)]; 
            x2=[y];
            X1=(fft(x1));
            X2=(fft(x2));
            Y= X1.*X2;
            CH=real(ifft(Y));
            figure (4);
            plot (convT,CH,'r');
            title('Convolution of the first channel with the time domain','color','k');            
            sound(CH,fs); 
            pause (10);
            clear sound;
       case 2 
           %Convolution using exponential (exp(-2*pi*5000*t)) function
           x1= exp(-2*pi*5000*t);
           x1=[x1 zeros(1,length (y)-1)];
           x2=[y  zeros(1,length (y)-1) ];
           X1=(fft(x1));
           X2=(fft(x2));
           Y= X1.*X2;
           CH=real(ifft((Y)));
           figure (4);
           plot (convT,CH,'r');
           title('Convolution of the second channel with the time domain','color','k');           
           sound(CH,fs);
           pause (10);
           clear sound;
      case 3
           %Convolution using exponential (exp(-2*pi*1000*t)) function
           x1= exp(-2*pi*1000*t);
           x1=[x1 zeros(1,length (y)-1)];
           x2=[y zeros(1,length (y)-1) ];
           X1=(fft(x1));
           X2=(fft(x2));
           Y= X1.*X2;
           CH=real(ifft((Y)));
           figure (4);
           plot (convT,CH,'r');
           title('Convolution of the third channel with the time domain','color','k');           
           sound(CH,fs); 
           pause (10);
           clear sound;
     case 4
          %Convolution using two delta functions
           x1= 2*(t==0)+0.5*(t==1);
           x1=[x1 zeros(1,length (y)-1)];
           x2=[y zeros(1,length (y)-1) ];
           X1=(fft(x1));
           X2=(fft(x2));
           Y= X1.*X2;
           CH=real(ifft((Y)));
           figure (4);
           plot (convT,CH,'r');
           title('Convolution of the fourth channel with the time domain','color','k');                      
           sound(CH,fs); 

end
 %Adding noise 
 sigma=input('Please enter th value of sigma:'); %  STANDARD DEVIATION
 z=sigma*randn(1,length(CH));%Noise function 
 CH=CH+z;%Adding noise to the desired channel result
 sound (CH,fs);%Playing audio after adding noise
 pause (10);
 clear sound;
 figure(5);
 plot(convT,CH,'k');
 title('Convolution of the channel with noise with the time domain','color','k');
 CH =real(fftshift (fft(CH)));
 CHnmag= abs(CH);
 CHnphase= angle(CH);
 figure (6);
 plot (convF,CHnmag,'k');
 title('Magnitude of fourier transform of the channel after adding noise noise with the freuency domain','color','k');
 figure(7);
 plot (convF,CHnphase,'k');
 title('Phase of fourier transform of the channel after adding noise noise with the freuency domain','color','k');
 

 
 %Filter and receiver
 
 %we can obtain the freqency of graph ( our sound ,f ) = 141120/44100= 32 so
 %if we need to get number of samples in period -3400 to 3400 it equal
 %6800*32 = 217600 we need half of them before zero and the other after zero
 %so we divide by 2 =108800

if (m==1)
     v=zeros (1 , ((length (CH)) /2)-108800);
     vv= ones (1,217600);
else
     v=zeros (1 , ((length (CH)-1) /2)-108800);
     vv= ones (1,217601);
end

 H=[v vv v];
 CH = H .* CH;
 CHmag= abs(CH);
 CHphase= angle(CH);
 figure (8);
 plot (convF,CHmag,'g');
 title('Magnitude of fourier transform of the receiver signal with the frequncy domain','color','k');
 figure (9);
 plot (convF,CHphase,'y');
 title('Phase of fourier transform of the receiver signal with the frequncy domain','color','k');
 res=real(ifft(ifftshift(CH)));
 figure (10);
 plot (convT,res,'b');
 title('Convolution of the signal after filtering with the time domain','color','k');
 sound (res,fs);
 pause (10);
 clear sound;