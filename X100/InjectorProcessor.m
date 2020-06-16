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
       
        
        timerstateDay = 0 %用于确认主时钟t是否处于达到阈值后的pause状态且用于辨认pause的原因是由于达到24小时限制引起的还是一小时限制引起的 （0表示注射完毕自然停止 1表示因为达到阈值而中止 2表示正常注射状态）
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
            process.e.StartDelay = 0;%延时0秒开始
            process.e.ExecutionMode = 'fixedRate';%启用循环执行
            process.e.Period = 0.05;%循环间隔0.01秒
            process.e.TasksToExecute = inf;%循环次数无限
            process.e.TimerFcn = {@process.CaculateBolusforEm};
            
            
            
            process.App.setButton.Enable = 'off';
            process.App.startButton.Enable = 'off';
            
            process.t = timer();
            process.t.StartDelay = 0;%延时0秒开始
            process.t.ExecutionMode = 'fixedRate';%启用循环执行
            process.t.Period = 0.05;%循环间隔0.01秒
            process.t.TasksToExecute = inf;%循环次数无限
            process.t.TimerFcn = {@process.run};
            start(process.t);
            
            process.InjectorDB.BaselineOrigin = str2double(process.InjectorDB.Baseline);
            process.InjectorDB.BolusOrigin = str2double(process.InjectorDB.Bolus);
            
            process.timerstateDay = 2;
            process.timerstateHour = 2;
            
            
            process.caculateHour = timer();
            process.caculateHour.StartDelay = 0;%延时0秒开始
            process.caculateHour.ExecutionMode = 'fixedRate';%启用循环执行
            process.caculateHour.Period = 0.05;%循环间隔0.01秒
            process.caculateHour.TasksToExecute = inf;%循环次数无限
            process.caculateHour.TimerFcn = {@process.CaculateHour};
            start(process.caculateHour);
            
            
            process.caculateDay = timer();
            process.caculateDay.StartDelay = 0;%延时0秒开始
            process.caculateDay.ExecutionMode = 'fixedRate';%启用循环执行
            process.caculateDay.Period = 0.05;%循环间隔0.01秒
            process.caculateDay.TasksToExecute = inf;%循环次数无限
            process.caculateDay.TimerFcn = {@process.CaculateDay};
            start(process.caculateDay);
            
            process.m = timer();
            process.m.StartDelay = 0;%延时0秒开始
            process.m.ExecutionMode = 'fixedRate';%启用循环执行
            process.m.Period = 0.05;%循环间隔0.01秒
            process.m.TasksToExecute = inf;%循环次数无限
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
            
            if ((sum>=str2double(process.InjectorDB.AmountInShortPeriod))&&(process.timerstateHour ~= 1))%如果达到一小时阈值则将主时钟t stop
                process.timerstateHour = 1;
                stop(process.t);
            end
            
            if ((sum < str2double(process.InjectorDB.AmountInShortPeriod)) && (process.timerstateHour == 1)) %如果更新后的一小时内的注射量小于阈值且注射过程处于因达到一小时阈值的pause状态，则恢复注射
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
            
            if ((sum >= str2double(process.InjectorDB.AmountLimit))&&(process.timerstateDay ~= 1))%如果达到24小时阈值则将主时钟t stop
                stop(process.t);
                process.timerstateDay = 1;
            end
            
            if ((sum < str2double(process.InjectorDB.AmountLimit)) && (process.timerstateDay == 1)) %如果更新后的24小时内的注射量小于阈值且注射过程处于因达到24小时阈值的pause状态，则恢复注射
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
                %emergency shot结束后返回原来的注射速度
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
                %主要注射结束 但emegency shot可能仍在进行
                process.temp3 = 0;
                if strcmp(get(process.e, 'Running'),'off')%如果emegency shot已经结束或不存在，则停止主进程
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