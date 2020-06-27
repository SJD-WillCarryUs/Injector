classdef unitTestInjectorProcessor < matlab.unittest.TestCase
    methods (Test)
        function testupdateData(testCase) % T2.1
            % State: No order exists
            % Input: 
            % Expected Output: 1) order registered in database; 2) order
            % registered message on server app; 3) order displayed on Chef
            % app
            db=InjectorDB;
            pro=InjectorProcessor;
            app=InjectorUI;
            pro.App=app;
            pro.InjectorDB=db;
            data = 1;
            setlistID1 =  'AmountLimit';
            setlistID2 = 'AmountInShortPeriod';
            setlistID3 = 'Baseline';
            setlistID4 = 'Bolus';
            pro.updateData(data,setlistID1);
            pro.updateData(data,setlistID2);
            pro.updateData(data,setlistID3);
            pro.updateData(data,setlistID4);
            testCase.verifyEqual(db.AmountLimit,1);
            testCase.verifyEqual(db.AmountInShortPeriod,1);
            testCase.verifyEqual(db.Baseline,1);
            testCase.verifyEqual(db.Bolus,1);
            delete(app);
        end
        
        function testupdateAuthority(testCase) % T2.2
            % State: there is an incomplete order for that table
            % Input: Table number
            % Expected output: the order corresponds to that table
            db=InjectorDB;
            pro=InjectorProcessor;
            pro.InjectorDB=db;
            data = 1;
            pro.updateAuthority(data);
            testCase.verifyEqual(db.Authority,1);
        end
        
        function testgetData(testCase) % T2.3
            % State: No order exists
            % Input: 
            % Expected Output: 1) order registered in database; 2) order
            % registered message on server app; 3) order displayed on Chef
            % app
            db=InjectorDB;
            pro=InjectorProcessor;
            app=InjectorUI;
            pro.App=app;
            pro.InjectorDB=db;
            data = 'empty';
            setlistID1 =  'Baseline';
            setlistID2 = 'Bolus';
            setlistID3 = 'BaselineforEm';
            setlistID4 = 'Bolus';
            d1=pro.getdata(setlistID1);
            d2=pro.getdata(setlistID2);
            d3=pro.getdata(setlistID3);
            d4=pro.getdata(setlistID4);
            testCase.verifyEqual(d1,data);
            testCase.verifyEqual(d2,data);
            testCase.verifyEqual(d3,data);
            testCase.verifyEqual(d4,data);
            delete(app);
        end
        
        function testcheckSpeed(testCase) % T2.4
            % State: No order exists
            % Input: 
            % Expected Output: 1) order registered in database; 2) order
            % registered message on server app; 3) order displayed on Chef
            % app
            pro=InjectorProcessor;
            data1 = '0.05';
            data2 = '0.2';
            data3 = '0.001';
            
            d1=pro.checkSpeed(data1);
            d2=pro.checkSpeed(data2);
            d3=pro.checkSpeed(data3);
            testCase.verifyEqual(d1,'t');
            testCase.verifyEqual(d2,'f');
            testCase.verifyEqual(d3,'f');
        end
        
        function testcheckBolus(testCase) % T2.5
            % State: No order exists
            % Input: 
            % Expected Output: 1) order registered in database; 2) order
            % registered message on server app; 3) order displayed on Chef
            % app
            pro=InjectorProcessor;
            data1 = '0.3';
            data2 = '0.1';
            data3 = '0.6';
            
            d1=pro.checkBolus(data1);
            d2=pro.checkBolus(data2);
            d3=pro.checkBolus(data3);
            testCase.verifyEqual(d1,'t');
            testCase.verifyEqual(d2,'f');
            testCase.verifyEqual(d3,'f');
        end
        
        function testupdateTotalAmount(testCase) % T2.6
            % State: No order exists
            % Input: 
            % Expected Output: 1) order registered in database; 2) order
            % registered message on server app; 3) order displayed on Chef
            % app
            pro=InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB=db;
            temp = 1;
            pro.updateTotalAmount(temp);
            testCase.verifyEqual(db.TotalAmount,1);
        end
        
        function testCaculateHour(testCase) %T2.7
            pro = IntectorProcessor;
            db = InjectorDB;
            pro.Injector = db;
            pro.poweron
            
        end
    end
end