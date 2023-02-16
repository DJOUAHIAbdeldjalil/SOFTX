function [Pfc,Vst] = PEMFC_Power(Pan,Pca,T,cell_surf,cell_NB,Ifc,tm,ep1,ep2,ep3,ep4,landam,bita,Imax,Rc)
%Nernst voltage equation
%T=353;
%Rha=0.51;
%Rhc=0.1;
Ph2=Pan;
Po2=Pca;
%Ph2o=10^(2.95*10^(-2)*(T-273.15)-9.18*10^(-5)*(T-273.15)^2+1.44*10^(-7)*(T-273.15)^3-2.18);
%Ph2=Rha*Ph2o/2*(((Rha*Ph2o/Pan*exp(1.635*(Ifc/cell_surf)/T^(1.334))))^(-1)-1);
%Po2=Rhc*Ph2o*(((Rhc*Ph2o/Pca*exp(4.192*(Ifc/cell_surf)/T^(1.334))))^(-1)-1);
E = 1.229 - (0.85e-3)*(T-298.15)+(4.3085e-5)*T*log(Ph2*sqrt(Po2));
%Activatio loss
Co2=Po2/(((5.1*10^6))*exp(-498/T));
Vact=-(ep1+ep2*T+ep3*T*log(Co2)+ep4*T*log(Ifc));
%Ohmic Loss
rom=(181.6*(0.062*(T/303)^2*(Ifc/cell_surf)^(2.5)+0.03*(Ifc/cell_surf)+1))/((landam-0.063-3*(Ifc/cell_surf))*exp(4.18*(T-303)/T));
Rm=rom*tm/cell_surf;
Vohm=Ifc*(Rm+Rc);
%Concentration Loss
vcon=-bita*log(1-(Ifc/cell_surf)/Imax);
Vst=cell_NB*(E-Vact-Vohm-vcon);
Pfc=(Ifc*Vst*cell_surf)/1000;