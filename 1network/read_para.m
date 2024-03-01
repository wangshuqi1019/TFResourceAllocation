%% Flu, no age, no family
Para_flu.popImmunity=0.001;  % 初始设定popImmunity概率的人处于exposed状态
Para_flu.beta=NaN;
Para_flu.p_ei=1/4;  % 离开exposed状态的概率
Para_flu.p_ir=1/7;  % 从presymptomatic到symptomatic的传播概率
Para_flu.end_day=200;  % 总共的运行时间
save('Para_flu.mat','Para_flu');

%% Flu, no age, with families
Para_flu_age.popImmunity=0.001;  % 初始设定popImmunity概率的人处于exposed状态
Para_flu_age.beta_others=NaN;
Para_flu_age.beta_house=0.38;
Para_flu_age.p_ei=1/4;  % 离开exposed状态的概率
Para_flu_age.p_ir=1/7;  % 从presymptomatic到symptomatic的传播概率
Para_flu_age.end_day=200;  % 总共的运行时间
save('Para_flu_age.mat','Para_flu_age');

%% COVID-19, no age, no family
Para_covid.popImmunity=0.001;  % 初始设定popImmunity概率的人处于exposed状态

Para_covid.beta=NaN;
Para_covid.omega_asym=0.5;  % asympotomatic病例的相对传染性
Para_covid.omega_presym=1.57;  % presympotomatic病例的相对传染性

Para_covid.p_epa=1/3;  % 离开exposed状态的概率
Para_covid.p_py=0.5;  % 从presymptomatic到symptomatic的传播概率
Para_covid.p_ar=1/9;  % asympotomatic病例的恢复率
Para_covid.p_yh=0.1695;  % 从symptomatic到hospitalized的传播概率
Para_covid.p_yr=1/4;  % sympotomatic病例的恢复率
Para_covid.p_hd=0.128;  % 从hospitalized到deceased的传播概率
Para_covid.p_hr=0.091;  % 从hospitalized到recovered的传播概率

Para_covid.prop_sym=0.75;  % 有症状的infections的比例
Para_covid.prop_asym=1-Para_covid.prop_sym;  % 无症状的infections的比例
Para_covid.prop_sym_hosp=0.026;  % 住院的有症状病例的特定年龄比例
Para_covid.prop_hosp_dea=0.0525;  % 住院病例的死亡率
Para_covid.tao_sym=1/Para_covid.p_py+1/Para_covid.p_yr;  % 有症状的持续时间
Para_covid.tao_asym=1/Para_covid.p_ar;  % 无症状的持续时间

Para_covid.end_day=200;  % 总共的运行时间
save('Para_covid.mat','Para_covid');

%% COVID-19, with age and family
Para_covid_age.age_group=[ones(5,1);2*ones(13,1);3*ones(32,1);4*ones(15,1);5*ones(36,1)];
Para_covid_age.popImmunity=0.001;  % 初始设定popImmunity概率的人处于exposed状态

Para_covid_age.beta_others=NaN;
Para_covid_age.beta_house=NaN;
Para_covid_age.p_house = 0.35;
Para_covid_age.omega_asym=0.5;  % asympotomatic病例的相对传染性
Para_covid_age.omega_presym=1.57;  % presympotomatic病例的相对传染性

Para_covid_age.p_epa=1/3;  % 离开exposed状态的概率
Para_covid_age.p_py=0.5;  % 从presymptomatic到symptomatic的传播概率
Para_covid_age.p_ar=1/9;  % asympotomatic病例的恢复率
Para_covid_age.p_yh=0.1695;  % 从symptomatic到hospitalized的传播概率
Para_covid_age.p_yr=1/4;  % sympotomatic病例的恢复率
Para_covid_age.p_hd=0.128;  % 从hospitalized到deceased的传播概率
Para_covid_age.p_hr=0.091;  % 从hospitalized到recovered的传播概率

Para_covid_age.prop_sym=0.75;  % 有症状的infections的比例
Para_covid_age.prop_asym=1-Para_covid_age.prop_sym;  % 无症状的infections的比例
Para_covid_age.prop_sym_hosp=[0.00070108, 0.00070108, 0.0474, 0.1633, 0.2554];  % 住院的有症状病例的特定年龄比例
Para_covid_age.prop_hosp_dea=[0.04, 0.1237, 0.0312, 0.1075, 0.2316];  % 住院病例的死亡率
Para_covid_age.tao_sym=1/Para_covid_age.p_py+1/Para_covid_age.p_yr;  % 有症状的持续时间
Para_covid_age.tao_asym=1/Para_covid_age.p_ar;  % 无症状的持续时间

Para_covid_age.end_day=200;  % 总共的运行时间
save('Para_covid_age.mat','Para_covid_age');