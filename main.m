close all
clear all 
db=InjectorDB;
pro=InjectorProcessor;
app=InjectorUI;
app2=Emergency;
 
pro.App=app;
pro.InjectorDB=db;

app.InjectorProcessor=pro;

app2.InjectorProcessor=pro;

db.processor=pro;