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
        
        function re = checkSpeed(~,data)
            value = str2double(data);
            if ((value <= 0.1) && (value >=0.01)) 
                re = 't';
            else
                re = 'f';
            end
        end
        
        function re = checkTotalAmount(~,data)
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
            temp = 0.0;
            while (temp < str2double(process.InjectorDB.Bolus))
                temp = process.InjectorDB.TotalAmount +str2double(process.InjectorDB.Baseline)/60;
                process.updateTotalAmount(temp); 
                pause(1);
            end
    
        end
        
       
        
        function emergencyShot(process)
            %first we check if the input is valid (total baseline&bolus)
            EmBolus = str2double(process.InjectorDB.BolusforEm);
            EmBaseline = str2double(process.InjectorDB.BaselineforEm);
            NewBaseline = EmBaseline + str2double(process.InjectorDB.Baseline);
            process.InjectorDB.Baseline = num2str(NewBaseline);
            NewBolus = EmBolus + str2double(process.InjectorDB.Bolus);
            process.InjectorDB.Bolus = num2str(NewBolus);
        end
       
    end
    
end