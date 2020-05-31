# Exercise Day 1

## RESTful API

1. 更新一条记录（资源），可以采用以下哪个HTTP Verb？
    A.  GET
    B.  PUT
    C.  PATCH
    D.  DELETE
    E.  POST

2.  请使用POSTMAN发起一条请求，返回People entity的第5到第10条记录，并只返回UserName字段
http://services.odata.org/V4/TripPinService/People

3.  请用POSTMAN更新russellwhyte的LastName，并解释eTag的含义
https://services.odata.org/V4/(S(yvc2cxwa0sy2emyeiqucejzf))/TripPinServiceRW/People('russellwhyte')


## NodeJS and NPM

4.  下面关于NodeJS和npm描述正确的是？
    A.  NodeJS 是用来开发前端页面的javascript语言
    B.  NodeJS 是采用chrome V8 引擎
    C.  npm 是开发后端程序的javascript语言
    D.  npm 是nodejs的包管理器

5.  解释npm config set @sap:registry=https://npm.sap.com 和 npm i -g @sap/cds-dk 这两条命令

## CAP

6.  cds init 之后会创建出什么目录和文件？
    A.  srv 目录
    B.  db 目录
    C.  package.json
    D.  node_modules目录
解释convention over configuration
解释package.json和node_modules目录

7.  更改hello world 项目，增加一个新的函数add：当传入两个整数时，返回这两个整数之和。将更新的代码同步到github代码仓库

