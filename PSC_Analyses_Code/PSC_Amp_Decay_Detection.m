
function [PSC_Amp, Tau_Decay] = PSC_Amp_Decay_Detection(Data,Stim_Time,Artifact_Time, Ave_window, PSC_Direction)

%%%%% PSC_Amp: PSC amp output
%%%%% Tau_Decay: PSC decay time constant
%%%%% Data: data used to caculate PSC amp and decay
%%%%% Stim_Time: Time points of electrical stimulations in every trial
%%%%% Artifact_Time: duration of artifact
%%%%% Ave_window: window size used to calculate PSC amp
%%%%% PSC_Direction: inward current (0) or outward current (1)


    if(PSC_Direction ~= 1)    %%%%% caculate based on outward current
        Data = -Data;
    end
    
    for i = 1:size(Data,1)
        for j = 1:length(Stim_Time)
            
            %%%%%%%% caculate Amp %%%%%%%%%%%%%%%%%%%%%
            Peak = Data(i,Stim_Time(j) + Artifact_Time:Stim_Time(j) + 300);
            Temp = find(Peak == max(Peak),1);
            if(Temp - Ave_window > 0 && Temp + Ave_window < length(Peak))
                PSC_Amp(i,j) = max(Peak(Temp - Ave_window:Temp + Ave_window));
            else
                PSC_Amp(i,j) = max(Peak);
            end
            
            %%%%%%% Fitting with non-linear least squares sense
            Para_Temp_Fit = lsqcurvefit(@myfun_sPSC,[mean(Peak(Temp:end)) 1 200],1:length(Peak(Temp:end)), Peak(Temp:end));
            Fit_line = myfun_sPSC(Para_Temp_Fit,1:length(Peak(Temp:end)));
            
            figure
            plot(Peak(Temp:end));
            hold on
            plot(Fit_line,'r-');
            
            Tau_Decay(i,j) = abs(Para_Temp_Fit(3))/10;  %% decay time constant ms
            
        end
        clear Peak Temp Para_Temp_Fit
        close all
    end
    