%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML110
% Project Title: Implementation of DBSCAN Clustering in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%
%//上面的代码又应该是加载程序，这里不做过多解释
clc;                    %//清理命令行的意思
clear;                  %//清楚存储空间的变量,以免对下面的程序运行产生影响
close all;              %//关闭所有图形窗口
 
%% Load Data            //定义data.mat数据文件加载模块
 
data=load('..\SimPDW\mydata');    %//数据读取
X = data.mydata;
%X=data.X;
 
 
%% Run DBSCAN Clustering Algorithm    //定义Run运行模块
 
epsilon=3;    %欧式距离0.5                      %//规定两个关键参数的取值
MinPts=3;      %点数10个
IDX=DBSCAN(X,epsilon,MinPts);         %//传入参数运行
 
 
%% Plot Results                       //定义绘图结果模块
 
PlotClusterinResult(X, IDX);          %//传入参数，绘制图像
title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);

