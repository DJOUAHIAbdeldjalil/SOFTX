
function [Esc,Ech,t,Ppsc] = chargesc(NBsc,Esc,Escmax,t,Ech,scp,Ppsc)
 %^^^^^^^^^^^^^^CHARGE^^^^^^^^^^^^^^^^^^^^^^^^^^
      
     
         if(Escmax-Esc(t-1)>=scp*NBsc)
            if (Ech(t)>scp*NBsc)
                Esc(t)=Esc(t-1)+scp*NBsc;
                Ech(t)=Ech(t)-scp*NBsc;
          Ppsc(t)=scp*NBsc;
           
            else 
                Esc(t)=Esc(t-1)+Ech(t);             
            Ppsc(t)=Ech(t);
           Ech(t)=0;
            end
              
            
        else 
            Esc(t)=Escmax;
            Ech(t)=Ech(t)-(Escmax-Esc(t-1));
            Ppsc(t)=Escmax-Esc(t-1);
        end
end