classdef testInjectorApp4 < matlab.uitest.TestCase  % T3.4
    properties
        app
        app2
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            db=InjectorDB;
            pro=InjectorProcessor;
            testCase.app=InjectorUI;
            testCase.app2=Emergency;
 
            pro.App=testCase.app;
            pro.InjectorDB=db;
            pro.App2=testCase.app2;

            testCase.app.InjectorDB = db;

            testCase.app.InjectorProcessor=pro;
            testCase.app2.InjectorProcessor=pro;
            db.processor=pro;
            
        end
    end
    methods (Test)
        function test_SelectButtonPushed(testCase) 
            testCase.press(testCase.app.powerSwitch);
            testCase.type(testCase.app.inputEditField,'0.1');
            testCase.press(testCase.app.setButton);
            pause(0.5);
            testCase.choose(testCase.app.setlistDropDown,'Bolus');
            testCase.type(testCase.app.inputEditField,'0.5');
            testCase.press(testCase.app.setButton);
            pause(0.5);
            testCase.choose(testCase.app.setlistDropDown,'BolusforEm');
            testCase.type(testCase.app.inputEditField,'0.2');
            testCase.press(testCase.app.setButton); 
            pause(0.5);
            testCase.choose(testCase.app.setlistDropDown,'BaselineforEm');
            testCase.type(testCase.app.inputEditField,'0.05');
            testCase.press(testCase.app.setButton); 
            pause(0.5);
            testCase.press(testCase.app.startButton);
 
            pause(8);
            
            testCase.choose(testCase.app.setlistDropDown,'Baseline');
            testCase.type(testCase.app.inputEditField,'0.1');
            testCase.press(testCase.app.setButton);
            pause(0.5);
            testCase.choose(testCase.app.setlistDropDown,'Bolus');
            testCase.type(testCase.app.inputEditField,'0.3');
            testCase.press(testCase.app.setButton);
            pause(0.5);
            testCase.choose(testCase.app.setlistDropDown,'BolusforEm');
            testCase.type(testCase.app.inputEditField,'0.2');
            testCase.press(testCase.app.setButton);  
            pause(0.5);
            testCase.choose(testCase.app.setlistDropDown,'BaselineforEm');
            testCase.type(testCase.app.inputEditField,'0.05');
            testCase.press(testCase.app.setButton); 
            pause(0.5);
            testCase.press(testCase.app.startButton);
            pause(5);
            
            testCase.choose(testCase.app.setlistDropDown,'Baseline');
            testCase.type(testCase.app.inputEditField,'0.1');
            testCase.press(testCase.app.setButton);
            pause(0.51);
            testCase.choose(testCase.app.setlistDropDown,'Bolus');
            testCase.type(testCase.app.inputEditField,'0.5');
            testCase.press(testCase.app.setButton);
            pause(0.5);
            testCase.choose(testCase.app.setlistDropDown,'BolusforEm');
            testCase.type(testCase.app.inputEditField,'0.2');
            testCase.press(testCase.app.setButton);  
            pause(0.5);
            testCase.choose(testCase.app.setlistDropDown,'BaselineforEm');
            testCase.type(testCase.app.inputEditField,'0.05');
            testCase.press(testCase.app.setButton); 
            pause(0.5);
            testCase.press(testCase.app.startButton);
            pause(75);
            testCase.addTeardown(@delete,testCase.app);
            testCase.addTeardown(@delete,testCase.app2);
               
        end
        
    end
    
end