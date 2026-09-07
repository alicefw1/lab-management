-- ============================================================
-- 实验室设备管理系统 一键初始化脚本
-- 由 CSV 真实数据集 (d:/web/database/datas) 自动生成
-- 执行方式：mysql -u root -p < lab_equipment_init.sql
-- ============================================================
SET NAMES utf8mb4;
DROP DATABASE IF EXISTS lab_equipment;
CREATE DATABASE lab_equipment DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lab_equipment;

CREATE TABLE role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    role_code VARCHAR(50) NOT NULL UNIQUE,
    role_name VARCHAR(50) NOT NULL
) COMMENT='role table';

CREATE TABLE `user` (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    real_name VARCHAR(50),
    phone VARCHAR(30),
    email VARCHAR(100),
    role_id BIGINT NOT NULL,
    status TINYINT DEFAULT 1 COMMENT '1 enabled, 0 disabled',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES role(id)
) COMMENT='user table';

CREATE TABLE device_category (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT='device category table';

CREATE TABLE device (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_id BIGINT,
    device_no VARCHAR(100) NOT NULL UNIQUE,
    device_name VARCHAR(100) NOT NULL,
    model VARCHAR(100),
    location VARCHAR(100),
    status TINYINT DEFAULT 1 COMMENT '1 available, 2 borrowed, 3 repairing, 4 disabled',
    purchase_date DATE,
    description VARCHAR(255),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES device_category(id)
) COMMENT='device table';

CREATE TABLE borrow_apply (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    device_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    apply_reason VARCHAR(255),
    expected_return_time DATETIME NOT NULL,
    apply_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TINYINT DEFAULT 0 COMMENT '0 pending, 1 approved, 2 rejected',
    approve_user_id BIGINT,
    approve_time DATETIME,
    approve_remark VARCHAR(255),
    FOREIGN KEY (device_id) REFERENCES device(id),
    FOREIGN KEY (user_id) REFERENCES `user`(id),
    FOREIGN KEY (approve_user_id) REFERENCES `user`(id)
) COMMENT='borrow application table';

CREATE TABLE borrow_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    apply_id BIGINT NOT NULL,
    device_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    borrow_time DATETIME,
    return_time DATETIME,
    status TINYINT DEFAULT 1 COMMENT '1 borrowing, 2 returned, 3 overdue',
    remark VARCHAR(255),
    FOREIGN KEY (apply_id) REFERENCES borrow_apply(id),
    FOREIGN KEY (device_id) REFERENCES device(id),
    FOREIGN KEY (user_id) REFERENCES `user`(id)
) COMMENT='borrow record table';

CREATE TABLE repair_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    device_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    fault_desc VARCHAR(500) NOT NULL,
    repair_status TINYINT DEFAULT 0 COMMENT '0 pending, 1 processing, 2 finished',
    repair_result VARCHAR(500),
    report_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    finish_time DATETIME,
    FOREIGN KEY (device_id) REFERENCES device(id),
    FOREIGN KEY (user_id) REFERENCES `user`(id)
) COMMENT='repair record table';

CREATE TABLE notice (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    publish_user_id BIGINT,
    publish_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TINYINT DEFAULT 1 COMMENT '1 published, 0 hidden',
    FOREIGN KEY (publish_user_id) REFERENCES `user`(id)
) COMMENT='notice table';

-- ---------- role ----------
INSERT INTO `role` (`id`, `role_code`, `role_name`) VALUES (1, 'STUDENT', '学生');
INSERT INTO `role` (`id`, `role_code`, `role_name`) VALUES (2, 'LAB_ADMIN', '实验员');
INSERT INTO `role` (`id`, `role_code`, `role_name`) VALUES (3, 'ADMIN', '管理员');
INSERT INTO `role` (`id`, `role_code`, `role_name`) VALUES (4, 'TEACHER', '教师');
INSERT INTO `role` (`id`, `role_code`, `role_name`) VALUES (5, 'DEPARTMENT_HEAD', '系主任');

-- ---------- user ----------
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (1, 'student001', '123456', '李明', '13800000001', 'liming@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (2, 'student002', '123456', '王红', '13800000002', 'wanghong@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (3, 'student003', '123456', '张强', '13800000003', 'zhangqiang@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (4, 'student004', '123456', '刘丽', '13800000004', 'liuli@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (5, 'student005', '123456', '陈晨', '13800000005', 'chenchen@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (6, 'student006', '123456', '赵磊', '13800000006', 'zhaolei@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (7, 'student007', '123456', '周婷', '13800000007', 'zhouting@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (8, 'student008', '123456', '吴迪', '13800000008', 'wudi@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (9, 'student009', '123456', '郑爽', '13800000009', 'zhengshuang@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (10, 'student010', '123456', '孙阳', '13800000010', 'sunyang@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (11, 'student011', '123456', '林欣', '13800000011', 'linxin@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (12, 'student012', '123456', '郭峰', '13800000012', 'guofeng@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (13, 'student013', '123456', '唐雅', '13800000013', 'tangya@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (14, 'student014', '123456', '沈浩', '13800000014', 'shenhao@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (15, 'student015', '123456', '宋阳', '13800000015', 'songyang@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (16, 'student016', '123456', '韩梅', '13800000016', 'hanmei@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (17, 'student017', '123456', '彭博', '13800000017', 'pengbo@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (18, 'student018', '123456', '陆瑶', '13800000018', 'luyao@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (19, 'student019', '123456', '苏哲', '13800000019', 'suzhe@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (20, 'student020', '123456', '蔡琴', '13800000020', 'caiqin@school.com', 1, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (21, 'teacher001', '123456', '王建国', '13900000001', 'wangjg@school.com', 4, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (22, 'teacher002', '123456', '李芳', '13900000002', 'lifang@school.com', 4, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (23, 'teacher003', '123456', '张明远', '13900000003', 'zhangmy@school.com', 4, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (24, 'teacher004', '123456', '刘德华', '13900000004', 'liudh@school.com', 4, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (25, 'teacher005', '123456', '陈思思', '13900000005', 'chenss@school.com', 4, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (26, 'teacher006', '123456', '赵本山', '13900000006', 'zhaobs@school.com', 4, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (27, 'teacher007', '123456', '周杰伦', '13900000007', 'zhoujl@school.com', 4, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (28, 'teacher008', '123456', '吴彦祖', '13900000008', 'wu yz@school.com', 4, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (29, 'teacher009', '123456', '郑伊健', '13900000009', 'zhengyj@school.com', 4, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (30, 'teacher010', '123456', '孙俪', '13900000010', 'sunli@school.com', 4, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (31, 'lab001', '123456', '张工', '13700000001', 'zhanggong@lab.com', 2, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (32, 'lab002', '123456', '李工', '13700000002', 'ligong@lab.com', 2, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (33, 'lab003', '123456', '王工', '13700000003', 'wanggong@lab.com', 2, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (34, 'lab004', '123456', '赵工', '13700000004', 'zhaogong@lab.com', 2, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (35, 'lab005', '123456', '刘工', '13700000005', 'liugong@lab.com', 2, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (36, 'admin001', '123456', '超级管理员', '13600000001', 'admin@lab.com', 3, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (37, 'dept001', '123456', '张院长', '13500000001', 'zhangdean@school.com', 5, 1, '2026-05-04 23:09:09');
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `create_time`) VALUES (38, 'dept002', '123456', '李院长', '13500000002', 'lidean@school.com', 5, 1, '2026-05-04 23:09:09');

-- ---------- device_category ----------
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (1, '示波器类', '数字/模拟示波器，用于信号测量', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (2, '万用表类', '数字万用表，电压电流电阻测量', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (3, '信号源类', '函数信号发生器、任意波形发生器', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (4, '电源类', '直流稳压电源、可编程电源', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (5, '计算机类', '台式机、笔记本、工作站', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (6, '网络设备类', '路由器、交换机、服务器', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (7, '投影设备类', '投影仪、幕布、音响', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (8, '测量仪器类', '电子天平、温湿度计、噪声仪', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (9, '通信设备类', '频谱仪、网络分析仪', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (10, '实验平台类', '开发板、实验箱、套件', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (11, '存储设备类', '硬盘、U盘、NAS', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device_category` (`id`, `category_name`, `description`, `create_time`, `update_time`) VALUES (12, '外设类', '键盘、鼠标、显示器', '2026-05-04 23:09:09', '2026-05-04 23:09:09');

-- ---------- device ----------
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (1, 'DSO-001', '数字示波器', 1, 'Rigol DS1054Z', 'A-101', '2023-01-15', 2, '50MHz 4通道', '2026-05-04 23:09:09', '2026-05-04 23:10:35');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (2, 'DSO-002', '数字示波器', 1, 'Rigol DS1054Z', 'A-101', '2023-01-15', 2, '50MHz 4通道', '2026-05-04 23:09:09', '2026-05-04 23:10:35');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (3, 'DSO-003', '数字示波器', 1, 'Rigol DS1054Z', 'A-101', '2023-01-15', 2, '50MHz 4通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (4, 'DSO-004', '数字示波器', 1, 'Rigol DS1054Z', 'A-101', '2023-01-15', 2, '50MHz 4通道', '2026-05-04 23:09:09', '2026-05-04 23:10:35');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (5, 'DSO-005', '数字示波器', 1, 'Rigol DS1054Z', 'A-101', '2023-01-15', 3, '50MHz 4通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (6, 'DSO-006', '数字示波器', 1, 'Tektronix TBS1102C', 'A-102', '2023-03-20', 1, '100MHz 2通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (7, 'DSO-007', '数字示波器', 1, 'Tektronix TBS1102C', 'A-102', '2023-03-20', 1, '100MHz 2通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (8, 'DSO-008', '数字示波器', 1, 'Tektronix TBS1102C', 'A-102', '2023-03-20', 2, '100MHz 2通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (9, 'DSO-009', '手持示波器', 1, 'Fluke 123B', 'A-103', '2023-05-10', 1, '便携式', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (10, 'DSO-010', '手持示波器', 1, 'Fluke 123B', 'A-103', '2023-05-10', 4, '便携式-待报废', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (11, 'DMM-001', '数字万用表', 2, 'Fluke 17B+', 'A-201', '2023-02-01', 1, '高精度', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (12, 'DMM-002', '数字万用表', 2, 'Fluke 17B+', 'A-201', '2023-02-01', 1, '高精度', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (13, 'DMM-003', '数字万用表', 2, 'Fluke 17B+', 'A-201', '2023-02-01', 2, '高精度', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (14, 'DMM-004', '数字万用表', 2, 'Fluke 17B+', 'A-201', '2023-02-01', 1, '高精度', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (15, 'DMM-005', '数字万用表', 2, 'Fluke 17B+', 'A-201', '2023-02-01', 3, '高精度-维修', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (16, 'DMM-006', '数字万用表', 2, 'UNI-T UT61E', 'A-202', '2023-04-15', 1, '高精度', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (17, 'DMM-007', '数字万用表', 2, 'UNI-T UT61E', 'A-202', '2023-04-15', 1, '高精度', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (18, 'DMM-008', '数字万用表', 2, 'UNI-T UT61E', 'A-202', '2023-04-15', 2, '高精度', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (19, 'DMM-009', '台式万用表', 2, 'Rigol DM3068', 'A-203', '2023-06-01', 1, '6位半', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (20, 'DMM-010', '台式万用表', 2, 'Rigol DM3068', 'A-203', '2023-06-01', 1, '6位半', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (21, 'SG-001', '函数信号发生器', 3, 'Rigol DG1022Z', 'B-101', '2023-02-10', 1, '双通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (22, 'SG-002', '函数信号发生器', 3, 'Rigol DG1022Z', 'B-101', '2023-02-10', 1, '双通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (23, 'SG-003', '函数信号发生器', 3, 'Rigol DG1022Z', 'B-101', '2023-02-10', 2, '双通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (24, 'SG-004', '函数信号发生器', 3, 'Siglent SDG1032X', 'B-102', '2023-05-20', 1, '30MHz', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (25, 'SG-005', '函数信号发生器', 3, 'Siglent SDG1032X', 'B-102', '2023-05-20', 1, '30MHz', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (26, 'SG-006', '射频信号源', 3, 'Siglent SSG3021X', 'B-103', '2023-08-01', 1, '3.2GHz', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (27, 'SG-007', '射频信号源', 3, 'Siglent SSG3021X', 'B-103', '2023-08-01', 3, '3.2GHz-维修', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (28, 'SG-008', '任意波形发生器', 3, 'Tektronix AFG1022', 'B-104', '2023-09-15', 1, '25MHz', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (29, 'SG-009', '任意波形发生器', 3, 'Tektronix AFG1022', 'B-104', '2023-09-15', 1, '25MHz', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (30, 'SG-010', '任意波形发生器', 3, 'Tektronix AFG1022', 'B-104', '2023-09-15', 2, '25MHz', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (31, 'PS-001', '直流稳压电源', 4, 'Rigol DP832', 'C-101', '2023-03-01', 1, '三通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (32, 'PS-002', '直流稳压电源', 4, 'Rigol DP832', 'C-101', '2023-03-01', 1, '三通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (33, 'PS-003', '直流稳压电源', 4, 'Rigol DP832', 'C-101', '2023-03-01', 2, '三通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (34, 'PS-004', '直流稳压电源', 4, 'ATTEN APS3005S', 'C-102', '2023-04-10', 1, '单通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (35, 'PS-005', '直流稳压电源', 4, 'ATTEN APS3005S', 'C-102', '2023-04-10', 1, '单通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (36, 'PS-006', '直流稳压电源', 4, 'ATTEN APS3005S', 'C-102', '2023-04-10', 1, '单通道', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (37, 'PS-007', '可编程电源', 4, 'ITECH IT6720', 'C-103', '2023-07-01', 1, '60V/5A', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (38, 'PS-008', '可编程电源', 4, 'ITECH IT6720', 'C-103', '2023-07-01', 4, '60V/5A-报废', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (39, 'PS-009', '可编程电源', 4, 'ITECH IT6721', 'C-103', '2023-07-01', 1, '60V/8A', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (40, 'PS-010', '可编程电源', 4, 'ITECH IT6721', 'C-103', '2023-07-01', 2, '60V/8A', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (41, 'PC-001', '台式计算机', 5, 'Lenovo M950t', 'D-101', '2023-01-10', 1, 'i7/16G/512G', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (42, 'PC-002', '台式计算机', 5, 'Lenovo M950t', 'D-101', '2023-01-10', 1, 'i7/16G/512G', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (43, 'PC-003', '台式计算机', 5, 'Lenovo M950t', 'D-101', '2023-01-10', 2, 'i7/16G/512G', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (44, 'PC-004', '台式计算机', 5, 'Lenovo M950t', 'D-101', '2023-01-10', 1, 'i7/16G/512G', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (45, 'PC-005', '台式计算机', 5, 'Lenovo M950t', 'D-101', '2023-01-10', 3, 'i7/16G/512G', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (46, 'PC-006', '笔记本电脑', 5, 'ThinkPad X1 Carbon', 'D-102', '2023-06-15', 1, 'i7/16G/1T', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (47, 'PC-007', '笔记本电脑', 5, 'ThinkPad X1 Carbon', 'D-102', '2023-06-15', 2, 'i7/16G/1T', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (48, 'PC-008', '笔记本电脑', 5, 'MacBook Pro', 'D-102', '2023-09-20', 1, 'M2/16G/512G', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (49, 'PC-009', '工作站', 5, 'Dell Precision 3660', 'D-103', '2023-11-01', 1, 'i9/32G/1T', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (50, 'PC-010', '工作站', 5, 'Dell Precision 3660', 'D-103', '2023-11-01', 1, 'i9/32G/1T', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (51, 'NW-001', '千兆交换机', 6, 'Huawei S5735S', 'E-101', '2023-04-01', 1, '48口', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (52, 'NW-002', '千兆交换机', 6, 'Huawei S5735S', 'E-101', '2023-04-01', 1, '48口', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (53, 'NW-003', '千兆交换机', 6, 'Huawei S5735S', 'E-101', '2023-04-01', 2, '48口', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (54, 'NW-004', '路由器', 6, 'Cisco ISR 4321', 'E-102', '2023-05-10', 1, '企业级', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (55, 'NW-005', '路由器', 6, 'Cisco ISR 4321', 'E-102', '2023-05-10', 1, '企业级', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (56, 'NW-006', '服务器', 6, 'Dell PowerEdge R750', 'E-103', '2023-07-01', 1, '机架式', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (57, 'NW-007', '服务器', 6, 'Dell PowerEdge R750', 'E-103', '2023-07-01', 2, '机架式', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (58, 'NW-008', '防火墙', 6, 'Huawei USG6300', 'E-104', '2023-08-15', 1, '企业级', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (59, 'NW-009', '无线AP', 6, 'Huawei AP7060DN', 'E-105', '2023-09-01', 1, 'WiFi6', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (60, 'NW-010', '无线AP', 6, 'Huawei AP7060DN', 'E-105', '2023-09-01', 3, 'WiFi6-维修', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (61, 'PJ-001', '投影仪', 7, 'Epson CB-695Wi', 'F-101', '2023-02-15', 1, '互动式', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (62, 'PJ-002', '投影仪', 7, 'Epson CB-695Wi', 'F-101', '2023-02-15', 2, '互动式', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (63, 'PJ-003', '投影仪', 7, 'BenQ MH733', 'F-102', '2023-05-20', 1, '4000流明', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (64, 'PJ-004', '投影仪', 7, 'BenQ MH733', 'F-102', '2023-05-20', 1, '4000流明', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (65, 'PJ-005', '激光投影', 7, 'Sony VPL-P501HZ', 'F-103', '2023-08-10', 1, '激光光源', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (66, 'PJ-006', '激光投影', 7, 'Sony VPL-P501HZ', 'F-103', '2023-08-10', 3, '激光光源-维修', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (67, 'PJ-007', '音响系统', 7, 'JBL KES8120', 'F-201', '2023-09-01', 1, '专业音响', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (68, 'PJ-008', '音响系统', 7, 'JBL KES8120', 'F-201', '2023-09-01', 1, '专业音响', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (69, 'PJ-009', '投影幕布', 7, '红叶120寸', 'F-202', '2023-03-01', 1, '电动', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (70, 'PJ-010', '投影幕布', 7, '红叶120寸', 'F-202', '2023-03-01', 2, '电动', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (71, 'MI-001', '电子天平', 8, 'Sartorius BSA224S', 'G-101', '2023-04-01', 1, '220g/0.1mg', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (72, 'MI-002', '电子天平', 8, 'Sartorius BSA224S', 'G-101', '2023-04-01', 2, '220g/0.1mg', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (73, 'MI-003', '温湿度计', 8, 'Testo 608-H1', 'G-102', '2023-06-01', 1, '实验室用', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (74, 'MI-004', '噪声计', 8, 'CEM DT-8850', 'G-102', '2023-06-01', 1, '30-130dB', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (75, 'MI-005', 'pH计', 8, 'Mettler Toledo FE28', 'G-103', '2023-07-01', 4, 'pH计-报废', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (76, 'CM-001', '频谱分析仪', 9, 'Rigol RSA3030N', 'H-101', '2023-09-01', 1, '3.2GHz', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (77, 'CM-002', '频谱分析仪', 9, 'Rigol RSA3030N', 'H-101', '2023-09-01', 2, '3.2GHz', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (78, 'CM-003', '网络分析仪', 9, 'Siglent SNA5032A', 'H-102', '2023-10-01', 1, '3.2GHz', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (79, 'EP-001', 'FPGA开发板', 10, 'Xilinx Artix-7', 'I-101', '2023-05-01', 1, 'FPGA开发套件', '2026-05-04 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `device` (`id`, `device_no`, `device_name`, `category_id`, `model`, `location`, `purchase_date`, `status`, `description`, `create_time`, `update_time`) VALUES (80, 'EP-002', '单片机实验箱', 10, 'STC15实验箱', 'I-102', '2023-06-01', 2, '单片机教学', '2026-05-04 23:09:09', '2026-05-04 23:09:09');

-- ---------- borrow_apply ----------
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (1, 30, 1, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-12 23:09:09', 1, NULL, '2026-04-25 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (2, 29, 1, '科研课题研究', '2026-05-04 23:09:09', '2026-05-05 23:09:09', 1, NULL, '2026-05-01 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (3, 28, 1, '设备测试验证', '2026-05-04 23:09:09', '2026-05-06 23:09:09', 0, 1, '2026-05-02 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (4, 27, 1, '课程实验需要', '2026-05-04 23:09:09', '2026-05-17 23:09:09', 2, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (5, 26, 1, '社团活动使用', '2026-05-04 23:09:09', '2026-05-10 23:09:09', 2, 1, '2026-04-27 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (6, 25, 1, '课程实验需要', '2026-05-04 23:09:09', '2026-05-11 23:09:09', 2, NULL, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (7, 24, 1, '科研课题研究', '2026-05-04 23:09:09', '2026-05-29 23:09:09', 2, NULL, '2026-05-02 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (8, 23, 1, '科研课题研究', '2026-05-04 23:09:09', '2026-05-24 23:09:09', 2, 1, '2026-05-02 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (9, 22, 1, '科研课题研究', '2026-05-04 23:09:09', '2026-05-31 23:09:09', 2, 1, '2026-04-26 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (10, 21, 1, '设备测试验证', '2026-05-04 23:09:09', '2026-05-17 23:09:09', 1, 1, '2026-04-29 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (11, 20, 1, '设备测试验证', '2026-05-04 23:09:09', '2026-05-15 23:09:09', 1, 1, '2026-05-01 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (12, 19, 1, '设备测试验证', '2026-05-04 23:09:09', '2026-05-31 23:09:09', 0, 1, '2026-04-30 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (13, 18, 1, '社团活动使用', '2026-05-04 23:09:09', '2026-05-29 23:09:09', 0, 1, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (14, 17, 1, '科研课题研究', '2026-05-04 23:09:09', '2026-05-13 23:09:09', 1, 1, '2026-04-26 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (15, 16, 1, '设备测试验证', '2026-05-04 23:09:09', '2026-05-19 23:09:09', 2, NULL, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (16, 15, 1, '社团活动使用', '2026-05-04 23:09:09', '2026-05-07 23:09:09', 2, NULL, '2026-04-27 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (17, 14, 1, '科研课题研究', '2026-05-04 23:09:09', '2026-05-26 23:09:09', 0, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (18, 13, 1, '科研课题研究', '2026-05-04 23:09:09', '2026-05-26 23:09:09', 1, NULL, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (19, 12, 1, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-28 23:09:09', 1, 1, '2026-04-27 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (20, 11, 1, '社团活动使用', '2026-05-04 23:09:09', '2026-05-19 23:09:09', 1, NULL, '2026-04-29 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (21, 10, 1, '社团活动使用', '2026-05-04 23:09:09', '2026-05-24 23:09:09', 0, NULL, '2026-05-03 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (22, 9, 1, '社团活动使用', '2026-05-04 23:09:09', '2026-05-26 23:09:09', 1, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (23, 8, 1, '课程实验需要', '2026-05-04 23:09:09', '2026-06-01 23:09:09', 0, NULL, '2026-04-30 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (24, 7, 1, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-31 23:09:09', 1, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (25, 6, 1, '科研课题研究', '2026-05-04 23:09:09', '2026-05-28 23:09:09', 2, NULL, '2026-04-26 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (26, 5, 1, '设备测试验证', '2026-05-04 23:09:09', '2026-05-23 23:09:09', 1, 1, '2026-04-30 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (27, 4, 1, '设备测试验证', '2026-05-04 23:09:09', '2026-05-20 23:09:09', 0, 1, '2026-04-25 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (28, 3, 1, '设备测试验证', '2026-05-04 23:09:09', '2026-05-15 23:09:09', 1, NULL, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (29, 2, 1, '科研课题研究', '2026-05-04 23:09:09', '2026-05-24 23:09:09', 2, 1, '2026-04-29 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (30, 1, 1, '设备测试验证', '2026-05-04 23:09:09', '2026-05-23 23:09:09', 2, 1, '2026-04-29 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (31, 30, 2, '科研课题研究', '2026-05-04 23:09:09', '2026-05-25 23:09:09', 1, 1, '2026-04-26 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (32, 29, 2, '设备测试验证', '2026-05-04 23:09:09', '2026-05-11 23:09:09', 2, 1, '2026-04-29 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (33, 28, 2, '社团活动使用', '2026-05-04 23:09:09', '2026-05-14 23:09:09', 2, 1, '2026-04-26 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (34, 27, 2, '课程实验需要', '2026-05-04 23:09:09', '2026-05-07 23:09:09', 0, 1, '2026-05-01 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (35, 26, 2, '科研课题研究', '2026-05-04 23:09:09', '2026-05-15 23:09:09', 1, 1, '2026-05-01 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (36, 25, 2, '设备测试验证', '2026-05-04 23:09:09', '2026-05-18 23:09:09', 1, 1, '2026-04-26 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (37, 24, 2, '课程实验需要', '2026-05-04 23:09:09', '2026-05-07 23:09:09', 2, 1, '2026-04-25 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (38, 23, 2, '课程实验需要', '2026-05-04 23:09:09', '2026-05-11 23:09:09', 2, NULL, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (39, 22, 2, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-16 23:09:09', 0, 1, '2026-04-25 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (40, 21, 2, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-20 23:09:09', 1, 1, '2026-04-28 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (41, 20, 2, '设备测试验证', '2026-05-04 23:09:09', '2026-05-10 23:09:09', 1, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (42, 19, 2, '社团活动使用', '2026-05-04 23:09:09', '2026-05-06 23:09:09', 0, NULL, '2026-05-01 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (43, 18, 2, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-25 23:09:09', 2, 1, '2026-05-02 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (44, 17, 2, '课程实验需要', '2026-05-04 23:09:09', '2026-05-24 23:09:09', 1, NULL, '2026-04-27 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (45, 16, 2, '设备测试验证', '2026-05-04 23:09:09', '2026-05-21 23:09:09', 0, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (46, 15, 2, '科研课题研究', '2026-05-04 23:09:09', '2026-05-22 23:09:09', 2, 1, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (47, 14, 2, '科研课题研究', '2026-05-04 23:09:09', '2026-05-15 23:09:09', 0, NULL, '2026-05-02 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (48, 13, 2, '课程实验需要', '2026-05-04 23:09:09', '2026-05-20 23:09:09', 1, 1, '2026-04-29 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (49, 12, 2, '设备测试验证', '2026-05-04 23:09:09', '2026-05-26 23:09:09', 0, 1, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (50, 11, 2, '设备测试验证', '2026-05-04 23:09:09', '2026-05-14 23:09:09', 2, 1, '2026-05-03 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (51, 10, 2, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-12 23:09:09', 1, NULL, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (52, 9, 2, '设备测试验证', '2026-05-04 23:09:09', '2026-05-30 23:09:09', 2, 1, '2026-04-25 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (53, 8, 2, '课程实验需要', '2026-05-04 23:09:09', '2026-06-02 23:09:09', 1, 1, '2026-04-26 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (54, 7, 2, '社团活动使用', '2026-05-04 23:09:09', '2026-05-25 23:09:09', 0, 1, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (55, 6, 2, '设备测试验证', '2026-05-04 23:09:09', '2026-05-13 23:09:09', 0, NULL, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (56, 5, 2, '毕业设计项目', '2026-05-04 23:09:09', '2026-06-01 23:09:09', 0, 1, '2026-04-25 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (57, 4, 2, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-10 23:09:09', 0, NULL, '2026-05-03 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (58, 3, 2, '课程实验需要', '2026-05-04 23:09:09', '2026-05-04 23:09:09', 1, 1, '2026-05-01 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (59, 2, 2, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-07 23:09:09', 2, 1, '2026-04-29 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (60, 1, 2, '设备测试验证', '2026-05-04 23:09:09', '2026-06-01 23:09:09', 0, NULL, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (61, 30, 3, '设备测试验证', '2026-05-04 23:09:09', '2026-05-19 23:09:09', 2, NULL, '2026-04-29 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (62, 29, 3, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-23 23:09:09', 0, NULL, '2026-04-28 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (63, 28, 3, '科研课题研究', '2026-05-04 23:09:09', '2026-05-29 23:09:09', 2, NULL, '2026-04-28 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (64, 27, 3, '科研课题研究', '2026-05-04 23:09:09', '2026-05-28 23:09:09', 2, 1, '2026-04-27 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (65, 26, 3, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-21 23:09:09', 0, 1, '2026-05-02 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (66, 25, 3, '科研课题研究', '2026-05-04 23:09:09', '2026-05-18 23:09:09', 2, 1, '2026-05-03 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (67, 24, 3, '社团活动使用', '2026-05-04 23:09:09', '2026-05-14 23:09:09', 1, NULL, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (68, 23, 3, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-06 23:09:09', 1, NULL, '2026-04-29 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (69, 22, 3, '科研课题研究', '2026-05-04 23:09:09', '2026-05-04 23:09:09', 1, 1, '2026-04-26 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (70, 21, 3, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-25 23:09:09', 2, 1, '2026-05-01 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (71, 20, 3, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-05 23:09:09', 2, NULL, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (72, 19, 3, '设备测试验证', '2026-05-04 23:09:09', '2026-05-09 23:09:09', 2, NULL, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (73, 18, 3, '科研课题研究', '2026-05-04 23:09:09', '2026-05-24 23:09:09', 2, NULL, '2026-05-04 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (74, 17, 3, '社团活动使用', '2026-05-04 23:09:09', '2026-05-06 23:09:09', 1, 1, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (75, 16, 3, '设备测试验证', '2026-05-04 23:09:09', '2026-05-28 23:09:09', 0, NULL, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (76, 15, 3, '社团活动使用', '2026-05-04 23:09:09', '2026-05-08 23:09:09', 2, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (77, 14, 3, '社团活动使用', '2026-05-04 23:09:09', '2026-05-15 23:09:09', 0, 1, '2026-04-30 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (78, 13, 3, '社团活动使用', '2026-05-04 23:09:09', '2026-05-30 23:09:09', 1, 1, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (79, 12, 3, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-19 23:09:09', 2, 1, '2026-05-01 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (80, 11, 3, '社团活动使用', '2026-05-04 23:09:09', '2026-05-25 23:09:09', 1, 1, '2026-04-30 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (81, 10, 3, '设备测试验证', '2026-05-04 23:09:09', '2026-05-22 23:09:09', 1, 1, '2026-05-01 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (82, 9, 3, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-29 23:09:09', 1, 1, '2026-04-29 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (83, 8, 3, '科研课题研究', '2026-05-04 23:09:09', '2026-05-15 23:09:09', 1, 1, '2026-05-01 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (84, 7, 3, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-25 23:09:09', 2, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (85, 6, 3, '设备测试验证', '2026-05-04 23:09:09', '2026-05-12 23:09:09', 1, NULL, '2026-05-02 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (86, 5, 3, '设备测试验证', '2026-05-04 23:09:09', '2026-05-14 23:09:09', 0, NULL, '2026-04-29 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (87, 4, 3, '社团活动使用', '2026-05-04 23:09:09', '2026-05-31 23:09:09', 1, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (88, 3, 3, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-27 23:09:09', 0, NULL, '2026-04-28 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (89, 2, 3, '设备测试验证', '2026-05-04 23:09:09', '2026-05-16 23:09:09', 0, 1, '2026-04-30 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (90, 1, 3, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-10 23:09:09', 0, 1, '2026-04-30 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (91, 30, 4, '设备测试验证', '2026-05-04 23:09:09', '2026-05-22 23:09:09', 0, 1, '2026-04-27 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (92, 29, 4, '社团活动使用', '2026-05-04 23:09:09', '2026-05-11 23:09:09', 0, 1, '2026-04-27 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (93, 28, 4, '科研课题研究', '2026-05-04 23:09:09', '2026-05-24 23:09:09', 2, NULL, '2026-05-03 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (94, 27, 4, '社团活动使用', '2026-05-04 23:09:09', '2026-05-20 23:09:09', 1, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (95, 26, 4, '设备测试验证', '2026-05-04 23:09:09', '2026-05-23 23:09:09', 1, 1, '2026-05-04 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (96, 25, 4, '设备测试验证', '2026-05-04 23:09:09', '2026-05-04 23:09:09', 1, NULL, '2026-04-30 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (97, 24, 4, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-07 23:09:09', 1, NULL, '2026-04-26 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (98, 23, 4, '课程实验需要', '2026-05-04 23:09:09', '2026-05-24 23:09:09', 2, NULL, '2026-05-04 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (99, 22, 4, '科研课题研究', '2026-05-04 23:09:09', '2026-05-10 23:09:09', 2, NULL, '2026-04-28 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (100, 21, 4, '科研课题研究', '2026-05-04 23:09:09', '2026-05-24 23:09:09', 0, 1, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (101, 20, 4, '社团活动使用', '2026-05-04 23:09:09', '2026-05-16 23:09:09', 0, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (102, 19, 4, '课程实验需要', '2026-05-04 23:09:09', '2026-05-13 23:09:09', 0, 1, '2026-05-04 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (103, 18, 4, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-14 23:09:09', 2, 1, '2026-04-27 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (104, 17, 4, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-15 23:09:09', 2, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (105, 16, 4, '课程实验需要', '2026-05-04 23:09:09', '2026-05-24 23:09:09', 0, 1, '2026-04-27 23:09:09', '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (106, 15, 4, '设备测试验证', '2026-05-04 23:09:09', '2026-05-31 23:09:09', 2, 1, '2026-04-28 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (107, 14, 4, '课程实验需要', '2026-05-04 23:09:09', '2026-05-29 23:09:09', 0, NULL, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (108, 13, 4, '课程实验需要', '2026-05-04 23:09:09', '2026-05-25 23:09:09', 1, NULL, '2026-04-30 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (109, 12, 4, '课程实验需要', '2026-05-04 23:09:09', '2026-05-10 23:09:09', 1, 1, '2026-04-30 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (110, 11, 4, '课程实验需要', '2026-05-04 23:09:09', '2026-05-06 23:09:09', 0, 1, '2026-04-28 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (111, 10, 4, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-28 23:09:09', 0, 1, '2026-04-28 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (112, 9, 4, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-19 23:09:09', 1, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (113, 8, 4, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-27 23:09:09', 0, 1, '2026-04-28 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (114, 7, 4, '社团活动使用', '2026-05-04 23:09:09', '2026-05-11 23:09:09', 2, NULL, '2026-04-26 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (115, 6, 4, '社团活动使用', '2026-05-04 23:09:09', '2026-05-04 23:09:09', 0, NULL, '2026-04-27 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (116, 5, 4, '毕业设计项目', '2026-05-04 23:09:09', '2026-05-28 23:09:09', 1, 1, '2026-05-04 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (117, 4, 4, '科研课题研究', '2026-05-04 23:09:09', '2026-05-13 23:09:09', 0, 1, '2026-04-27 23:09:09', NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (118, 3, 4, '社团活动使用', '2026-05-04 23:09:09', '2026-05-22 23:09:09', 0, 1, NULL, '请按时归还并爱护设备');
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (119, 2, 4, '社团活动使用', '2026-05-04 23:09:09', '2026-05-17 23:09:09', 0, 1, NULL, NULL);
INSERT INTO `borrow_apply` (`id`, `user_id`, `device_id`, `apply_reason`, `apply_time`, `expected_return_time`, `status`, `approve_user_id`, `approve_time`, `approve_remark`) VALUES (120, 1, 4, '课程实验需要', '2026-05-04 23:09:09', '2026-05-12 23:09:09', 2, 1, '2026-05-01 23:09:09', NULL);

-- ---------- borrow_record ----------
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (1, 1, 1, 30, '2026-05-05 23:09:09', '2026-05-06 23:09:09', 2, '借用记录34');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (2, 2, 1, 29, '2026-05-05 23:09:09', '2026-05-22 23:09:09', 1, '借用记录97');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (3, 10, 1, 21, '2026-05-05 23:09:09', NULL, 1, '借用记录70');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (4, 11, 1, 20, '2026-05-04 23:09:09', '2026-05-21 23:09:09', 2, '借用记录66');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (5, 14, 1, 17, '2026-05-06 23:09:09', NULL, 2, '借用记录14');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (6, 18, 1, 13, '2026-05-06 23:09:09', '2026-05-08 23:09:09', 1, '借用记录26');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (7, 19, 1, 12, '2026-05-06 23:09:09', NULL, 1, '借用记录37');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (8, 20, 1, 11, '2026-05-05 23:09:09', NULL, 2, '借用记录27');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (9, 22, 1, 9, '2026-05-05 23:09:09', NULL, 3, '借用记录75');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (10, 24, 1, 7, '2026-05-04 23:09:09', '2026-05-06 23:09:09', 1, '借用记录62');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (11, 26, 1, 5, '2026-05-05 23:09:09', '2026-05-23 23:09:09', 2, '借用记录84');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (12, 28, 1, 3, '2026-05-05 23:09:09', NULL, 2, '借用记录3');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (13, 31, 2, 30, '2026-05-04 23:09:09', NULL, 2, '借用记录3');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (14, 35, 2, 26, '2026-05-05 23:09:09', '2026-05-20 23:09:09', 1, '借用记录16');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (15, 36, 2, 25, '2026-05-06 23:09:09', '2026-05-12 23:09:09', 2, '借用记录82');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (16, 40, 2, 21, '2026-05-04 23:09:09', '2026-05-23 23:09:09', 1, '借用记录50');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (17, 41, 2, 20, '2026-05-06 23:09:09', '2026-05-12 23:09:09', 3, '借用记录84');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (18, 44, 2, 17, '2026-05-06 23:09:09', NULL, 2, '借用记录30');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (19, 48, 2, 13, '2026-05-05 23:09:09', NULL, 1, '借用记录60');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (20, 51, 2, 10, '2026-05-06 23:09:09', NULL, 3, '借用记录76');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (21, 53, 2, 8, '2026-05-05 23:09:09', '2026-05-18 23:09:09', 2, '借用记录71');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (22, 58, 2, 3, '2026-05-04 23:09:09', '2026-05-11 23:09:09', 2, '借用记录87');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (23, 67, 3, 24, '2026-05-05 23:09:09', NULL, 1, '借用记录1');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (24, 68, 3, 23, '2026-05-06 23:09:09', '2026-05-19 23:09:09', 2, '借用记录54');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (25, 69, 3, 22, '2026-05-04 23:09:09', '2026-05-21 23:09:09', 1, '借用记录56');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (26, 74, 3, 17, '2026-05-04 23:09:09', '2026-05-21 23:09:09', 2, '借用记录75');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (27, 78, 3, 13, '2026-05-05 23:09:09', '2026-05-22 23:09:09', 1, '借用记录36');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (28, 80, 3, 11, '2026-05-06 23:09:09', '2026-05-12 23:09:09', 2, '借用记录14');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (29, 81, 3, 10, '2026-05-05 23:09:09', NULL, 2, '借用记录23');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (30, 82, 3, 9, '2026-05-06 23:09:09', NULL, 1, '借用记录41');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (31, 83, 3, 8, '2026-05-06 23:09:09', NULL, 1, '借用记录8');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (32, 85, 3, 6, '2026-05-05 23:09:09', '2026-05-21 23:09:09', 2, '借用记录36');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (33, 87, 3, 4, '2026-05-04 23:09:09', '2026-05-06 23:09:09', 1, '借用记录41');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (34, 94, 4, 27, '2026-05-05 23:09:09', '2026-05-16 23:09:09', 1, '借用记录61');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (35, 95, 4, 26, '2026-05-06 23:09:09', NULL, 1, '借用记录84');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (36, 96, 4, 25, '2026-05-04 23:09:09', NULL, 1, '借用记录9');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (37, 97, 4, 24, '2026-05-06 23:09:09', '2026-05-18 23:09:09', 2, '借用记录25');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (38, 108, 4, 13, '2026-05-06 23:09:09', NULL, 1, '借用记录77');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (39, 109, 4, 12, '2026-05-06 23:09:09', '2026-05-21 23:09:09', 1, '借用记录27');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (40, 112, 4, 9, '2026-05-06 23:09:09', NULL, 1, '借用记录22');
INSERT INTO `borrow_record` (`id`, `apply_id`, `device_id`, `user_id`, `borrow_time`, `return_time`, `status`, `remark`) VALUES (41, 116, 4, 5, '2026-05-06 23:09:09', '2026-05-20 23:09:09', 2, '借用记录21');

-- ---------- repair_record ----------
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (1, 1, 29, '接口损坏，无法连接', 2, '维修完成，设备恢复正常', '2026-04-01 23:09:09', '2026-04-29 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (2, 1, 24, '按键失灵，无法正常操作', 1, NULL, '2026-04-18 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (3, 1, 23, '运行卡顿，系统响应慢', 2, NULL, '2026-04-13 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (4, 1, 31, '运行卡顿，系统响应慢', 0, NULL, '2026-03-28 23:09:09', '2026-04-16 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (5, 1, 18, '测量结果不准，偏差较大', 2, '维修完成，设备恢复正常', '2026-04-22 23:09:09', '2026-04-06 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (6, 1, 15, '测量结果不准，偏差较大', 2, NULL, '2026-04-20 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (7, 1, 13, '按键失灵，无法正常操作', 0, NULL, '2026-03-23 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (8, 1, 11, '按键失灵，无法正常操作', 0, '维修完成，设备恢复正常', '2026-04-07 23:09:09', '2026-04-06 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (9, 2, 29, '接口损坏，无法连接', 1, '维修完成，设备恢复正常', '2026-03-29 23:09:09', '2026-05-02 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (10, 2, 22, '无法开机，电源指示灯不亮', 0, NULL, '2026-03-18 23:09:09', '2026-04-29 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (11, 2, 17, '按键失灵，无法正常操作', 0, NULL, '2026-04-06 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (12, 2, 4, '测量结果不准，偏差较大', 2, '维修完成，设备恢复正常', '2026-04-06 23:09:09', '2026-04-25 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (13, 2, 3, '测量结果不准，偏差较大', 1, NULL, '2026-03-23 23:09:09', '2026-04-11 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (14, 2, 2, '显示异常，屏幕闪烁', 1, NULL, '2026-04-25 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (15, 3, 29, '显示异常，屏幕闪烁', 1, NULL, '2026-04-08 23:09:09', '2026-04-16 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (16, 3, 34, '显示异常，屏幕闪烁', 2, NULL, '2026-04-14 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (17, 3, 33, '按键失灵，无法正常操作', 2, NULL, '2026-04-29 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (18, 3, 18, '按键失灵，无法正常操作', 0, '维修完成，设备恢复正常', '2026-04-22 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (19, 3, 17, '无法开机，电源指示灯不亮', 2, NULL, '2026-04-09 23:09:09', '2026-04-26 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (20, 3, 16, '测量结果不准，偏差较大', 1, '维修完成，设备恢复正常', '2026-03-18 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (21, 3, 15, '无法开机，电源指示灯不亮', 2, NULL, '2026-03-29 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (22, 3, 14, '运行卡顿，系统响应慢', 1, NULL, '2026-04-03 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (23, 3, 13, '无法开机，电源指示灯不亮', 2, '维修完成，设备恢复正常', '2026-04-16 23:09:09', '2026-04-13 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (24, 3, 11, '接口损坏，无法连接', 1, '维修完成，设备恢复正常', '2026-04-29 23:09:09', '2026-04-19 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (25, 3, 10, '接口损坏，无法连接', 1, '维修完成，设备恢复正常', '2026-04-13 23:09:09', '2026-04-24 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (26, 3, 7, '按键失灵，无法正常操作', 2, '维修完成，设备恢复正常', '2026-03-29 23:09:09', '2026-04-25 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (27, 3, 6, '接口损坏，无法连接', 2, '维修完成，设备恢复正常', '2026-03-08 23:09:09', '2026-04-26 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (28, 3, 5, '运行卡顿，系统响应慢', 2, '维修完成，设备恢复正常', '2026-03-31 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (29, 4, 28, '无法开机，电源指示灯不亮', 2, '维修完成，设备恢复正常', '2026-03-16 23:09:09', '2026-04-14 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (30, 4, 24, '运行卡顿，系统响应慢', 1, '维修完成，设备恢复正常', '2026-03-14 23:09:09', '2026-04-28 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (31, 4, 11, '接口损坏，无法连接', 1, NULL, '2026-04-21 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (32, 4, 7, '运行卡顿，系统响应慢', 2, NULL, '2026-04-18 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (33, 4, 6, '运行卡顿，系统响应慢', 1, '维修完成，设备恢复正常', '2026-04-08 23:09:09', '2026-04-19 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (34, 4, 2, '运行卡顿，系统响应慢', 1, '维修完成，设备恢复正常', '2026-03-30 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (35, 5, 30, '测量结果不准，偏差较大', 1, NULL, '2026-04-23 23:09:09', '2026-04-06 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (36, 5, 25, '按键失灵，无法正常操作', 2, NULL, '2026-03-12 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (37, 5, 22, '显示异常，屏幕闪烁', 0, NULL, '2026-03-29 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (38, 5, 34, '显示异常，屏幕闪烁', 1, NULL, '2026-04-01 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (39, 5, 31, '测量结果不准，偏差较大', 2, NULL, '2026-04-03 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (40, 5, 19, '接口损坏，无法连接', 0, NULL, '2026-04-17 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (41, 5, 12, '按键失灵，无法正常操作', 2, '维修完成，设备恢复正常', '2026-04-14 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (42, 5, 10, '按键失灵，无法正常操作', 2, NULL, '2026-04-05 23:09:09', '2026-04-29 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (43, 5, 8, '无法开机，电源指示灯不亮', 0, '维修完成，设备恢复正常', '2026-05-04 23:09:09', '2026-05-01 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (44, 5, 5, '显示异常，屏幕闪烁', 1, '维修完成，设备恢复正常', '2026-04-23 23:09:09', '2026-04-07 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (45, 5, 3, '显示异常，屏幕闪烁', 2, '维修完成，设备恢复正常', '2026-04-09 23:09:09', '2026-04-05 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (46, 6, 29, '测量结果不准，偏差较大', 0, NULL, '2026-03-23 23:09:09', '2026-04-18 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (47, 6, 19, '测量结果不准，偏差较大', 1, NULL, '2026-03-12 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (48, 6, 18, '测量结果不准，偏差较大', 2, NULL, '2026-03-14 23:09:09', '2026-04-28 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (49, 6, 11, '接口损坏，无法连接', 1, '维修完成，设备恢复正常', '2026-04-19 23:09:09', '2026-04-25 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (50, 7, 26, '显示异常，屏幕闪烁', 0, '维修完成，设备恢复正常', '2026-03-18 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (51, 7, 33, '运行卡顿，系统响应慢', 0, '维修完成，设备恢复正常', '2026-03-17 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (52, 7, 14, '接口损坏，无法连接', 0, NULL, '2026-04-18 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (53, 7, 13, '显示异常，屏幕闪烁', 0, '维修完成，设备恢复正常', '2026-03-26 23:09:09', '2026-04-14 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (54, 7, 12, '运行卡顿，系统响应慢', 1, NULL, '2026-03-19 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (55, 7, 11, '显示异常，屏幕闪烁', 2, NULL, '2026-03-09 23:09:09', '2026-05-03 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (56, 7, 8, '按键失灵，无法正常操作', 2, NULL, '2026-03-06 23:09:09', '2026-04-07 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (57, 7, 7, '接口损坏，无法连接', 2, NULL, '2026-04-04 23:09:09', '2026-04-10 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (58, 7, 5, '无法开机，电源指示灯不亮', 2, NULL, '2026-03-11 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (59, 8, 21, '接口损坏，无法连接', 1, NULL, '2026-03-26 23:09:09', '2026-05-04 23:09:09');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (60, 8, 33, '无法开机，电源指示灯不亮', 1, NULL, '2026-03-19 23:09:09', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (64, 1, 30, '无法开机，电源指示灯不亮', 2, NULL, '2026-04-18 23:10:35', '2026-04-16 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (65, 1, 27, '按键失灵，无法正常操作', 0, NULL, '2026-04-30 23:10:35', '2026-05-03 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (66, 1, 24, '按键失灵，无法正常操作', 2, '维修完成，设备恢复正常', '2026-03-08 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (67, 1, 34, '按键失灵，无法正常操作', 0, '维修完成，设备恢复正常', '2026-04-16 23:10:35', '2026-05-01 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (68, 1, 32, '运行卡顿，系统响应慢', 1, '维修完成，设备恢复正常', '2026-04-05 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (69, 1, 19, '运行卡顿，系统响应慢', 0, NULL, '2026-03-21 23:10:35', '2026-04-11 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (70, 1, 17, '显示异常，屏幕闪烁', 1, NULL, '2026-04-23 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (71, 1, 16, '按键失灵，无法正常操作', 2, NULL, '2026-03-15 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (72, 1, 14, '测量结果不准，偏差较大', 1, '维修完成，设备恢复正常', '2026-04-21 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (73, 1, 10, '运行卡顿，系统响应慢', 2, NULL, '2026-03-08 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (74, 1, 9, '无法开机，电源指示灯不亮', 0, NULL, '2026-03-24 23:10:35', '2026-05-01 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (75, 1, 3, '接口损坏，无法连接', 1, NULL, '2026-03-14 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (76, 2, 28, '测量结果不准，偏差较大', 1, '维修完成，设备恢复正常', '2026-05-04 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (77, 2, 23, '显示异常，屏幕闪烁', 1, NULL, '2026-03-21 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (78, 2, 33, '显示异常，屏幕闪烁', 0, NULL, '2026-04-01 23:10:35', '2026-04-27 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (79, 2, 32, '接口损坏，无法连接', 2, NULL, '2026-03-21 23:10:35', '2026-04-17 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (80, 2, 18, '显示异常，屏幕闪烁', 2, '维修完成，设备恢复正常', '2026-04-14 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (81, 2, 9, '运行卡顿，系统响应慢', 1, NULL, '2026-04-06 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (82, 2, 7, '接口损坏，无法连接', 1, '维修完成，设备恢复正常', '2026-04-23 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (83, 2, 6, '按键失灵，无法正常操作', 1, '维修完成，设备恢复正常', '2026-03-30 23:10:35', '2026-05-04 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (84, 2, 4, '显示异常，屏幕闪烁', 2, '维修完成，设备恢复正常', '2026-04-29 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (85, 2, 3, '接口损坏，无法连接', 2, NULL, '2026-03-11 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (86, 3, 30, '测量结果不准，偏差较大', 0, '维修完成，设备恢复正常', '2026-04-28 23:10:35', '2026-04-28 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (87, 3, 26, '按键失灵，无法正常操作', 1, '维修完成，设备恢复正常', '2026-04-21 23:10:35', '2026-04-07 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (88, 3, 25, '无法开机，电源指示灯不亮', 1, NULL, '2026-03-12 23:10:35', '2026-05-02 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (89, 3, 35, '显示异常，屏幕闪烁', 0, NULL, '2026-04-28 23:10:35', '2026-04-07 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (90, 3, 17, '接口损坏，无法连接', 2, '维修完成，设备恢复正常', '2026-03-29 23:10:35', '2026-04-08 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (91, 3, 16, '测量结果不准，偏差较大', 0, '维修完成，设备恢复正常', '2026-04-01 23:10:35', '2026-05-01 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (92, 3, 8, '运行卡顿，系统响应慢', 2, '维修完成，设备恢复正常', '2026-04-29 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (93, 3, 3, '接口损坏，无法连接', 0, NULL, '2026-03-13 23:10:35', '2026-04-28 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (94, 3, 1, '测量结果不准，偏差较大', 1, '维修完成，设备恢复正常', '2026-03-16 23:10:35', '2026-04-12 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (95, 4, 29, '按键失灵，无法正常操作', 2, NULL, '2026-04-13 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (96, 4, 27, '按键失灵，无法正常操作', 1, NULL, '2026-03-20 23:10:35', '2026-04-22 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (97, 4, 26, '运行卡顿，系统响应慢', 2, NULL, '2026-03-24 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (98, 4, 34, '运行卡顿，系统响应慢', 1, NULL, '2026-03-08 23:10:35', '2026-04-08 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (99, 4, 19, '运行卡顿，系统响应慢', 2, NULL, '2026-04-02 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (100, 4, 14, '无法开机，电源指示灯不亮', 1, NULL, '2026-03-26 23:10:35', '2026-04-26 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (101, 4, 13, '按键失灵，无法正常操作', 2, '维修完成，设备恢复正常', '2026-03-07 23:10:35', '2026-04-23 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (102, 4, 11, '接口损坏，无法连接', 0, '维修完成，设备恢复正常', '2026-03-28 23:10:35', '2026-04-26 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (103, 4, 9, '无法开机，电源指示灯不亮', 0, NULL, '2026-03-12 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (104, 4, 8, '显示异常，屏幕闪烁', 0, '维修完成，设备恢复正常', '2026-03-29 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (105, 4, 6, '显示异常，屏幕闪烁', 0, '维修完成，设备恢复正常', '2026-03-06 23:10:35', '2026-05-03 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (106, 5, 30, '测量结果不准，偏差较大', 1, '维修完成，设备恢复正常', '2026-04-08 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (107, 5, 28, '接口损坏，无法连接', 2, '维修完成，设备恢复正常', '2026-04-07 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (108, 5, 24, '无法开机，电源指示灯不亮', 0, NULL, '2026-03-28 23:10:35', '2026-04-07 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (109, 5, 23, '无法开机，电源指示灯不亮', 2, '维修完成，设备恢复正常', '2026-05-01 23:10:35', '2026-05-03 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (110, 5, 34, '按键失灵，无法正常操作', 1, '维修完成，设备恢复正常', '2026-04-21 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (111, 5, 20, '显示异常，屏幕闪烁', 2, '维修完成，设备恢复正常', '2026-03-28 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (112, 5, 18, '运行卡顿，系统响应慢', 0, '维修完成，设备恢复正常', '2026-04-21 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (113, 5, 14, '无法开机，电源指示灯不亮', 1, '维修完成，设备恢复正常', '2026-04-12 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (114, 5, 11, '测量结果不准，偏差较大', 0, NULL, '2026-04-28 23:10:35', '2026-04-27 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (115, 5, 9, '运行卡顿，系统响应慢', 0, '维修完成，设备恢复正常', '2026-04-11 23:10:35', '2026-04-23 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (116, 5, 7, '按键失灵，无法正常操作', 1, NULL, '2026-04-26 23:10:35', '2026-04-25 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (117, 5, 5, '无法开机，电源指示灯不亮', 0, '维修完成，设备恢复正常', '2026-03-27 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (118, 5, 2, '无法开机，电源指示灯不亮', 1, NULL, '2026-04-10 23:10:35', '2026-04-16 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (119, 5, 1, '显示异常，屏幕闪烁', 1, NULL, '2026-04-12 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (120, 6, 27, '按键失灵，无法正常操作', 2, NULL, '2026-03-09 23:10:35', NULL);
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (121, 6, 25, '按键失灵，无法正常操作', 0, NULL, '2026-04-16 23:10:35', '2026-04-06 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (122, 6, 21, '测量结果不准，偏差较大', 0, '维修完成，设备恢复正常', '2026-03-29 23:10:35', '2026-04-29 23:10:35');
INSERT INTO `repair_record` (`id`, `device_id`, `user_id`, `fault_desc`, `repair_status`, `repair_result`, `report_time`, `finish_time`) VALUES (123, 6, 33, '按键失灵，无法正常操作', 1, NULL, '2026-03-12 23:10:35', NULL);

-- ---------- notice ----------
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (1, '实验室开放时间调整通知', '各位师生：从5月1日起，实验室开放时间调整为周一至周五 8:00-22:00，周末 9:00-18:00。请相互转告。', 1, '2025-04-30 09:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (2, '新设备采购到位通知', 'C栋405实验室新到一批数字示波器和信号发生器，欢迎各位同学预约使用。', 2, '2025-04-28 14:30:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (3, '设备维护保养公告', '本周末（5月10日-11日）将对A栋、B栋实验室设备进行例行维护，届时部分设备暂停使用。', 1, '2025-05-05 10:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (4, '五一假期值班安排', '五一假期期间（5月1日-5月5日），实验室管理中心安排值班，电话：0731-12345678。', 2, '2025-04-25 16:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (5, '实验室安全培训通知', '定于5月20日下午2点在A栋101教室举办实验室安全培训，请全体实验员参加。', 1, '2025-05-08 11:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (6, '设备借用规范提醒', '请各位师生借用设备后按时归还，逾期将影响后续借用权限。爱护设备，人人有责。', 1, '2025-04-20 09:30:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (7, '服务器维护通知', '实验室管理系统服务器将于5月25日凌晨2:00-6:00进行升级维护，届时系统暂停使用。', 2, '2025-05-15 15:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (8, '期末实验室使用须知', '期末临近，实验室使用高峰期，请同学们提前预约，合理使用设备。', 1, '2025-05-18 10:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (9, '示波器使用培训通知', '本周四下午3点在C栋405举办示波器使用培训，欢迎报名参加。', 2, '2025-05-10 08:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (10, '设备报废公示', '以下设备因年限过长已报废：DEV2023001（旧款投影仪）、DEV2023005（故障服务器）。', 1, '2025-04-15 14:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (11, '暑期实验室开放安排', '暑期期间实验室正常开放，开放时间调整为周一至周五 9:00-17:00。', 2, '2025-05-20 09:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (12, '新系统功能介绍', '实验室设备管理系统新增预约功能和逾期提醒功能，欢迎体验。', 1, '2025-05-01 10:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (13, '紧急设备故障通知', 'C栋406实验室信号发生器故障，已联系维修，恢复时间另行通知。', 2, '2025-05-12 11:30:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (14, '设备借用大数据分析报告', '2025年第一季度设备借用统计报告已发布，请在公告栏查看详情。', 1, '2025-04-10 16:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (15, '实验室卫生检查通知', '下周一将进行实验室卫生检查，请各实验室做好清洁工作。', 2, '2025-05-19 08:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (16, '设备二维码上线通知', '实验室设备已张贴二维码，扫描即可查看设备信息并申请借用。', 1, '2025-05-05 14:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (17, '实验课程调整通知', '因教师出差，本周五下午的电子实验课暂停一次。', 2, '2025-05-16 09:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (18, '设备借用排行榜', '本月设备借用排行榜：示波器、万用表、笔记本电脑位列前三。', 1, '2025-05-25 15:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (19, '实验室搬迁通知', 'B栋实验室将于6月1日起搬迁至新楼，暂停使用两周。', 2, '2025-05-21 10:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (20, '设备认领通知', '实验室发现遗留U盘、笔记本等物品，请失主于一楼值班室认领。', 1, '2025-05-14 09:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (21, '教师借用绿色通道', '教师教学急需借用设备，可联系实验员优先处理。', 2, '2025-05-07 11:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (22, '实验室夜间开放试点', 'A栋101、102实验室即日起试行24小时开放，需刷卡进入。', 1, '2025-05-22 16:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (23, '设备捐赠感谢信', '感谢XX公司向本实验室捐赠10台示波器。', 2, '2025-04-18 10:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (24, '学生助理招聘', '实验室管理中心招聘学生助理5名，有意者请提交简历。', 1, '2025-05-09 08:30:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (25, '实验安全知识竞赛', '实验室安全知识竞赛将于6月10日举行，欢迎报名参加。', 2, '2025-05-23 14:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (26, '设备操作视频上线', '常用设备操作教学视频已上传至系统，可在线观看。', 1, '2025-05-17 09:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (27, '实验室意见征集', '为提升服务质量，现面向师生征集实验室管理意见。', 2, '2025-05-06 15:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (28, '端午节放假通知', '端午节期间实验室闭馆一天，请提前做好设备归还。', 1, '2025-05-24 10:00:00', 0);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (29, '设备借用须知(长期)', '借用设备请爱惜使用，损坏需按规定赔偿。', 1, '2025-04-01 09:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (30, '实验室数据备份提醒', '请各位同学及时备份实验数据，实验室电脑将于月底格式化。', 2, '2025-05-26 14:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (31, '虚拟仿真平台上线', '虚拟仿真实验平台已上线，支持远程实验教学。', 1, '2025-05-11 10:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (32, '实验室开放日', '6月1日将举办实验室开放日活动，欢迎参观体验。', 2, '2025-05-27 09:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (33, '设备价格公示', '实验室设备价格及赔偿标准已公示，请在一楼公告栏查看。', 1, '2025-05-13 16:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (34, '期末设备归还通知', '请于6月30日前归还所有借用的设备，逾期将按天计费。', 2, '2025-05-28 08:00:00', 1);
INSERT INTO `notice` (`id`, `title`, `content`, `publish_user_id`, `publish_time`, `status`) VALUES (35, '祝毕业生前程似锦', '祝2025届毕业生前程似锦，感谢你们的陪伴！', 1, '2025-05-29 12:00:00', 1);

-- ============================================================
-- 追加标准演示账号（密码均为 123456，明文存储，后端兼容明文/BCrypt）
-- ============================================================
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`) VALUES
('admin', '123456', '系统管理员', '13600000000', 'admin@lab.local', 3, 1),
('lab', '123456', '实验员老师', '13700000000', 'lab@lab.local', 2, 1),
('student', '123456', '演示学生', '13800000000', 'student@lab.local', 1, 1);

-- ============================================================
-- 数据一致性校正：设备状态与借用记录同步
-- ============================================================
-- 借用中/逾期未归还的记录，对应设备置为「已借出」
UPDATE device d
SET d.status = 2
WHERE EXISTS (
    SELECT 1 FROM borrow_record br
    WHERE br.device_id = d.id AND br.status IN (1, 3) AND br.return_time IS NULL
);

-- 维修中状态的报修，对应设备置为「维修中」
UPDATE device d
SET d.status = 3
WHERE EXISTS (
    SELECT 1 FROM repair_record rr
    WHERE rr.device_id = d.id AND rr.repair_status IN (0, 1)
)
AND d.status <> 2;

-- ============================================================
-- 数据统计验证
-- ============================================================
SELECT '角色' AS item, COUNT(*) AS cnt FROM role
UNION ALL SELECT '用户', COUNT(*) FROM `user`
UNION ALL SELECT '设备分类', COUNT(*) FROM device_category
UNION ALL SELECT '设备', COUNT(*) FROM device
UNION ALL SELECT '借用申请', COUNT(*) FROM borrow_apply
UNION ALL SELECT '借用记录', COUNT(*) FROM borrow_record
UNION ALL SELECT '报修记录', COUNT(*) FROM repair_record
UNION ALL SELECT '公告', COUNT(*) FROM notice;

