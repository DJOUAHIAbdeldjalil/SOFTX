function [Eb,time1,t,Ppbd,Ppb] = dicharge(NBbatt,Eb,t,Ebmin,time1,bp,Ppbd,Ppb)
 %^^^^^^^^^^^^^^DISCHARGE^^^^^^^^^^^^^^^^^^^
    %Pdch(t)=(Pev(t)/uinv)-(Pw(t)+Pp(t));
    %Edch(t)=Pdch(t)*1;%one hour iteration time
    
    if(Eb(t-1)-Ebmin)>=(bp)*NBbatt
        Eb(t)=Eb(t-1)-(bp*NBbatt);
        %time1(t)=2;
    Ppbd(t)=-(bp*NBbatt);
    Ppb(t)=-bp*NBbatt;
    else
    Ppbd(t)=0;
    Ppb(t)=0;
    Eb(t)=Eb(t-1);
    end
        
       
end
            

    

