classdef unitTestOrderProcessor < matlab.unittest.TestCase
    methods (Test)
        function testcreateOrder(testCase) % T2.1
            % State: No order exists
            % Input: table name and item list
            % Expected Output: 1) order registered in database; 2) order
            % registered message on server app; 3) order displayed on Chef
            % app
            db=OrderDB;
            pro=OrderProcessor;
            sapp=ServerUI;
            capp=ChefUI;
            pro.serverApp=sapp;
            pro.chefApp=capp;
            pro.orderDB=db;
            table='Table 1';
            itemList={'test' 1 20};
            % Execute the function
            od=pro.createOrder(table,itemList);
            % Check expected output
            testCase.verifyEqual(od,db.orderList(1));
            testCase.verifyEqual(sapp.Message.Text{2},sprintf('Order for %s Registered',od.table));
            testCase.verifyEqual(capp.OrderList1(1).Data{1},od.items{1});
            testCase.verifyEqual(capp.OrderList1(1).Data{2},od.items{2});
            testCase.verifyEqual(capp.OrderList1(1).Data{3},false);
            delete(sapp);
            delete(capp);
        end
        function testgetOrder(testCase) % T2.2
            % State: there is an incomplete order for that table
            % Input: Table number
            % Expected output: the order corresponds to that table
            db=OrderDB;
            pro=OrderProcessor;
            pro.orderDB=db;
            table='Table 1';
            itemList={'test' 1 20};
            od=Order;
            od.table=table;
            od.items=itemList;
            od.startTime=datestr(now,'HH:MM:SS');
            db.register(od);
            % Execute the function
            order=pro.getOrder(table);
            % Check expected output
            testCase.verifyEqual(order,od);
            
        end
        function testdisplayOrder(testCase) % T2.3
            % State: an order placed
            % Input: placed order
            % Expected output: 1) item name 2) item amount 3) ready or not
            db=OrderDB;
            capp=ChefUI;
            
            pro=OrderProcessor;
            pro.orderDB=db;
            pro.chefApp=capp;
            table='Table 1';
            itemList={'test' 1 20};
            od=Order;
            od.table=table;
            od.items=itemList;
            od.startTime=datestr(now,'HH:MM:SS');
            db.register(od);
            % Execute the function
            pro.displayOrder(od);
            % Check expected output
            testCase.verifyEqual(capp.OrderList1(1).Data{1},od.items{1});
            testCase.verifyEqual(capp.OrderList1(1).Data{2},od.items{2});
            testCase.verifyEqual(capp.OrderList1(1).Data{3},false);
            delete(capp);
        end
    end
    
    
end