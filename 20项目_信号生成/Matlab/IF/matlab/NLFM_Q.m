B=50e6;
T=10e-6;
K=B/T;

NLFM_K = [
			-0.11417607723306,
			0.03960138311910/2,
			-0.02048549632323/3,
			0.01253307329411/4,
			-0.00840992355201/5,
			0.00598620805378/6
		]/2/pi;
NLFM_K_Q = round(NLFM_K*2^32)/2^32;

fs=1000e6;
N=round(fs*T);	
t=(0:N-1)/fs;

s1=exp(sqrt(-1)*pi*K*(t-T/2).^2);
phase1=zeros(6,N);
phase_sum=zeros(1,N);
for i=1:6
  phase1(i,:)=2*pi*cos(2*pi*i*(t-T/2)/T).*B*T*NLFM_K_Q(i);
  phase_sum  = phase_sum + phase1(i,:);
	
end
s2=exp(-sqrt(-1)*phase_sum);

s3=s1.*s2;
s3=s3.';

%% 调用时频工具库
%% 调用时频工具库
g=tftb_window(61,'Kaiser');
h=tftb_window(111,'Kaiser'); 
t=1:length(s3)
[tfr,T,F]=tfrcw(s3,t,length(s3),g,h,3.6,1);
 tfr = fftshift(tfr,1);
figure;imagesc(T,F-0.25,abs(tfr));

fvtool(s3)
