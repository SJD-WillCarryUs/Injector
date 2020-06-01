close all
clear all 
db=InjectorDB;
pro=InjectorProcessor;
app=InjectorUI;
 
pro.App=app;
pro.InjectorDB=db;

app.InjectorProcessor=pro;

db.processor=pro;