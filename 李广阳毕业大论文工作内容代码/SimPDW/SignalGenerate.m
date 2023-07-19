function Signal = SignalGenerate(Signal,Signal_Number)
    CarrierFre = Signal(1);%载频
    PulseWith = Signal(2);%脉宽
    DireArr = Signal(3);%到达角
    Var_Car = CarrierFre * (1-2*rand(1,Signal_Number))*0.01;
    Var_Pul = PulseWith * (1-2*rand(1,Signal_Number))*0.01;
    Var_Dir = DireArr * (1-2*rand(1,Signal_Number))*0.01;
    CarrierFre2 = zeros(Signal_Number,1);
    PulseWith2 = zeros(Signal_Number,1);
    DireArr2 = zeros(Signal_Number,1);
    for ii = 1:Signal_Number
         CarrierFre2(ii,1) = CarrierFre + Var_Car(1,ii);
         PulseWith2(ii,1) = PulseWith + Var_Pul(1,ii);
         DireArr2(ii,1) = DireArr + Var_Dir(1,ii);
    end
    
    clear Signal;
    Signal = [CarrierFre2,PulseWith2,DireArr2];
end
