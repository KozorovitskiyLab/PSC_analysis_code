
close all
clear; clc

%%%%% Data pathway %%%%%%%%%%%%%
cd('C:\Users\K-Lab\Desktop\Code_PSC_Analyses\Example_Data');

%%%%% Trials used for analyses %%%%
N = [1:5]; % the trial number for analyses

%%%%% Stimuli time %%%%%%%%%%%%%%%%%
Stim_Time = [20000 20500]; %% when you stimulate in every trial

%%%%% Resistance detecting %%%%%%%%%
RC_test_Time = 9000; %%% VCRC 
RC_test_duration = 100; % VCRC duration
RC_V = -5; %% mV

%%%%% inward or outward current  %%%%%%%%
PSC_Direction = 0;  %%% 0: inward current; 1: outward current

%%%%% data loading, normalizing, and caculating resistance in every trial %%%%%%%%%%
Norm_Data = [];
RC_Trial = zeros(1,length(N));
for i = 1:length(N)
    %%%%%% data loading %%%%%%%%%%
    File_Name = ['AD0_',num2str(N(i)),'.mat']; %data recorded by channel0
    load(File_Name);
    Data_Name = ['AD0_',num2str(N(i))];
    Data = eval([Data_Name,'.data']);
    
    %%%%%% Normalizing every trial %%%%%%%%%
    Norm_Data(i,:) = Data - mean(Data(Stim_Time(1) - 1000:Stim_Time(1))); %%% Norm the data based on 100ms data before 1st stimulation
    
    %%%%%% Caculating resistance in every trial %%%%%%%%%%
    RC_Trial(i) = abs(RC_V) / (mean(Data(RC_test_Time:RC_test_Time + RC_test_duration)) - mean(Data(RC_test_Time - RC_test_duration:RC_test_Time)))*1000;  % Megohm
    clear File_Name Data_Name Data
end


%%%%%%%%%%%%%%%%% PSC Amplitudes and decay time constant %%%%%%%%%%%%%%
Artifact_Time = 25; %% duration of stimulus artifact: determined by stimulus duration and distance between stimulation and recording electrodes 
Ave_window = 5; %%%% Average amplitude around peak value
[PSC_Amp_Trial, PSC_Decay_Trial] = PSC_Amp_Decay_Detection(Norm_Data, Stim_Time, Artifact_Time, Ave_window, PSC_Direction);


%%%%%%%%%%%%%%%%% plot figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H1 = figure('Position',[50 30 1000 350]);
subplot(1,2,1)
plot(PSC_Amp_Trial,'-o');
set(gca,'fontsize',14);
set(gca,'XLim',[0,length(N) + 1]);
set(gca,'XTick',0:10:length(N));
set(gca, 'Xticklabel',0:5:length(N)/2);
set(gca,'box','off');
set(gca,'YLim',[0,250]);
xlabel('Time','fontsize',16);
ylabel('Amplitude(pA)','fontsize',16)

subplot(1,2,2)
plot(PSC_Decay_Trial,'-o');
hold on
set(gca,'fontsize',14);
set(gca,'XLim',[0,length(N) + 1]);
set(gca,'XTick',0:10:length(N));
set(gca, 'Xticklabel',0:5:length(N)/2);
set(gca,'box','off');
set(gca,'YLim',[0,10]);
xlabel('Time','fontsize',16);
ylabel('Decay time constant (ms)','fontsize',16)
