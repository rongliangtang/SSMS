# SSMS
javaweb课设-学生个人成绩管理系统
idea+tomcat9+mysql8
UI用bootstrap、jquery、growl
javaweb用了jsp、servlet、javabean、filter

数据库建表语句如下
```
create database javaweb;
use javaweb;
show databases;
show tables;

CREATE TABLE `user` (
	`username` varchar(32) NOT NULL,
	`password` varchar(32) NOT NULL,
	PRIMARY KEY (`username`)
);

CREATE TABLE `score` (
    `classname` varchar(32) NOT NULL,
    `score` varchar(32) NOT NULL,	
    `username` varchar(32) NOT NULL,
    `creatime` timestamp DEFAULT CURRENT_TIMESTAMP,
    constraint score PRIMARY KEY (`classname`,`username`),
    FOREIGN KEY(`username`) REFERENCES `user`(`username`)
);

insert into user values ('admin','123456');
insert into user values ('test','123456');

insert into score (`classname`,`score`,`username`) values ('javaweb','100','admin');
insert into score (`classname`,`score`,`username`) values ('java','100','admin');
insert into score (`classname`,`score`,`username`) values ('汇编','100','admin');

```
