classdef testInjectorApp2 < matlab.uitest.TestCase  % T3.2
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
            testCase.type(testCase.app.inputEditField,'0.05');
            pause(1);
            testCase.press(testCase.app.setButton);
            pause(1);
            testCase.choose(testCase.app.setlistDropDown,'Bolus');
            pause(1);
            testCase.type(testCase.app.inputEditField,'0.2');
            pause(1);
            testCase.press(testCase.app.setButton);
            pause(1);
            testCase.choose(testCase.app.setlistDropDown,'BolusforEm');
            pause(1);
            testCase.type(testCase.app.inputEditField,'0.2');
            pause(1);
            testCase.press(testCase.app.setButton);  
            pause(1);
            testCase.choose(testCase.app.setlistDropDown,'BaselineforEm');
            pause(1);
            testCase.type(testCase.app.inputEditField,'0.05');
            pause(1);
            testCase.press(testCase.app.setButton);
            pause(1);
            testCase.press(testCase.app.startButton);
            pause(1);
            testCase.press(testCase.app2.emergencyshotButton);
            pause(10);
            testCase.addTeardown(@delete,testCase.app);
            testCase.addTeardown(@delete,testCase.app2);

        end
        
    end
    
end