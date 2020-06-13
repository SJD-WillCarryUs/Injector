classdef testInjectorApp < matlab.uitest.TestCase
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
            % testCase.addTeardown(@delete,testCase.app);
        end
    end
    methods (Test)
        function test_SelectButtonPushed(testCase)
            % State: No order for the table and no dish selected
            % Input: Choose appetizer 1 and press select button
            % Expected Output: OrderList has appetizer 1's name, amount and
            % unit price
            testCase.press(testCase.app.AuthoritySwitch);
            pause(0.5);
            testCase.type(testCase.app.inputEditField,'0.05');
            pause(0.5);
            testCase.press(testCase.app.setButton);
            pause(0.5);
            testCase.choose(testCase.app.setlistDropDown,'Bolus');
            pause(0.5);
            testCase.type(testCase.app.inputEditField,'0.2');
            pause(0.5);
            testCase.press(testCase.app.setButton);
            pause(0.5);
            testCase.choose(testCase.app.setlistDropDown,'BolusforEm');
            pause(0.5);
            testCase.type(testCase.app.inputEditField,'0.2');
            pause(0.5);
            testCase.press(testCase.app.setButton);  
            pause(0.5);
            testCase.choose(testCase.app.setlistDropDown,'BaselineforEm');
            pause(0.5);
            testCase.type(testCase.app.inputEditField,'0.05');
            pause(0.5);
            testCase.press(testCase.app.setButton);
            pause(0.5);
            testCase.press(testCase.app.startButton);
            pause(0.5);
            testCase.press(testCase.app2.emergencyshotButton);
            pause(1);
%             testCase.choose(testCase.app.appetizer1Node);
%             pause(0.5)
%             testCase.press(testCase.app.SelectButton);
%             pause(0.5)
%             testCase.verifyEqual(testCase.app.OrderList.Data{1},testCase.app.appetizer1Node.Text);
%              testCase.verifyEqual(testCase.app.OrderList.Data{2},1);
%               testCase.verifyEqual(testCase.app.OrderList.Data{3},testCase.app.appetizer1Node.NodeData);
        end
        
    end
    
end