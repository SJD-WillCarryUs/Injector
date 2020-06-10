close all
clear all 
db=InjectorDB;
pro=InjectorProcessor;
app=InjectorUI;
app2=Emergency;
 
pro.App=app;
pro.InjectorDB=db;
pro.App2=app2;

app.InjectorProcessor=pro;
app.InjectorDB = db;

app2.InjectorProcessor=pro;

db.processor=pro;