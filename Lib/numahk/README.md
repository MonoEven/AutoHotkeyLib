# 库名称：Numahk

---

## 目录

1. 库简介
2. 库使用方法
3. 库依赖
4. 库结构
5. 关于作者
6. 更新日志（已更新至1.0.0）

---

## 库简介
### 库定位
总结起来就是AutoHotkey版本的Numpy
### 库特点
纯AutoHotkey实现，在不完全考虑性能优化的情况下，尽可能实现功能
### 版本信息
2022.11.02 发布1.0.0版本

---

## 库使用方法
除运算、比较外，与Numpy基本一致

## 库依赖
Numahk -> xa | data | ahktype | std

## 库结构
### 抽象模型，具体结构见源代码
```
Numahk
├── NDArray                    // 主要数组定义区
│   ├── Operator                    // 运算
│   ├── Function                    // 主要函数
├── Create                    // 创建数组模块
├── Matrix                    // 矩阵函数模块
├── Sort                    // 排序函数模块
├── 1-D Calculate                    // 一维计算函数模块
├── N-D Calculate                    // N维计算函数模块
├── File                    // Numahk对象导出模块
├── Random                    // 随机模块
├── Linalg                    // 线性代数模块（未实现）
├── Range                    // Range迭代器
├── TimeStamp                    // 时间戳模块
```

---

## 关于作者
Mono，另名MonoEven，在AutoHotkey v2研究上有较深理解

---

## 更新日志
### 已更新至1.0.0
1. 更新了README.md
2. 基本实现Numpy for AutoHotkey的常用功能