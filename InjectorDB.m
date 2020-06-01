classdef InjectorDB < handle
    
    properties
        processor
        
        AmountLimit = '3';
        AmountInShortPeriod = '1';
        Baseline = 'empty';
        Bolus = 'empty';
        Authority = 'off';
        Amount = 0.0;
        
        TotalAmount = 0.0;
    end
    
    methods
        function SetAmountLimit(DB,data)
            DB.AmountLimit=data;
        end
        function SetAmountInShortPeriod(DB,data)
            DB.AmountInShortPeriod=data;
        end
        function SetBaseline(DB,data)
            DB.Baseline=data;
        end
        function SetBolus(DB,data)
            DB.Bolus=data;
        end
        
        
        function SetAuthority(DB,bol)
            DB.Authority=bol;
        end
        
        function UpdateTotalAmount(DB,data)
            DB.TotalAmount=data;
        end
    end    
    
end