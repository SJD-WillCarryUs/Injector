classdef unitTestInjectorDB < matlab.unittest.TestCase
    methods (Test)
        function testSetAmountLimit(testCase) % T1.1.1
            % State: No AmountLimit set yet
            % Input: New AmountLimit
            % Expected Output: New AmountLimit set in injectorDB
            db=InjectorDB;
            data = 1;
            db.SetAmountLimit(data);
            testCase.verifyEqual(db.AmountLimit,1);
        end
        function testSetAmountInShortPeriod(testCase) % T1.1.2
            % State: No AmountInShortPerio set yet
            % Input: New AmountInShortPerio
            % Expected Output: New AmountInShortPerio set in injectorDB
            db=InjectorDB;
            data = 1;
            db.SetAmountInShortPeriod(data);
            testCase.verifyEqual(db.AmountInShortPeriod,1);
        end
        function testSetBaseline(testCase) % T1.1.3
            % State: No Baseline set yet
            % Input: New Baseline
            % Expected Output: New Baseline set in injectorDB
            db=InjectorDB;
            data = 0.1;
            db.SetBaseline(data);
            testCase.verifyEqual(db.Baseline,0.1);
        end
        function testSetBolus(testCase) % T1.1.4
            % State: No Bolus set yet
            % Input: New Bolus
            % Expected Output: New Bolus set in injectorDB
            db=InjectorDB;
            data = 0.1;
            db.SetBolus(data);
            testCase.verifyEqual(db.Bolus,0.1);
        end
        function testSetAuthority(testCase) % T1.1.5
            % State: No Authority set yet
            % Input: New Authority
            % Expected Output: New Authority set in injectorDB
            db=InjectorDB;
            data = 1;
            db.SetAuthority(data);
            testCase.verifyEqual(db.Authority,1);
        end
        function testUpdateTotalAmount(testCase) % T1.1.6
            % State: the total amount hasn't change
            % Input: New TotalAmount
            % Expected Output: New TotalAmount set in injectorDB
            db=InjectorDB;
            data = 1;
            db.UpdateTotalAmount(data);
            testCase.verifyEqual(db.TotalAmount,1);
        end
    end
    
end