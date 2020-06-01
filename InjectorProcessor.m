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
                case 'AmountLimit'
                    data = process.InjectorDB.AmountLimit;
                case 'AmountInShortPeriod'
                    data = process.InjectorDB.AmountInShortPeriod;
                case 'Baseline'
                    data = process.InjectorDB.Baseline;
                case 'Bolus'
                    data = process.InjectorDB.Bolus;
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
        
        function re = checkTotalAmount(process,data)
            value = str2double(data);
            sum = value + process.InjectorDB.TotalAmount;
            amountLimit = str2double(process.InjectorDB.AmountLimit);
            if (sum <= amountLimit)
                if (value >= 0.2 && value <=0.5)
                    re = 't';
                else
                    re = 'f';
                end
                process.InjectorDB.Amount = sum;
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
            global stopcheck;
            global i;
            %global t;
            i=1;
            stopcheck = 'f';
            temp = 0.0;
            while (temp < process.InjectorDB.Amount && strcmp(stopcheck,'f') )
                temp = process.InjectorDB.TotalAmount +str2double(process.InjectorDB.Baseline)/60;
                process.updateTotalAmount(temp); 
                pause(1);
                i=i+1;
                %t=t+1;
            end
    
        end
        
        function stop(process)
            global stopcheck;
            global i;
            %global t;
            stopcheck = 't';
            process.InjectorDB.Amount = process.InjectorDB.Amount - (str2double(process.InjectorDB.Baseline)/60)*i;
            process.App.TextArea_Bolus.Value = num2str(process.InjectorDB.Amount,'%.4f');
            process.InjectorDB.Bolus = num2str(process.InjectorDB.Amount,'%.8f');
            %while (strcmp(stopcheck,'t'))
            %    t=t+1;
            %end
        end
        
        function emergencyShot(process)
            
        end
       
    end
    
end