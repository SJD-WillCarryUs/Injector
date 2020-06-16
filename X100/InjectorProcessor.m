classdef InjectorProcessor < handle
    
    properties
        App
        App2
        InjectorDB
        
        i = 1
        j = 1
        
        HourCache=linspace(0,0,3600)
        DayCache=linspace(0,0,86400)
        
        t %timer for function run(process,~,~)
        m %timer for amount of OriginBolus injected
        e %timer for amount of BolusforEm injected
        
        caculateHour 
        caculateDay 
       
        
        timerstateDay = 0 %����ȷ����ʱ��t�Ƿ��ڴﵽ��ֵ���pause״̬�����ڱ���pause��ԭ�������ڴﵽ24Сʱ��������Ļ���һСʱ��������� ��0��ʾע�������Ȼֹͣ 1��ʾ��Ϊ�ﵽ��ֵ����ֹ 2��ʾ����ע��״̬��
        timerstateHour = 0
        
        temp1 = 0.0
        temp2 = 0.0
        temp3 = 0.0
    end
    
    methods
        function updateData(process,data,setlistID)
            switch setlistID
                case 'AmountLimit'
                    process.InjectorDB.SetAmountLimit(data);
                case 'AmountInShortPeriod'
                    process.InjectorDB.SetAmountInShortPeriod(data);
                case 'Baseline'
                    process.InjectorDB.SetBaseline(data);
                case 'Bolus'
                    process.InjectorDB.SetBolus(data);
            end
        end
        function updateAuthority(process,bol)
            process.InjectorDB.SetAuthority(bol);
        end
        
       % function ToUpdateTotalAmount(process,data)
         %   process.InjectorDB.UpdateTotalAmount(data);
       % end
        
        
        
        function data = getdata(process,id)
            switch id
                case 'Baseline'
                    data = process.InjectorDB.Baseline;
                case 'Bolus'
                    data = process.InjectorDB.Bolus;
                case 'BaselineforEm'
                    data = process.InjectorDB.BaselineforEm;
                case 'BolusforEm'
                    data = process.InjectorDB.BolusforEm;
            end
        end
        
        function re = checkSpeed(~,data) %check baseline
            value = str2double(data);
            if ((value <= 0.1) && (value >=0.01)) 
                re = 't';
            else
                re = 'f';
            end
        end
        
        function re = checkBolus(~,data) %check bolus
            value = str2double(data);
           
            if (value >= 0.2 && value <=0.5)
                re = 't';
            else
                re = 'f';
            end
        end
        
        %updateTotalAmount and show in the monitor
        function updateTotalAmount(process,temp) 
            process.InjectorDB.TotalAmount = temp;
            tempstr = num2str(temp,'%.2f');
            tempstr = strcat(tempstr,' ml '); 
            tempstr = strcat('TotalAmount:',tempstr);
            process.App.DisplayTextArea.Value = tempstr;
        end
        
        function start(process)
            
            process.e = timer();
            process.e.StartDelay = 0;%��ʱ0�뿪ʼ
            process.e.ExecutionMode = 'fixedRate';%����ѭ��ִ��
            process.e.Period = 0.05;%ѭ�����0.01��
            process.e.TasksToExecute = inf;%ѭ����������
            process.e.TimerFcn = {@process.CaculateBolusforEm};
            
            
            
            process.App.setButton.Enable = 'off';
            process.App.startButton.Enable = 'off';
            
            process.t = timer();
            process.t.StartDelay = 0;%��ʱ0�뿪ʼ
            process.t.ExecutionMode = 'fixedRate';%����ѭ��ִ��
            process.t.Period = 0.05;%ѭ�����0.01��
            process.t.TasksToExecute = inf;%ѭ����������
            process.t.TimerFcn = {@process.run};
            start(process.t);
            
            process.InjectorDB.BaselineOrigin = str2double(process.InjectorDB.Baseline);
            process.InjectorDB.BolusOrigin = str2double(process.InjectorDB.Bolus);
            
            process.timerstateDay = 2;
            process.timerstateHour = 2;
            
            
            process.caculateHour = timer();
            process.caculateHour.StartDelay = 0;%��ʱ0�뿪ʼ
            process.caculateHour.ExecutionMode = 'fixedRate';%����ѭ��ִ��
            process.caculateHour.Period = 0.05;%ѭ�����0.01��
            process.caculateHour.TasksToExecute = inf;%ѭ����������
            process.caculateHour.TimerFcn = {@process.CaculateHour};
            start(process.caculateHour);
            
            
            process.caculateDay = timer();
            process.caculateDay.StartDelay = 0;%��ʱ0�뿪ʼ
            process.caculateDay.ExecutionMode = 'fixedRate';%����ѭ��ִ��
            process.caculateDay.Period = 0.05;%ѭ�����0.01��
            process.caculateDay.TasksToExecute = inf;%ѭ����������
            process.caculateDay.TimerFcn = {@process.CaculateDay};
            start(process.caculateDay);
            
            process.m = timer();
            process.m.StartDelay = 0;%��ʱ0�뿪ʼ
            process.m.ExecutionMode = 'fixedRate';%����ѭ��ִ��
            process.m.Period = 0.05;%ѭ�����0.01��
            process.m.TasksToExecute = inf;%ѭ����������
            process.m.TimerFcn = {@process.CaculateBolus};
            start(process.m);
           
        end
        
         function run(process,~,~)

                process.temp1 = process.InjectorDB.TotalAmount +str2double(process.InjectorDB.Baseline)/60;
                process.updateTotalAmount(process.temp1); 
  
         
    
        end
        
        function CaculateHour(process,~,~)
            process.HourCache(process.i) = str2double(process.InjectorDB.Baseline)/60;
            sum = 0.0;
            
            for a=1:3600
                sum=process.HourCache(a)+sum;
            end
            
            if ((sum>=str2double(process.InjectorDB.AmountInShortPeriod))&&(process.timerstateHour ~= 1))%����ﵽһСʱ��ֵ����ʱ��t stop
                process.timerstateHour = 1;
                stop(process.t);
            end
            
            if ((sum < str2double(process.InjectorDB.AmountInShortPeriod)) && (process.timerstateHour == 1)) %������º��һСʱ�ڵ�ע����С����ֵ��ע����̴�����ﵽһСʱ��ֵ��pause״̬����ָ�ע��
                start(process.t);
                process.timerstateHour = 2;
            end
            
            if(process.i <3600)
                process.i=process.i+1;
            else
                process.i = 1;
            end
            
        end
        
        function CaculateDay(process,~,~) 
            process.DayCache(process.j) = str2double(process.InjectorDB.Baseline)/60;
            sum = 0;
            
            for a=1:86400
                sum=process.DayCache(a)+sum;
            end
            
            if ((sum >= str2double(process.InjectorDB.AmountLimit))&&(process.timerstateDay ~= 1))%����ﵽ24Сʱ��ֵ����ʱ��t stop
                stop(process.t);
                process.timerstateDay = 1;
            end
            
            if ((sum < str2double(process.InjectorDB.AmountLimit)) && (process.timerstateDay == 1)) %������º��24Сʱ�ڵ�ע����С����ֵ��ע����̴�����ﵽ24Сʱ��ֵ��pause״̬����ָ�ע��
                start(process.t);
                process.timerstateDay = 2;
            end
            
            if(process.j <86400)
                process.j=process.j+1;
            else
                process.j = 1;
            end
            
        end
            
            

        
       
        
        
            
        
        function CaculateBolusforEm(process,~,~)
             if (process.temp2 < str2double(process.InjectorDB.BolusforEm))
                process.temp2 = process.temp2 + str2double(process.InjectorDB.BaselineforEm)/60;
             else
                process.InjectorDB.Baseline = num2str(str2double(process.InjectorDB.Baseline)-str2double(process.InjectorDB.BaselineforEm));
                %emergency shot�����󷵻�ԭ����ע���ٶ�
                process.temp2 = 0;
                process.App2.emergencyshotButton.Enable = 'on';
                if strcmp(get(process.m, 'Running'),'off')
                    
                    process.App.setButton.Enable = 'on';
                    process.App.startButton.Enable = 'on';
              
                
                    process.App.TextArea_BaselineforEm.Value = 'waiting!';
                    process.App.TextArea_BolusforEm.Value = 'waiting!';
                    process.App.TextArea_Baseline.Value = 'waiting!';
                    process.App.TextArea_Bolus.Value = 'waiting!';
                
               
                    process.InjectorDB.Bolus = 'empty';
                    process.InjectorDB.BaselineforEm = 'empty';
                    process.InjectorDB.BolusforEm = 'empty';
                    stop(process.t);
                end
                stop(process.e);
             end
                 
        end
        
        
        function CaculateBolus(process,~,~)
             if (process.temp3 < process.InjectorDB.BolusOrigin)
                
                process.temp3 = process.temp3 + process.InjectorDB.BaselineOrigin/60;
             else
                process.InjectorDB.Baseline = num2str(str2double(process.InjectorDB.Baseline)-process.InjectorDB.BaselineOrigin);
                %��Ҫע����� ��emegency shot�������ڽ���
                process.temp3 = 0;
                if strcmp(get(process.e, 'Running'),'off')%���emegency shot�Ѿ������򲻴��ڣ���ֹͣ������
                    process.App.setButton.Enable = 'on';
                    process.App.startButton.Enable = 'on';
              
                
                    process.App.TextArea_BaselineforEm.Value = 'waiting!';
                    process.App.TextArea_BolusforEm.Value = 'waiting!';
                    process.App.TextArea_Baseline.Value = 'waiting!';
                    process.App.TextArea_Bolus.Value = 'waiting!';
                
               
                    process.InjectorDB.Bolus = 'empty';
                    process.InjectorDB.BaselineforEm = 'empty';
                    process.InjectorDB.BolusforEm = 'empty';
                    
                    stop(process.t);
                end
                stop(process.m);
                
             end
                 
        end
        
 
        
        
        
        
        
        function emergencyShot(process)
            %firstly check if the patient get Authority
            val = process.InjectorDB.Authority;
            if (strcmp(val,'off'))
                process.App.DisplayTextArea.Value = 'No Authority!';
                return;
            end
            %secondly we check if the input is valid (total baseline&bolus)
            
            EmBolus = str2double(process.InjectorDB.BolusforEm);
            EmBaseline = str2double(process.InjectorDB.BaselineforEm);
            
            NewBaseline = EmBaseline + str2double(process.InjectorDB.Baseline);
            re1 = process.checkSpeed(num2str(NewBaseline));
            
            NewBolus = EmBolus + str2double(process.InjectorDB.Bolus);
            re2 = process.checkBolus(num2str(NewBolus));
            
            if (strcmp(re1,'f')||strcmp(re2,'f'))
                if(strcmp(re1,'f'))
                    process.App.DisplayTextArea.Value = 'BaselineforEm is invalid, please reset!';
                    process.App.setButton.Enable = 'on';
                else
                    process.App.DisplayTextArea.Value = 'BolusforEm is invalid, please reset!';
                    process.App.setButton.Enable = 'on';
                end
                return;
            else
                %then we change the speed and bolus
                process.InjectorDB.Baseline = num2str(NewBaseline);
                process.InjectorDB.Bolus = num2str(NewBolus);
                process.App.setButton.Enable = 'off';
                process.App2.emergencyshotButton.Enable = 'off';
            end
          
            %meanwhile, caculate the amount of BolusforEm injected
            
        
            start(process.e);
            
           
           
           
        end
       
    end
    
end