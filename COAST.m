function [price_electricity] = COAST(NBbatt,NBfc,NBsc,scco,fcco,batco,yd,lt,d,Pp)
% initial cost
SC_C=scco;
FC_C=fcco;
BAT_C=batco;
pc=0.05;
roh=1.2;
eh=12*10^7;
COM_COST=(SC_C*NBsc+FC_C*NBfc+BAT_C*NBbatt)*(d/(lt*yd))*(1+pc*(lt+1)*0.5);
for t=1:1400
OP_COST=(roh/eh)*Pp(t);
end
price_electricity=COM_COST+OP_COST;
end