function  [NBfc,NBbatt,NBsc,weight,price_electricity,fuel_comseption,ali,Pp,Ppr,Pfc,d,mfct,SOCfc,OPcostt]=pso(NBBmin,NBscmin,NBfcmin,NBBmax,NBscmax,NBfcmax,Vmass,Vs,bm,bc,bp,scm,scc,scp,fcm,scco,fcco,batco,Vspeed,Pwfc,T) 
%% Problem definition
%hade bala
C=10000;%price of electricity
W=1000;%Wight of compenent%
K=10000;%Fuel compseption%
nvars=1;%only one system
LB=[NBBmin,NBscmin,NBfcmin]; % Lower bound of problem
UB=[NBBmax,NBscmax,NBfcmax]; % Upper bound of problem
%%
max_it=100;%100;% Maximum number of iterations
NPOP=30;%20;% Number of population
% Determine the maximum step for velocity
for d=1:3
    if LB(d)>-1e20 && UB(d)<1e20
        velmax=(UB(d)-LB(d))/NPOP;
    else
        velmax=inf;
    end
end
%% PSO initial parameters
phi1=2.05;
phi2=2.05;
phi=phi1+phi2;
chi=2/(phi-2+sqrt(phi^2-4*phi));
w1=chi;                                 % Inertia weight
c1=chi*phi1;                           % Personal learning coefficient
c2=chi*phi2;                           % Global learning coefficient

%% Initialization
tic
empty_particle.position=[];
empty_particle.velocity=[];
empty_particle.cost=[];
%................
empty_particle.best.position=[];
empty_particle.best.cost=[];
%---------
particle=repmat(empty_particle,NPOP,1);
globalbest.cost=inf;
globalbest.position=[];
%rnwfct_best=inf;

for i=1:NPOP
    cc=1;%a value for cost
    ww=100;% a value for Fuel Comsuption%
    kkk=100;%weight of compenent%
    ff=0;
%[weight,price_electricity,fuel_comseption,b,ali,NBfc,NBbatt,NBsc,Ppr,Pl]=(NBsc,NBfc,NBbatt,Vmass,Vs,bm,bc,bp,scm,scc,scp,fcm,scco,fcco,batco,Vspeed,Pwfc);
for k=1:10
%while ww<=W & kkk <=K  % 
        particle(i).position(1,:)=unifrnd(0,45,1,nvars);% 
        particle(i).position(2,:)=unifrnd(0,5,1,nvars);%
        particle(i).position(3,:)=unifrnd(1,10,1,nvars);
        %particle(i).position(4,:)=unifrnd(0,10,1,nvars);%
        for g=1:3
            particle(i).velocity(g,:)=rand(1,nvars);
        end
        %----convert------------
        NBfc=particle(i).position(1);
        NBbatt=particle(i).position(2);
        NBsc=round(particle(i).position(3));
       % nPng=round(particle(i).position(4));
        %-----------------------
       [weight,price_electricity,fuel_comseption,b,ali,NBfc,NBbatt,NBsc,Ppr,Pl,SOCfc,OPcostt,mfct]=management(NBBmax,NBscmax,NBsc,NBfc,NBbatt,Vmass,Vs,bm,bc,bp,scm,scc,scp,fcm,scco,fcco,batco,Vspeed,Pwfc,T);
       ff=ff+1;
        ww(i)=price_electricity;
        kkk(i)=fuel_comseption;
        
end
    particle(i).cost=price_electricity;
    particle(i).best.position=particle(i).position;
    particle(i).best.cost=particle(i).cost;
    if particle(i).best.cost<globalbest.cost
        globalbest=particle(i).best;
        
    end

end
Fminn=zeros(max_it,1);
%% PSO main loop
% disp('Iteration         Reliability');
% disp('-----------------------------');
for u=1:max_it
    vv=0;
    for i=1:NPOP
        cc=1;%a value for cost
        weight=500;% a value for lose of load probability%
        price_electricity=200000;%
        bb=0;
%C=0.9;%price of electricity
%W=0.2;%lose of load probability%
%K=0.99;%renewable energy factor%

%         ww=0.3*100;% a value for lose of load probability%
%         kkk=2*100;%renewable energy factor%
        while (weight)>=W || (fuel_comseption)>=K
            
            for y=1:3
                particle(i).velocity(y,:)=w1*particle(i).velocity(y,:)+c1*rand*...
                    (particle(i).best.position(y,:)-particle(i).position(y,:))...
                    +c2*rand*(globalbest.position(y,:)-particle(i).position(y,:));
                
                %particle(i).velocity(y,:)=min(max(particle(i).velocity(y,:),-velmax),velmax);
                
                particle(i).position(y,:)=particle(i).position(y,:)+particle(i).velocity(y,:);
                
                % flag=(particle(i).position(kk,:)<LB(kk) | particle(i).position(kk,:)>UB(kk));
                % particle(i).velocity(flag)=-particle(i).velocity(flag);
                particle(i).position(y,:)=min(max(particle(i).position(y,:),LB(y)),UB(y));
                
            end
            %NBfc(i,:)=round(particle(i).position(1,:));
            oo=0;
            %NBbatt(i,:)=round(particle(i).position(2,:));
            NBfc=round(particle(i).position(1));
            NBbatt=round(particle(i).position(2));
            NBsc=round(particle(i).position(3));
            %nPng=round(particle(i).position(4));
            
            %[cc ww]=constraints(c,w,nnn(i,:),zz(i,:),zmax,nmax,N);
             [weight,price_electricity,fuel_comseption,b,ali,NBfc,NBbatt,NBsc,Ppr,Pl,OPcostt,mfct]=management(NBBmax,NBscmax,NBsc,NBfc,NBbatt,Vmass,Vs,bm,bc,bp,scm,scc,scp,fcm,scco,fcco,batco,Vspeed,Pwfc,T);
            bb=bb+1;
            
        end
            
        %-----------------------
        %[weight,price_electricity,fuel_comseption]=management(houses,NBfc,NBbatt,NBsc);
        particle(i).cost=price_electricity;
        %rnwfct=fuel_comseption;
        %particle(i).cost=objective_function(sol(i).pos);
        vv=vv+1;
        if particle(i).cost<particle(i).best.cost 
            particle(i).best.cost=particle(i).cost;
            particle(i).best.position=particle(i).position;
            if particle(i).best.cost<globalbest.cost%& rnwfct<rnwfct_best
                globalbest=particle(i).best;
               % rnwfct_best=rnwfct;
            end
        end
        
   
    end 
    Fminn(u)=globalbest.cost;
    Xmin=globalbest.position;
    NBfc=round(globalbest.position(1));
    NBbatt=round(globalbest.position(2));
    NBsc=round(globalbest.position(3));
    %nPng=round(globalbest.position(4));  
    %disp(['Iteration ',num2str(u),': Best cost= ',num2str(Fminn(u))]);
    % w=wdamp*w;
    


%disp(['Iteration ',num2str(ind),': Best cost= ',num2str(Fminn(u))]);;
%end
Time=toc;
Fmin=min(Fminn);
Xmin;
[weight,price_electricity,fuel_comseption,b,ali,NBfc,NBbatt,NBsc,Ppr,Pl,Pp,Pfc,d,OPcostt]=management(NBBmax,NBscmax,NBsc,NBfc,NBbatt,Vmass,Vs,bm,bc,bp,scm,scc,scp,fcm,scco,fcco,batco,Vspeed,Pwfc,T);
format long
result=[NBfc,NBbatt,NBsc,weight,price_electricity,fuel_comseption,b(1),b(2),b(3),b(4),b(5)];
weight;
price_electricity;
fuel_comseption;
Pp;
Pfc;
end
end
