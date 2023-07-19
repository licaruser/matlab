function [naf, tau, xi]=ambifunb (x, tau, N, trace)
% if (nargin == 0)
%     error('At least one parameter required');
% end

[xrow,xcol] = size(x);
% if (xcol==0)|(xcol>2)
% %    error('X must have one or two columns');
% end
if (nargin == 1)
    if rem(xrow,2)==0
        tau=(-xrow/2+1):(xrow/2-1);
    else
        tau=(-(xrow-1)/2):((xrow+1)/2-1);
    end
    N=xrow; 
    trace=0;
elseif (nargin == 2)
    N=xrow; 
    trace=0;
elseif (nargin == 3)
    trace=0;
end
[taurow,taucol] = size(tau);
if (taurow~=1)
    error('TAU must only have one row');
elseif (N<0)
    error('N must be greater than zero');
end
naf=zeros (N,taucol);
if trace
    disp('Harrow-band ambiguity function')
end
for ico1=1:taucol
    if trace
        disprog (icol, taucol, 10)
    end
    taui=tau(ico1);
    t=(1+abs(taui)):(xrow-abs(taui));
    naf(t,ico1)=x(t+taui,1).* conj(x(t-taui,xcol));
end
naf=fft(naf);
naf=naf([(N+rem(N,2))/2+1:N 1:(N+rem(N,2))/2],:);
xi=(-(N-rem(N,2))/2:(N+rem(N,2))/2-1)/N;
if (nargout==0)
    contour(2*tau,xi,abs(naf).^2);
%     surf(2*tau,xi,abs(naf).^2,16)
    grid on
    xlabel('Delay'); 
    ylabel('Doppler');
    shading interp
    title('Narrow-band ambiguity function');
end



