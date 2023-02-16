function [Eb,Ech,t,Ppb] = charge(NBbatt,Eb,Ebmax,t,Ech,Pl,bp,Ppb)
 %^^^^^^^^^^^^^^CHARGE^^^^^^^^^^^^^^^^^^^^^^^^^^

      
        if(Ebmax-Eb(t-1)>=bp*NBbatt)
            if (Ech(t)>bp*NBbatt)
                Eb(t)=Eb(t-1)+bp*NBbatt;
                Ech(t)=Ech(t)-bp*NBbatt;
            Ppb(t)=bp*NBbatt;
             
            else 
                Eb(t)=Eb(t-1)+Ech(t);
                 Ppb(t)=Ech(t);
                Ech(t)=0;
               
            end
              
            
        else 
            Eb(t)=Ebmax;
            Ech(t)=Ech(t)-(Ebmax-Eb(t-1));
        Ppb(t)=Ebmax-Eb(t-1);
        end
end