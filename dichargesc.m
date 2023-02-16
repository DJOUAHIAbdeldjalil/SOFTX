function [Esc,time1,t,Ppscd,Ppsc] = dichargesc(NBsc,Esc,t,Escmin,time1,scp,Ppscd,Ppsc)
 %^^^^^^^^^^^^^^DISCHARGE^^^^^^^^^^^^^^^^^^^
   
    
    if(Esc(t-1)-Escmin)>=(scp)*NBsc
        Esc(t)=Esc(t-1)-scp*NBsc;
        %time1(t)=2;
    Ppscd(t)=-(scp*NBsc);
    Ppsc(t)=-scp*NBsc;
    else   
     Ppscd(t)=0;
     Ppsc(t)=0;
     Esc(t)=Esc(t-1);
    end
              
end
            

