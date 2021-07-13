%Brute-force search the global optimization with SBM (Multiple Network)
%Author: Guanyi Wang and Toru Kitagawa

clear all

% DATA INPUT AND PREPARATION
load('../SBM_small_multi.mat')

times = length(adj_1);%get the number of random networks
N_1 = length(S_1); 
N_2 = length(S_2);
N_3 = length(S_3);

%choose weight parameter
weight_1 = 1;
weight_2 = 1;


% Parameter setting 
parameter = false; % switch: choose 1st parameter set into account or 2nd parameter set
budget_constraint = 1; %swtich: choose the capacity constraint level from 1, 2, 3

if (budget_constraint == 1)
if (parameter)
diary('global_SBM_multi_para1.log');
filename_results = '../global_SBM_multi_para1_bgt1.mat';
beta_11 = 0.7; %infection rate between group 1 and group 1
beta_12 = 0.5; %infection rate from group 2 to group 1
beta_21 = 0.5; %infection rate from group 1 to group 2
beta_22 = 0.6; %infection rate between group 2 and group 2
gamma_1 = 0.1; %recover rate for group 1
gamma_2 = 0.05; %recover rate for group 2
d_1 = round(0.07*N_1); %capacity constraint for N_1
d_2 = round(0.07*N_2); %capacity constraint for N_2
d_3 = round(0.07*N_3); %capacity constraint for N_3
else
diary('global_SBM_multi_para2.log');
filename_results = '../global_SBM_multi_para2_bgt1.mat';
beta_11 = 0.8; %infection rate between group 1 and group 1
beta_12 = 0.5; %infection rate from group 2 to group 1
beta_21 = 0.7; %infection rate from group 1 to group 2
beta_22 = 0.7; %infection rate between group 2 and group 2
gamma_1 = 0.1; %recover rate for group 1
gamma_2 = 0.025; %recover rate for group 2 
d_1 = round(0.07*N_1); %capacity constraint for N_1
d_2 = round(0.07*N_2); %capacity constraint for N_2
d_3 = round(0.07*N_3); %capacity constraint for N_3
end
end
if (budget_constraint == 2)
    if (parameter)
diary('global_SBM_multi_para1.log');
filename_results = '../global_SBM_multi_para1_bgt2.mat';
beta_11 = 0.7; %infection rate between group 1 and group 1
beta_12 = 0.5; %infection rate from group 2 to group 1
beta_21 = 0.5; %infection rate from group 1 to group 2
beta_22 = 0.6; %infection rate between group 2 and group 2
gamma_1 = 0.1; %recover rate for group 1
gamma_2 = 0.05; %recover rate for group 2
d_1 = round(0.1*N_1); %capacity constraint for N_1
d_2 = round(0.1*N_2); %capacity constraint for N_2
d_3 = round(0.1*N_3); %capacity constraint for N_3
else
diary('global_SBM_multi_para2.log');
filename_results = '../global_SBM_multi_para2_bgt2.mat';
beta_11 = 0.8; %infection rate between group 1 and group 1
beta_12 = 0.5; %infection rate from group 2 to group 1
beta_21 = 0.7; %infection rate from group 1 to group 2
beta_22 = 0.7; %infection rate between group 2 and group 2
gamma_1 = 0.1; %recover rate for group 1
gamma_2 = 0.025; %recover rate for group 2   
d_1 = round(0.1*N_1); %capacity constraint for N_1
d_2 = round(0.1*N_2); %capacity constraint for N_2
d_3 = round(0.1*N_3); %capacity constraint for N_3
    end
end

if (budget_constraint == 3)
    if (parameter)
diary('global_SBM_multi_para1.log');
filename_results = '../global_SBM_multi_para1_bgt3.mat';
beta_11 = 0.7; %infection rate between group 1 and group 1
beta_12 = 0.5; %infection rate from group 2 to group 1
beta_21 = 0.5; %infection rate from group 1 to group 2
beta_22 = 0.6; %infection rate between group 2 and group 2
gamma_1 = 0.1; %recover rate for group 1
gamma_2 = 0.05; %recover rate for group 2
d_1 = round(0.2*N_1); %capacity constraint for N_1
d_2 = round(0.2*N_2); %capacity constraint for N_2
d_3 = round(0.2*N_3); %capacity constraint for N_3
else
diary('global_SBM_multi_para2.log');
filename_results = '../global_SBM_multi_para2_bgt3.mat';
beta_11 = 0.8; %infection rate between group 1 and group 1
beta_12 = 0.5; %infection rate from group 2 to group 1
beta_21 = 0.7; %infection rate from group 1 to group 2
beta_22 = 0.7; %infection rate between group 2 and group 2
gamma_1 = 0.1; %recover rate for group 1
gamma_2 = 0.025; %recover rate for group 2  
d_1 = round(0.2*N_1); %capacity constraint for N_1
d_2 = round(0.2*N_2); %capacity constraint for N_2
d_3 = round(0.2*N_3); %capacity constraint for N_3
    end
end

%define the weight vector
Indx_1a  = (a_1 == 1);
Indx_1b  = (b_1 == 1);
g_1 = ones(N_1,1);%weight for N_1
g_1(Indx_1a) = g_1(Indx_1a)*weight_1;
g_1(Indx_1b) = g_1(Indx_1b)*weight_2;

Indx_2a  = (a_2 == 1);
Indx_2b  = (b_2 == 1);
g_2 = ones(N_2,1);%weight for N_2
g_2(Indx_2a) = g_2(Indx_2a)*weight_1;
g_2(Indx_2b) = g_2(Indx_2b)*weight_2;

Indx_3a = (a_3 == 1);
Indx_3b = (b_3 == 1);
g_3 = ones(N_3,1);%weight for N_3
g_3(Indx_3a) = g_3(Indx_3a)*weight_1;
g_3(Indx_3b) = g_3(Indx_3b)*weight_2;


%Define the parameter vector
C_1 = g_1 - diag(R_1*g_1') - diag(diag(a_1*I_1')*g_1')*gamma_1 - diag(diag(b_1*I_1')*g_1')*gamma_2 - diag(S_1*g_1'); %define the vector for N_1
C_2 = g_2 - diag(R_2*g_2') - diag(diag(a_2*I_2')*g_2')*gamma_1 - diag(diag(b_2*I_2')*g_2')*gamma_2 - diag(S_2*g_2'); %define the vector for N_2
C_3 = g_3 - diag(R_3*g_3') - diag(diag(a_3*I_3')*g_3')*gamma_1 - diag(diag(b_3*I_3')*g_3')*gamma_2 - diag(S_3*g_3'); %define the vector for N_3

%set the storage matrix
Individual_1 = (1:N_1);
Individual_2 = (1:N_2);
Individual_3 = (1:N_3);
%find all the possible combination of vaccine choice in N_1
Ind_1 = nchoosek(Individual_1,d_1); 
Ind_1 = Ind_1';
%find all the possible combination of vaccine choice in N_2
Ind_2 = nchoosek(Individual_2,d_2);
Ind_2 = Ind_2';
%find all the possible combination of vaccine choice in N_3
Ind_3 = nchoosek(Individual_3,d_3); 
Ind_3 = Ind_3';
%find the total number of possible combinations
eend_1 = nchoosek(N_1,d_1);
eend_2 = nchoosek(N_2,d_2);
eend_3 = nchoosek(N_3,d_3);


tic %calculate the running time
%Define the weighting matrix
for qq = 1:times
       
%Define the weighting matrix

%the first element vector in weighting matrix
W_11{qq} = beta_11*diag(g_1)*diag(a_1)*diag(S_1)*adj_1{qq}*diag(a_1)*diag(I_1);
W_12{qq} = beta_11*diag(g_2)*diag(a_2)*diag(S_2)*adj_2{qq}*diag(a_2)*diag(I_2);
W_13{qq} = beta_11*diag(g_3)*diag(a_3)*diag(S_3)*adj_3{qq}*diag(a_3)*diag(I_3);

%the second element vector in weighting matrix
W_21{qq} = beta_12*diag(g_1)*diag(a_1)*diag(S_1)*adj_1{qq}*diag(b_1)*diag(I_1);
W_22{qq} = beta_12*diag(g_2)*diag(a_2)*diag(S_2)*adj_2{qq}*diag(b_2)*diag(I_2);
W_23{qq} = beta_12*diag(g_3)*diag(a_3)*diag(S_3)*adj_3{qq}*diag(b_3)*diag(I_3);


%the third element vector in weighting matrix
W_31{qq} = beta_21*diag(g_1)*diag(b_1)*diag(S_1)*adj_1{qq}*diag(a_1)*diag(I_1);
W_32{qq} = beta_21*diag(g_2)*diag(b_2)*diag(S_2)*adj_2{qq}*diag(a_2)*diag(I_2);
W_33{qq} = beta_21*diag(g_3)*diag(b_3)*diag(S_3)*adj_3{qq}*diag(a_3)*diag(I_3);


%the fourth element vector in weighting matrix
W_41{qq} = beta_22*diag(g_1)*diag(b_1)*diag(S_1)*adj_1{qq}*diag(b_1)*diag(I_1);
W_42{qq} = beta_22*diag(g_2)*diag(b_2)*diag(S_2)*adj_2{qq}*diag(b_2)*diag(I_2);
W_43{qq} = beta_22*diag(g_3)*diag(b_3)*diag(S_3)*adj_3{qq}*diag(b_3)*diag(I_3);


%combine above elements together
W_1{qq} = - W_11{qq} - W_21{qq} - W_31{qq} - W_41{qq};
W_2{qq} = - W_12{qq} - W_22{qq} - W_32{qq} - W_42{qq};
W_3{qq} = - W_13{qq} - W_23{qq} - W_33{qq} - W_43{qq};

%Normalization for the weighting matrix
for cc = 1:N_1
    if sum(adj_1{qq}(cc,:)) == 0 %for the unit with 0 neighbor, there is no normalization
       W_1{qq}(cc,:) = W_1{qq}(cc,:);
    else
       W_1{qq}(cc,:) = W_1{qq}(cc,:)/sum(adj_1{qq}(cc,:));
    end
end

for cc = 1:N_2
    if sum(adj_2{qq}(cc,:)) == 0
       W_2{qq}(cc,:) = W_2{qq}(cc,:);
    else
       W_2{qq}(cc,:) = W_2{qq}(cc,:)/sum(adj_2{qq}(cc,:));
    end
end

for cc = 1:N_3
    if sum(adj_3{qq}(cc,:)) == 0
       W_3{qq}(cc,:) = W_3{qq}(cc,:);
    else
       W_3{qq}(cc,:) = W_3{qq}(cc,:)/sum(adj_3{qq}(cc,:));
    end
end   

%brute-force search
%Initialize the vector of V
V_11 = zeros(N_1,eend_1); 
V_21 = zeros(N_2,eend_2); 
V_31 = zeros(N_3,eend_3); 
%Set the vector of objective function
F_11{qq} = zeros(eend_1,1); 
F_21{qq} = zeros(eend_2,1);
F_31{qq} = zeros(eend_3,1);

ii = 1; %initialize the paramter
while (ii<=eend_1)
    i= 1;
while (i<=d_1)
V_11(Ind_1(i,ii),ii) = 1;
i = i+1;
end
    F_11{qq}(ii) = obj(V_11(:,ii),W_1{qq},C_1,g_1);%calculate the value for objective function with adjacency matrix adj_1
    ii = ii+1;
end



ii = 1; %initialize the paramter
while (ii<=eend_2)
    i= 1;
while (i<=d_2)
V_21(Ind_2(i,ii),ii) = 1;
i = i+1;
end
    F_21{qq}(ii) = obj(V_21(:,ii),W_2{qq},C_2,g_2);%calculate the value for objective function with adjacency matrix adj_2
    ii = ii+1;
end



ii = 1; %initialize the paramter
while (ii<=eend_3)
    i= 1;
while (i<=d_3)
V_31(Ind_3(i,ii),ii) = 1;
i = i+1;
end
    F_31{qq}(ii) = obj(V_31(:,ii),W_3{qq},C_3,g_3);%calculate the value for objective function with adjacency matrix adj_3
    ii = ii+1;
end


%select the allocation rule with the highest outcome variable value 
[F_result_11{qq},idx_11{qq}] = max(F_11{qq});
[F_result_21{qq},idx_21{qq}] = max(F_21{qq});
[F_result_31{qq},idx_31{qq}] = max(F_31{qq});

%return the index of vaccinated agents
V_output_11{qq} = Ind_1(:,idx_11{qq});
V_output_21{qq} = Ind_2(:,idx_21{qq});
V_output_31{qq} = Ind_3(:,idx_31{qq});

%calculate the constant part in the initial objective function
%constant part without interaction, N_1
zz = 1;
const_1 = 0;
while (zz<=N_1)
   const_1 = const_1 + R_1(zz)+a_1(zz)*I_1(zz)*gamma_1+b_1(zz)*I_1(zz)*gamma_2+S_1(zz);
    zz = zz+1;
end
%take average for the constant part without interaction 
const_1 = const_1/N_1;

%calcuate the interacted constant part sepearately, N_1 
mm = 1;
nn = 1;
const_11{qq} = 0;
while (nn <= N_1)
while (mm <= N_1)
   const_11{qq} = const_11{qq}+(beta_11*a_1(nn)*a_1(mm)+beta_12*a_1(nn)*b_1(mm)+beta_21*b_1(nn)*a_1(mm)+ beta_22*b_1(nn)*b_1(mm))*adj_1{qq}(nn,mm)*I_1(mm)*S_1(nn);
    mm = mm+1;
end
nn = nn+1;
end
%take average value for interacted constant part with adj_1
const_11{qq} = const_11{qq}/N_1;


%constant part without interaction, N_2
zz = 1;
const_2 = 0;
while (zz<=N_2)
   const_2 = const_2 + R_2(zz)+a_2(zz)*I_2(zz)*gamma_2+b_2(zz)*I_2(zz)*gamma_2+S_2(zz);
    zz = zz+1;
end
%take average for the constant part without interaction 
const_2 = const_2/N_2;


mm = 1;
nn = 1;
const_21{qq} = 0;
while (nn <= N_2)
while (mm <= N_2)
   const_21{qq} = const_21{qq}+(beta_11*a_2(nn)*a_2(mm)+beta_12*a_2(nn)*b_2(mm)+beta_21*b_2(nn)*a_2(mm)+ beta_22*b_2(nn)*b_2(mm))*adj_2{qq}(nn,mm)*I_2(mm)*S_2(nn);
    mm = mm+1;
end
nn = nn+1;
end
%take average value for interacted constant part with adj_2
const_21{qq} = const_21{qq}/N_2;


%constant part without interaction, N_3
zz = 1;
const_3 = 0;
while (zz<=N_3)
   const_3 = const_3 + R_3(zz)+a_3(zz)*I_3(zz)*gamma_1+b_3(zz)*I_3(zz)*gamma_2+S_3(zz);
    zz = zz+1;
end

%take average for the constant part without interaction 
const_3 = const_3/N_3;

%calcuate the interacted constant part sepearately, N_3
mm = 1;
nn = 1;
const_31{qq} = 0;
while (nn <= N_3)
while (mm <= N_3)
   const_31{qq} = const_31{qq}+(beta_11*a_3(nn)*a_3(mm)+beta_12*a_3(nn)*b_3(mm)+beta_21*b_3(nn)*a_3(mm)+ beta_22*b_3(nn)*b_3(mm))*adj_3{qq}(nn,mm)*I_3(mm)*S_3(nn);
    mm = mm+1;
end
nn = nn+1;
end
%take average value for interacted constant part with adj_3
const_31{qq} = const_31{qq}/N_3;

%combime the previous result together
Y_11{qq} = const_1-const_11{qq}+F_result_11{qq};
Y_21{qq} = const_2-const_21{qq}+F_result_21{qq};
Y_31{qq} = const_3-const_31{qq}+F_result_31{qq};
end

%calculate the average value of outcome variable for multiple network
%set initial value for the interation 
Y_11_ave = 0;
Y_21_ave = 0;
Y_31_ave = 0;

%take average value across different networks
ww = 1;
while (ww<=times)
Y_11_ave = Y_11_ave + Y_11{ww};
ww = ww+1;
end
Y_11_ave = Y_11_ave/times;


ww = 1;
while (ww<=times)
Y_21_ave = Y_21_ave + Y_21{ww};
ww = ww+1;
end
Y_21_ave = Y_21_ave/times;


ww = 1;
while (ww<=times)
Y_31_ave = Y_31_ave + Y_31{ww};
ww = ww+1;
end
Y_31_ave = Y_31_ave/times;


%calculate standard error from greedy alogrithm on multiple networks
Y_11_dif = zeros(times,1);
for qq = 1:times
   Y_11_dif(qq) = (Y_11{qq} - Y_11_ave)^2;
end
Y_11_std = sqrt(sum(Y_11_dif));%standard error


Y_21_dif = zeros(times,1);
for qq = 1:times
   Y_21_dif(qq) = (Y_21{qq} - Y_21_ave)^2;
end
Y_21_std = sqrt(sum(Y_21_dif));%standard error

Y_31_dif = zeros(times,1);
for qq = 1:times
   Y_31_dif(qq) = (Y_31{qq} - Y_31_ave)^2;
end
Y_31_std = sqrt(sum(Y_31_dif));%standard error

toc
%clear the irrelevant variables
clear Ind_1 Ind_2 Ind_3 eend_1 eend_2 eend_3 C_1 C_2 C_3
clear W_1 W_2 W_3 W_4 W_5 W_6 W_7 W_8 W_9 idx_11 idx_12 idx_13 idx_21 idx_22 idx_23 idx_31 idx_32 idx_33
clear beta_11 beta_12 beta_21 beta_22 gamma_1 gamma_2
clear a_1 a_2 a_3 b_1 b_2 b_3 S_1 S_2 S_3 I_1 I_2 I_3 R_1 R_2 R_3
clear V_11 V_12 V_13 V_21 V_22 V_23 V_31 V_32 V_33
clear W_11 W_12 W_13 W_14 W_15 W_16 W_17 W_18 W_19 W_21 W_22 W_23 W_24 W_25 W_26 W_27 W_28 W_29 
clear W_31 W_32 W_33 W_34 W_35 W_36 W_37 W_38 W_39 W_41 W_42 W_43 W_44 W_45 W_46 W_47 W_48 W_49
clear F_11 F_12 F_13 F_21 F_22 F_23 F_31 F_32 F_33
clear F_result_11 F_result_12 F_result_13 F_result_21 F_result_22 F_result_23 F_result_31 F_result_32 F_result_33
clear i mm nn zz ii cc qq ww adj_1 adj_2 adj_3 adj_4 adj_5 adj_6 adj_7 adj_8 adj_9
clear const_1 const_2 const_3 const_11 const_12 const_13 const_21 const_22 const_23 const_31 const_32 const_33
clear Individual_1 Individual_2 Individual_3 Y_11 Y_12 Y_13 Y_21 Y_22 Y_23 Y_31 Y_32 Y_33
clear Y_11_dif Y_12_dif Y_21_dif Y_22_dif Y_31_dif Y_32_dif
% Save coefficients and other variables for graphs
save(filename_results);

diary off