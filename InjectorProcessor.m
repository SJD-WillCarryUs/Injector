classdef InjectorProcessor < handle
    
    properties
        App
        InjectorDB    
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
        
        function ToUpdateTotalAmount(process,data)
            process.InjectorDB.UpdateTotalAmount(data);
        end
        
        
        
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
        
        function re = checkTotalAmount(~,data) %check bolus
            value = str2double(data);
            %sum = value + process.InjectorDB.TotalAmount;
            %amountLimit = str2double(process.InjectorDB.AmountLimit);
            %if (sum <= amountLimit)
                %if (value >= 0.2 && value <=0.5)
                    %re = 't';
                %else
                    %re = 'f';
                %end
                %process.InjectorDB.Amount = sum;
            %else
                %re = 'f';
            %end
        %end
            if (value >= 0.2 && value <=0.5)
                re = 't';
            else
                re = 'f';
            end
        end
        
        function updateTotalAmount(process,temp) 
            process.InjectorDB.TotalAmount = temp;
            tempstr = num2str(temp,'%.6f');
            tempstr = strcat(tempstr,' ml '); 
            tempstr = strcat('TotalAmount:',tempstr);
            process.App.DisplayTextArea.Value = tempstr;
            %process.App.DisplayTextArea.Value = num2str(temp,'%.6f');
        end
        
        function start(process)
            t = timer();
            t.StartDelay = 0;%延时0秒开始
            t.ExecutionMode = 'fixedRate';%启用循环执行
            t.Period = 1;%循环间隔1秒
            t.TasksToExecute = inf;%循环次数无限
            t.TimerFcn = {@process.run};
            start(t);
        end
        
        function run(process,~,~)
            temp = 0.0;
            if (temp < str2double(process.InjectorDB.Bolus))
                temp = process.InjectorDB.TotalAmount +str2double(process.InjectorDB.Baseline)/60;
                process.updateTotalAmount(temp); 
                %pause(1);
            else
                stop(t);
            end
    
        end
        
       
        
        function emergencyShot(process)
            val = process.InjectorDB.Authority;
            if (strcmp(val,'off'))
                process.App.DisplayTextArea.Value = 'No Authority!';
                return;
            end
            %first we check if the input is valid (total baseline&bolus)
            
            EmBolus = str2double(process.InjectorDB.BolusforEm);
            EmBaseline = str2double(process.InjectorDB.BaselineforEm);
            
            NewBaseline = EmBaseline + str2double(process.InjectorDB.Baseline);
            re1 = process.checkTotalAmount(num2str(NewBaseline));
            
            NewBolus = EmBolus + str2double(process.InjectorDB.Bolus);
            re2 = process.checkSpeed(num2str(NewBolus));
            
            if (strcmp(re1,'f')||strcmp(re2,'f'))
                if(strcmp(re1,'f'))
                    process.App.DisplayTextArea.Value = 'BaselineforEm is invalid, please reset!';
                else
                    process.App.DisplayTextArea.Value = 'BolusforEm is invalid, please reset!';
                end
                return;
            else
                process.InjectorDB.Baseline = num2str(NewBaseline);
                process.InjectorDB.Bolus = num2str(NewBolus);
            end
          
            
            temp =0.0;
            while (temp < str2double(process.InjectorDB.BolusforEm))
                temp = temp + str2double(process.InjectorDB.BaselineforEm)/60;
                pause(1);
            end
            process.InjectorDB.Baseline = num2str(str2double(process.InjectorDB.Baseline)-str2double(process.InjectorDB.BaselineforEm));
            %emergency shot结束后返回原来的注射速度
        end
       
    end
    
end