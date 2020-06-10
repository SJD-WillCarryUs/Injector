classdef InjectorProcessor < handle
    
    properties
        App
        App2
        InjectorDB
        
        i = 1
        j = 1
        
        HourCache
        DayCache
        
        t %timer for function run(process,~,~)
        e %timer for amount of BolusforEm injected
        
        caculateHour 
        caculateDay 
       
        
        timerstateDay = 0 %����ȷ����ʱ��t�Ƿ��ڴﵽ��ֵ���pause״̬�����ڱ���pause��ԭ�������ڴﵽ24Сʱ��������Ļ���һСʱ��������� ��0��ʾע�������Ȼֹͣ 1��ʾ��Ϊ�ﵽ��ֵ����ֹ 2��ʾ����ע��״̬��
        timerstateHour = 0
        
        temp1 = 0
        temp2 = 0
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
            tempstr = num2str(temp,'%.6f');
            tempstr = strcat(tempstr,' ml '); 
            tempstr = strcat('TotalAmount:',tempstr);
            process.App.DisplayTextArea.Value = tempstr;
        end
        
        function start(process)
            process.App.setButton.Enable = 'off';
            process.App.startButton.Enable = 'off';
            
            process.t = timer();
            process.t.StartDelay = 0;%��ʱ0�뿪ʼ
            process.t.ExecutionMode = 'fixedRate';%����ѭ��ִ��
            process.t.Period = 1;%ѭ�����1��
            process.t.TasksToExecute = inf;%ѭ����������
            process.t.TimerFcn = {@process.run};
            start(process.t);
            
            process.timerstateDay = 2;
            process.timerstateHour = 2;
            
            
            process.caculateHour = timer();
            process.caculateHour.StartDelay = 0;%��ʱ0�뿪ʼ
            process.caculateHour.ExecutionMode = 'fixedRate';%����ѭ��ִ��
            process.caculateHour.Period = 1;%ѭ�����1��
            process.caculateHour.TasksToExecute = inf;%ѭ����������
            process.caculateHour.TimerFcn = {@process.CaculateHour};
            start(process.caculateHour);
            
            
            process.caculateDay = timer();
            process.caculateDay.StartDelay = 0;%��ʱ0�뿪ʼ
            process.caculateDay.ExecutionMode = 'fixedRate';%����ѭ��ִ��
            process.caculateDay.Period = 1;%ѭ�����1��
            process.caculateDay.TasksToExecute = inf;%ѭ����������
            process.caculateDay.TimerFcn = {@process.CaculateDay};
            start(process.caculateDay);
           
        end
        
        function CaculateHour(process,~,~)
            process.HourCache(process.i) = process.InjectorDB.Baseline/60;
            sum = 0;
            
            for a=1:3600
                sum=process.HourCache(a)+sum;
            end
            
            if ((sum>=str2double(process.InjectorDB.AmountInShortPeriod))&&(process.timerstateHour ~= 1))%����ﵽһСʱ��ֵ����ʱ��t stop
                stop(process.t);
                process.timerstateHour = 1;
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
            process.DayCache(process.j) = process.InjectorDB.Baseline/60;
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
            
            
        
            
     
                
        
        function run(process,~,~)
        
            if (process.temp1 < str2double(process.InjectorDB.Bolus))
                process.temp1 = process.InjectorDB.TotalAmount +str2double(process.InjectorDB.Baseline)/60;
                process.updateTotalAmount(process.temp1); 
            else
                stop(process.t);
                process.timerstateHour = 0;
                process.timerstateDay = 0;
                process.App.setButton.Enable = 'on';
                process.App.startButton.Enable = 'on';
            end
    
        end
        
        
            
        
        function CaculateBolusforEm(process,~,~)
             if (process.temp2 < str2double(process.InjectorDB.BolusforEm))
                process.temp2 = process.temp2 + str2double(process.InjectorDB.BaselineforEm)/60;
             else
                process.InjectorDB.Baseline = num2str(str2double(process.InjectorDB.Baseline)-str2double(process.InjectorDB.BaselineforEm));
                %emergency shot�����󷵻�ԭ����ע���ٶ�
                stop(process.e);
                process.temp2 = 0;
                process.App2.emergencyshotButton.Enable = 'on';
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
            
            process.e = timer();
            process.e.StartDelay = 0;%��ʱ0�뿪ʼ
            process.e.ExecutionMode = 'fixedRate';%����ѭ��ִ��
            process.e.Period = 1;%ѭ�����1��
            process.e.TasksToExecute = inf;%ѭ����������
            process.e.TimerFcn = {@process.CaculateBolusforEm};
            start(process.e);
            
           
           
           
        end
       
    end
    
end