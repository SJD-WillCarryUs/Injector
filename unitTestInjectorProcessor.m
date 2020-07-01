classdef unitTestInjectorProcessor < matlab.unittest.TestCase
    methods (Test)
        
        function testcheckSpeed(testCase) % T1.2.1
            pro=InjectorProcessor;
            data1 = '0.05';     % Tcover 1.2.1.1
            data2 = '0.2';      % Tcover 1.2.1.2
            data3 = '0.001';    % Tcover 1.2.1.3
            
            d1=pro.checkSpeed(data1);
            d2=pro.checkSpeed(data2);
            d3=pro.checkSpeed(data3);
            testCase.verifyEqual(d1,'t');
            testCase.verifyEqual(d2,'f');
            testCase.verifyEqual(d3,'f');
        end
        
        function testcheckBolus(testCase) % T1,2.2
            pro=InjectorProcessor;
            data1 = '0.3';     % Tcover 1.2.2.1
            data2 = '0.1';     % Tcover 1.2.2.2
            data3 = '0.6';     % Tcover 1.2.2.3
            
            d1=pro.checkBolus(data1);
            d2=pro.checkBolus(data2);
            d3=pro.checkBolus(data3);
            testCase.verifyEqual(d1,'t');
            testCase.verifyEqual(d2,'f');
            testCase.verifyEqual(d3,'f');
        end
        
        function testupdateTotalAmount(testCase) % T1.2.3

            pro=InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB=db;
            temp = 1;
            pro.updateTotalAmount(temp);
            testCase.verifyEqual(db.TotalAmount,1);
        end
        
        function testCaculateHour1(testCase) %T1.2.4.1
            pro = InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB = db;
            pro.poweron();
            db.Baseline = '0.1';
            db.Bolus = '0.5';
            pro.HourCache(3011:3600)=0.0017;
            pro.timerstateHour = 2;
            
            start(pro.t);
            
            
            start(pro.caculateHour);
            
            testCase.verifyEqual(pro.interupt,1); 
        end
        
        function testCaculateHour2(testCase) %T1.2.4.2
            pro = InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB = db;
            db.Baseline = '0.1';
            db.Bolus = '0.5';
            pro.poweron();
            pro.timerstateHour = 2;
            
            start(pro.t);
            
           
            start(pro.caculateHour);
            
            testCase.verifyEqual(pro.interupt,0); 
        end
        
        function testCaculateHour3(testCase) %T1.2.4.3
            pro = InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB = db;
            db.Baseline = '0.1';
            db.Bolus = '0.5';
            pro.poweron();
            pro.timerstateHour = 2;
            
            
            
           
            start(pro.caculateHour);
            
            testCase.verifyEqual(pro.interupt,0); 
        end
        function testCaculateHour4(testCase) %T1.2.4.4
            pro = InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB = db;
            db.Baseline = '0.1';
            db.Bolus = '0.5';
            pro.poweron();
            pro.timerstateHour = 2;
            
            start(pro.t);
            start(pro.e)
           
            start(pro.caculateHour);
            
            testCase.verifyEqual(pro.interupt,0); 
        end
        function testCaculateDay1(testCase) %T1.2.5.1
            pro = InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB = db;
            db.Baseline = '0.1';
            db.Bolus = '0.5';
            pro.poweron();
            pro.timerstateDay = 2;
            
            start(pro.t);
            
            pro.DayCache(84635:86400)=0.0017;
            start(pro.caculateDay);
            
            testCase.verifyEqual(pro.interupt,1); 
        end
        
        function testCaculateDay2(testCase) %T1.2.5.2
            pro = InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB = db;
            db.Baseline = '0.1';
            db.Bolus = '0.5';
            pro.poweron();
            pro.timerstateDay = 2;
            
            start(pro.t);
            
           
            start(pro.caculateDay);
            
            testCase.verifyEqual(pro.interupt,0); 
        end
        
        function testCaculateBolusforEM1(testCase) %T1.2.5.3
            pro = InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB = db;
            db.Baseline = '0.1';
            db.Bolus = '0.5';
            db.BolusforEm = '0.1';
            db.BaselineforEm = '0.06';
            pro.poweron();
            pro.timerstateDay = 2;
            
            start(pro.t);
            
            pro.CaculateBolusforEm();
            
            testCase.verifyEqual(pro.temp2,0.001); 
        end
        function testCaculateBolusforEM2(testCase) %T1.2.5.4
            pro = InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB = db;
            db.Baseline = '0.1';
            db.Bolus = '0.5';
            db.BolusforEm = '0';
            db.BaselineforEm = '0.06';
            pro.poweron();
            pro.timerstateDay = 2;
            
            start(pro.t);
            
            pro.CaculateBolusforEm();
            
            testCase.verifyEqual(pro.temp2,0); 
        end
        
        function testCaculateBolus1(testCase) %T1.2.6.1
            pro = InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB = db;
            db.BolusOrigin = 0.1;
            db.BaselineOrigin = 0.06;
            pro.poweron();
            pro.timerstateDay = 2;
            
            start(pro.t);
            
            pro.CaculateBolus();
            
            testCase.verifyEqual(pro.temp3,0.001); 
        end
        
        function testCaculateBolus2(testCase) %T1.2.6.2
            pro = InjectorProcessor;
            db = InjectorDB;
            pro.InjectorDB = db;
            pro.temp3 = 1;
            db.Baseline = '0.1';
            db.BolusOrigin = 0.05;
            db.BaselineOrigin = 0.05;
            pro.poweron();
            pro.timerstateDay = 2;
            
            start(pro.t);
            
            pro.CaculateBolus();
            
            testCase.verifyEqual(pro.temp3,0); 
            testCase.verifyEqual(db.Baseline,'0.05'); 
        end
        
        function testupdateData(testCase) % T2.1.1

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
        
        function testupdateAuthority(testCase) % T2.1.2
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
        
        function testgetData(testCase) % T2.1.3
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
    end
end