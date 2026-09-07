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
    credit_score INT DEFAULT 100 COMMENT '诚信评分，默认100',
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
    brand VARCHAR(100),
    specification VARCHAR(255),
    image_url VARCHAR(500),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES device(id)
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
-- 实验室综合管理模块（实验室信息/预约/采购/耗材/危化品/废弃物/诚信）
-- ============================================================

CREATE TABLE lab_type (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT='实验室类型表';

CREATE TABLE lab_room (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    capacity INT DEFAULT 0,
    manager VARCHAR(50),
    description VARCHAR(255),
    status TINYINT DEFAULT 1,
    type_id BIGINT,
    image_url VARCHAR(500),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT='实验室信息表';

CREATE TABLE lab_reservation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    lab_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    reserve_date DATE NOT NULL,
    time_slot VARCHAR(50),
    purpose VARCHAR(255),
    status TINYINT DEFAULT 0,
    audit_user_id BIGINT,
    audit_time DATETIME,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lab_id) REFERENCES lab_room(id),
    FOREIGN KEY (user_id) REFERENCES `user`(id)
) COMMENT='实验室预约表';

CREATE TABLE device_reservation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    device_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    reserve_date DATE NOT NULL,
    time_slot VARCHAR(50),
    purpose VARCHAR(255),
    status TINYINT DEFAULT 0,
    audit_user_id BIGINT,
    audit_time DATETIME,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (device_id) REFERENCES device(id),
    FOREIGN KEY (user_id) REFERENCES `user`(id)
) COMMENT='设备预约表';

CREATE TABLE device_purchase (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    device_name VARCHAR(100) NOT NULL,
    model VARCHAR(100),
    category_id BIGINT,
    quantity INT DEFAULT 1,
    unit_price DECIMAL(12,2),
    supplier VARCHAR(100),
    applicant_id BIGINT,
    purpose VARCHAR(255),
    status TINYINT DEFAULT 0,
    audit_user_id BIGINT,
    audit_time DATETIME,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES device_category(id),
    FOREIGN KEY (applicant_id) REFERENCES `user`(id)
) COMMENT='设备采购表';

CREATE TABLE consumable (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    spec VARCHAR(100),
    unit VARCHAR(20),
    quantity INT DEFAULT 0,
    category VARCHAR(50),
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT='实验室耗材表';

CREATE TABLE hazardous_chemical (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cas_no VARCHAR(50),
    name VARCHAR(100) NOT NULL,
    risk_level VARCHAR(20),
    category VARCHAR(50),
    unit VARCHAR(20),
    description VARCHAR(255),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT='危化品标准库表';

CREATE TABLE waste (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    waste_no VARCHAR(50),
    type VARCHAR(50),
    source VARCHAR(100),
    quantity DECIMAL(12,2),
    unit VARCHAR(20),
    reporter_id BIGINT,
    status TINYINT DEFAULT 0,
    audit_user_id BIGINT,
    audit_time DATETIME,
    audit_remark VARCHAR(255),
    dispose_user_id BIGINT,
    dispose_time DATETIME,
    dispose_remark VARCHAR(255),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reporter_id) REFERENCES `user`(id)
) COMMENT='废弃物管理表';

CREATE TABLE credit_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    change_type VARCHAR(50),
    score_change INT,
    reason VARCHAR(255),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES `user`(id)
) COMMENT='诚信评分变更记录表';

-- 实验室信息演示数据
INSERT INTO lab_room (name, location, capacity, manager, description, status) VALUES
('物理实验室A', '实验楼1层101', 40, '张老师', '基础物理实验教学', 1),
('化学实验室B', '实验楼2层201', 30, '李老师', '有机化学实验', 1),
('电子实验室C', '实验楼3层301', 35, '王老师', '电路与电子技术实验', 1),
('生物实验室D', '实验楼2层205', 25, '赵老师', '微生物培养实验', 1),
('计算机实验室E', '实验楼4层401', 50, '陈老师', '编程与算法实验', 1);

INSERT INTO lab_reservation (lab_id, user_id, reserve_date, time_slot, purpose, status, create_time) VALUES
(1, 1, '2026-08-27', '08:00-10:00', '物理实验课', 1, '2026-08-26 09:00:00'),
(2, 2, '2026-08-28', '10:00-12:00', '化学实验课', 1, '2026-08-26 09:30:00'),
(3, 3, '2026-08-29', '14:00-16:00', '电子竞赛训练', 0, '2026-08-26 10:00:00'),
(4, 4, '2026-08-30', '08:00-10:00', '生物实验', 2, '2026-08-26 10:30:00');

INSERT INTO device_reservation (device_id, user_id, reserve_date, time_slot, purpose, status, create_time) VALUES
(5, 1, '2026-08-27', '08:00-10:00', '示波器实验', 1, '2026-08-26 09:00:00'),
(6, 2, '2026-08-28', '10:00-12:00', '信号发生器实验', 0, '2026-08-26 09:30:00'),
(7, 3, '2026-08-29', '14:00-16:00', '电源实验', 1, '2026-08-26 10:00:00');

INSERT INTO device_purchase (device_name, model, category_id, quantity, unit_price, supplier, applicant_id, purpose, status, create_time) VALUES
('数字示波器', 'Rigol DS1104Z', 1, 5, 4500.00, '泰克科技', 2, '补充实验设备', 0, '2026-08-20 10:00:00'),
('信号发生器', 'Rigol DG1022Z', 3, 3, 3800.00, '普源精电', 2, '信号实验教学', 1, '2026-08-21 10:00:00'),
('直流稳压电源', 'Rigol DP832', 4, 8, 2600.00, '普源精电', 2, '电源实验', 2, '2026-08-22 10:00:00');

INSERT INTO consumable (name, spec, unit, quantity, category, status) VALUES
('烧杯', '500ml', '个', 100, '玻璃器皿', 1),
('试管', '18mm', '支', 200, '玻璃器皿', 1),
('滤纸', '中速', '盒', 50, '耗材', 1),
('酒精灯', '250ml', '个', 30, '加热设备', 1),
('pH试纸', '1-14', '盒', 80, '试剂耗材', 1);

INSERT INTO hazardous_chemical (cas_no, name, risk_level, category, unit, description) VALUES
('64-19-7', '乙酸', '中', '酸类', '瓶', '冰醋酸，腐蚀性'),
('67-56-1', '甲醇', '高', '醇类', '瓶', '易燃有毒'),
('64-17-5', '乙醇', '中', '醇类', '瓶', '易燃'),
('1310-73-2', '氢氧化钠', '高', '碱类', '瓶', '强腐蚀性'),
('7697-37-2', '硝酸', '高', '酸类', '瓶', '强氧化腐蚀');

INSERT INTO waste (waste_no, type, source, quantity, unit, reporter_id, status, create_time) VALUES
('W2026001', '化学废液', '化学实验室B', 5.5, '升', 2, 0, '2026-08-25 10:00:00'),
('W2026002', '废旧电池', '电子实验室C', 20, '个', 2, 1, '2026-08-25 11:00:00'),
('W2026003', '实验废弃物', '生物实验室D', 3.2, '千克', 2, 2, '2026-08-25 12:00:00');

-- ============================================================
-- 反馈建议表、收藏表
-- ============================================================
CREATE TABLE feedback (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    type VARCHAR(50),
    status TINYINT DEFAULT 0,
    reply TEXT,
    reply_user_id BIGINT,
    reply_time DATETIME,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES `user`(id)
) COMMENT='反馈建议表';

CREATE TABLE favorite (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    target_type VARCHAR(20),
    target_id BIGINT NOT NULL,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES `user`(id),
    UNIQUE KEY uk_user_target (user_id, target_type, target_id)
) COMMENT='收藏表';

-- 实验室类型数据
INSERT INTO lab_type (type_name, description) VALUES
('物理实验室', '力学、电磁学、光学等基础物理实验'),
('化学实验室', '有机、无机、分析化学实验'),
('电子实验室', '电路、数字电路、嵌入式实验'),
('生物实验室', '微生物、细胞、分子生物实验'),
('计算机实验室', '编程、算法、网络实验'),
('综合实验室', '多学科交叉综合实验');

-- 更新实验室类型和图片
UPDATE lab_room SET type_id = 1, image_url = '/images/lab_physics.png' WHERE name = '物理实验室A';
UPDATE lab_room SET type_id = 2, image_url = '/images/lab_chemistry.png' WHERE name = '化学实验室B';
UPDATE lab_room SET type_id = 3, image_url = '/images/lab_electronics.png' WHERE name = '电子实验室C';
UPDATE lab_room SET type_id = 4, image_url = '/images/lab_biology.png' WHERE name = '生物实验室D';
UPDATE lab_room SET type_id = 5, image_url = '/images/lab_computer.png' WHERE name = '计算机实验室E';

-- 补充更多实验室信息
INSERT INTO lab_room (name, location, capacity, manager, description, status, type_id, image_url) VALUES
('材料实验室F', '实验楼3层305', 20, '孙老师', '材料力学与性能测试实验', 1, 1, '/images/lab_material.png'),
('光学实验室G', '实验楼1层105', 25, '周老师', '光学与激光技术实验', 1, 1, '/images/lab_optics.png'),
('化学分析实验室H', '实验楼2层209', 28, '吴老师', '仪器分析与化学检测实验', 1, 2, '/images/lab_analysis.png'),
('网络实验室I', '实验楼4层405', 45, '郑老师', '计算机网络与信息安全实验', 1, 5, '/images/lab_network.png');

-- 更新设备图片、品牌、规格（示例设备）
UPDATE device SET image_url = '/images/device_oscilloscope.png', brand = 'Rigol', specification = '100MHz带宽，4通道，1GSa/s采样率' WHERE device_no = 'DSO-001';
UPDATE device SET image_url = '/images/device_generator.png', brand = 'Rigol', specification = '20MHz任意波形，双通道输出' WHERE device_no = 'DSO-002';
UPDATE device SET image_url = '/images/device_power.png', brand = 'Rigol', specification = '双路输出，0-30V/3A' WHERE device_no = 'DSO-003';

-- 反馈建议演示数据
INSERT INTO feedback (user_id, title, content, type, status, reply, reply_time, create_time) VALUES
(1, '建议增加更多示波器', '示波器数量不足，实验课经常需要排队', '建议', 0, NULL, NULL, '2026-08-25 10:00:00'),
(2, '实验室空调故障', '化学实验室B的空调制冷效果差', '投诉', 1, '已联系维修，预计本周内修复', '2026-08-25 15:00:00', '2026-08-25 14:00:00'),
(3, '咨询设备借用流程', '请问设备借用需要什么条件？', '咨询', 1, '诚信分需达到60分以上，且设备状态为可借', '2026-08-25 16:00:00', '2026-08-25 15:30:00');

-- 收藏演示数据
INSERT INTO favorite (user_id, target_type, target_id) VALUES
(1, 'lab', 1),
(1, 'lab', 3),
(1, 'device', 1),
(2, 'lab', 2),
(2, 'device', 5);

-- 1. 环境监测点表
CREATE TABLE IF NOT EXISTS environment_sensor (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    sensor_code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    lab_id BIGINT,
    type VARCHAR(50) COMMENT 'temperature/humidity/pm25/tvoc/illuminance/noise',
    unit VARCHAR(20),
    status TINYINT DEFAULT 1 COMMENT '1 在线 0 离线 2 故障',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lab_id) REFERENCES lab_room(id)
) COMMENT='环境监测点表';

-- 2. 环境监测数据表（按时间序列）
CREATE TABLE IF NOT EXISTS environment_data (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    sensor_id BIGINT NOT NULL,
    value DECIMAL(12,3) NOT NULL,
    collect_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensor_id) REFERENCES environment_sensor(id)
) COMMENT='环境监测数据';

-- 3. 能耗监测点
CREATE TABLE IF NOT EXISTS energy_meter (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    meter_code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    lab_id BIGINT,
    type VARCHAR(20) COMMENT 'water/electricity/gas',
    unit VARCHAR(20),
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lab_id) REFERENCES lab_room(id)
) COMMENT='能耗监测表';

-- 4. 能耗数据
CREATE TABLE IF NOT EXISTS energy_data (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    meter_id BIGINT NOT NULL,
    value DECIMAL(14,3) NOT NULL,
    collect_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (meter_id) REFERENCES energy_meter(id)
) COMMENT='能耗数据';

-- 5. 报警阈值
CREATE TABLE IF NOT EXISTS alarm_threshold (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    target_type VARCHAR(20) COMMENT 'sensor/energy/device',
    target_id BIGINT,
    metric VARCHAR(50) COMMENT 'temperature/humidity/pm25...',
    min_value DECIMAL(12,3),
    max_value DECIMAL(12,3),
    level VARCHAR(20) DEFAULT 'warning' COMMENT 'info/warning/critical',
    enabled TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT='报警阈值表';

-- 6. 报警记录
CREATE TABLE IF NOT EXISTS alarm_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    target_type VARCHAR(20),
    target_id BIGINT,
    target_name VARCHAR(200),
    metric VARCHAR(50),
    value DECIMAL(12,3),
    level VARCHAR(20) DEFAULT 'warning',
    message VARCHAR(500),
    status TINYINT DEFAULT 0 COMMENT '0 待处理 1 处理中 2 已处理 3 已忽略',
    handler_id BIGINT,
    handle_time DATETIME,
    handle_remark VARCHAR(500),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (handler_id) REFERENCES `user`(id)
) COMMENT='报警记录';

-- 7. 仪器（区别于设备，含检定/校准）
CREATE TABLE IF NOT EXISTS instrument (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    instrument_no VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    device_id BIGINT COMMENT '关联的设备ID',
    category_id BIGINT,
    model VARCHAR(100),
    brand VARCHAR(100),
    specification VARCHAR(255),
    accuracy VARCHAR(100) COMMENT '精度',
    serial_no VARCHAR(100) COMMENT '出厂编号',
    purchase_date DATE,
    last_check_date DATE COMMENT '上次检定日期',
    next_check_date DATE COMMENT '下次检定日期',
    check_cycle INT DEFAULT 365 COMMENT '检定周期(天)',
    status TINYINT DEFAULT 1 COMMENT '1 正常 2 检定中 3 停用 4 报废',
    location VARCHAR(100),
    image_url VARCHAR(500),
    description VARCHAR(500),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (device_id) REFERENCES device(id),
    FOREIGN KEY (category_id) REFERENCES device_category(id)
) COMMENT='仪器表（含检定）';

-- 8. 仪器检定记录
CREATE TABLE IF NOT EXISTS instrument_check (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    instrument_id BIGINT NOT NULL,
    check_date DATE NOT NULL,
    check_type VARCHAR(50) COMMENT '检定/校准/测试',
    result VARCHAR(20) COMMENT '合格/不合格',
    organization VARCHAR(200),
    certificate_no VARCHAR(100),
    next_date DATE,
    operator_id BIGINT,
    remark VARCHAR(500),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (instrument_id) REFERENCES instrument(id),
    FOREIGN KEY (operator_id) REFERENCES `user`(id)
) COMMENT='仪器检定记录';

-- 9. 值班管理
CREATE TABLE IF NOT EXISTS duty_schedule (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    duty_date DATE NOT NULL,
    shift VARCHAR(20) COMMENT '早班/中班/晚班',
    status TINYINT DEFAULT 0 COMMENT '0 待值班 1 已值班 2 换班',
    remark VARCHAR(255),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES `user`(id)
) COMMENT='值班表';

-- 10. 巡检管理
CREATE TABLE IF NOT EXISTS patrol_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    patrol_date DATE NOT NULL,
    lab_id BIGINT,
    items TEXT COMMENT '巡检项目JSON',
    result VARCHAR(500),
    status TINYINT DEFAULT 1 COMMENT '1 正常 2 异常',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES `user`(id),
    FOREIGN KEY (lab_id) REFERENCES lab_room(id)
) COMMENT='巡检记录';

-- 11. 知识库
CREATE TABLE IF NOT EXISTS knowledge (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    category VARCHAR(50) COMMENT '操作规范/安全知识/应急预案',
    content TEXT,
    author_id BIGINT,
    view_count INT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES `user`(id)
) COMMENT='知识库表';

-- 12. 培训/安全准入记录
CREATE TABLE IF NOT EXISTS training_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    training_name VARCHAR(200) NOT NULL,
    training_date DATE NOT NULL,
    result VARCHAR(20) COMMENT '通过/未通过',
    certificate VARCHAR(200),
    valid_until DATE,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES `user`(id)
) COMMENT='培训记录';

-- 13. 实验课程（校园场景）
CREATE TABLE IF NOT EXISTS course (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(200) NOT NULL,
    teacher_id BIGINT,
    lab_id BIGINT,
    class_time VARCHAR(100),
    semester VARCHAR(50),
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES `user`(id),
    FOREIGN KEY (lab_id) REFERENCES lab_room(id)
) COMMENT='实验课程表';

-- ============================================================
-- 演示数据
-- ============================================================

-- 环境监测点
INSERT INTO environment_sensor (sensor_code, name, location, lab_id, type, unit, status) VALUES
('SEN001', '物理实验室A-温度', '物理实验室A', 1, 'temperature', '℃', 1),
('SEN002', '物理实验室A-湿度', '物理实验室A', 1, 'humidity', '%', 1),
('SEN003', '化学实验室B-PM2.5', '化学实验室B', 2, 'pm25', 'μg/m³', 1),
('SEN004', '化学实验室B-温度', '化学实验室B', 2, 'temperature', '℃', 1),
('SEN005', '电子实验室C-湿度', '电子实验室C', 3, 'humidity', '%', 1),
('SEN006', '生物实验室D-PM2.5', '生物实验室D', 4, 'pm25', 'μg/m³', 1),
('SEN007', '计算机实验室E-温度', '计算机实验室E', 5, 'temperature', '℃', 1),
('SEN008', '计算机实验室E-湿度', '计算机实验室E', 5, 'humidity', '%', 1);

-- 环境监测数据（最近24小时）
INSERT INTO environment_data (sensor_id, value, collect_time) VALUES
(1, 22.5, NOW()), (1, 22.8, DATE_SUB(NOW(), INTERVAL 1 HOUR)), (1, 23.1, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(2, 45.0, NOW()), (2, 46.0, DATE_SUB(NOW(), INTERVAL 1 HOUR)), (2, 47.5, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(3, 35.0, NOW()), (3, 38.0, DATE_SUB(NOW(), INTERVAL 1 HOUR)), (3, 40.0, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(4, 24.0, NOW()), (4, 24.5, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(5, 50.0, NOW()), (5, 52.0, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(6, 28.0, NOW()), (6, 32.0, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(7, 21.5, NOW()), (7, 22.0, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(8, 48.0, NOW()), (8, 49.0, DATE_SUB(NOW(), INTERVAL 1 HOUR));

-- 能耗监测点
INSERT INTO energy_meter (meter_code, name, location, lab_id, type, unit) VALUES
('MTR001', '物理楼总水表', '物理楼', 1, 'water', 'm³'),
('MTR002', '物理楼总电表', '物理楼', 1, 'electricity', 'kWh'),
('MTR003', '化学楼总水表', '化学楼', 2, 'water', 'm³'),
('MTR004', '化学楼总电表', '化学楼', 2, 'electricity', 'kWh'),
('MTR005', '全校总水表', '全校', NULL, 'water', 'm³'),
('MTR006', '全校总电表', '全校', NULL, 'electricity', 'kWh'),
('MTR007', '全校总燃气', '全校', NULL, 'gas', 'm³');

-- 能耗数据
INSERT INTO energy_data (meter_id, value, collect_time) VALUES
(1, 4022.5, NOW()), (1, 4020.0, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(2, 4022.0, NOW()), (2, 4020.0, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(3, 1020.5, NOW()),
(4, 850.0, NOW()),
(5, 403323.0, NOW()),
(6, 403323.0, NOW()),
(7, 12500.0, NOW());

-- 报警阈值
INSERT INTO alarm_threshold (target_type, target_id, metric, min_value, max_value, level) VALUES
('sensor', 1, 'temperature', 18.0, 28.0, 'warning'),
('sensor', 1, 'temperature', 30.0, NULL, 'critical'),
('sensor', 2, 'humidity', 30.0, 70.0, 'warning'),
('sensor', 3, 'pm25', NULL, 75.0, 'warning'),
('sensor', 3, 'pm25', NULL, 150.0, 'critical');

-- 报警记录
INSERT INTO alarm_record (target_type, target_id, target_name, metric, value, level, message, status, create_time) VALUES
('sensor', 3, '化学实验室B-PM2.5', 'pm25', 95.0, 'warning', 'PM2.5浓度超过阈值75μg/m³', 0, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
('sensor', 3, '化学实验室B-PM2.5', 'pm25', 78.0, 'warning', 'PM2.5浓度接近阈值', 0, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
('sensor', 1, '物理实验室A-温度', 'temperature', 31.0, 'critical', '温度超过30℃', 2, DATE_SUB(NOW(), INTERVAL 3 HOUR)),
('device', 1, 'DSO-001 数字示波器', 'device_status', 0, 'info', '设备异常离线', 2, DATE_SUB(NOW(), INTERVAL 1 DAY));

-- 仪器数据
INSERT INTO instrument (instrument_no, name, device_id, category_id, model, brand, specification, accuracy, serial_no, last_check_date, next_check_date, check_cycle, location) VALUES
('INS001', '数字示波器-高精度版', 1, 1, 'Rigol DS1054Z', 'Rigol', '100MHz带宽，4通道', '±2%', 'SN2023-001', '2025-06-15', '2026-06-15', 365, '物理实验室A'),
('INS002', '精密电子天平', 11, 2, 'AL204', 'Mettler Toledo', '220g/0.1mg', '0.1mg', 'SN2023-002', '2025-09-20', '2026-09-20', 365, '化学实验室B'),
('INS003', '数字万用表', 21, 3, 'DM3068', 'Rigol', '6.5位', '0.0035%', 'SN2023-003', '2025-12-10', '2026-12-10', 365, '电子实验室C');

-- 仪器检定记录
INSERT INTO instrument_check (instrument_id, check_date, check_type, result, organization, certificate_no, next_date, operator_id) VALUES
(1, '2025-06-15', '检定', '合格', '中国计量科学研究院', 'JZH2025-0001', '2026-06-15', 2),
(2, '2025-09-20', '检定', '合格', '中国计量科学研究院', 'JZH2025-0002', '2026-09-20', 2),
(3, '2025-12-10', '校准', '合格', '北京市计量检测研究院', 'JZH2025-0003', '2026-12-10', 2);

-- 值班表
INSERT INTO duty_schedule (user_id, duty_date, shift, status) VALUES
(2, CURDATE(), '早班', 1),
(2, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '早班', 0),
(2, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '中班', 0),
(2, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '晚班', 0),
(2, DATE_ADD(CURDATE(), INTERVAL 4 DAY), '早班', 0);

-- 巡检记录
INSERT INTO patrol_record (user_id, patrol_date, lab_id, items, result, status) VALUES
(2, CURDATE(), 1, '[{"name":"消防器材","ok":true},{"name":"电源安全","ok":true},{"name":"设备状态","ok":true}]', '巡检正常', 1),
(2, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 2, '[{"name":"化学品存储","ok":true},{"name":"通风系统","ok":true},{"name":"消防器材","ok":true}]', '巡检正常', 1),
(2, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 3, '[{"name":"设备状态","ok":true},{"name":"电源安全","ok":false},{"name":"消防器材","ok":true}]', '发现电源问题，已修复', 1);

-- 知识库
INSERT INTO knowledge (title, category, content, author_id) VALUES
('实验室安全操作规范', '安全知识', '1. 进入实验室必须穿戴实验服\n2. 严格遵守操作规程\n3. 危险化学品按规范存储\n4. 应急设备位置熟记', 1),
('化学品泄漏应急预案', '应急预案', '1. 立即疏散人员\n2. 启动通风系统\n3. 使用专业吸收材料\n4. 通知实验室负责人', 1),
('仪器设备检定流程', '操作规范', '1. 提前30天申请检定\n2. 准备检定所需资料\n3. 送检或邀请检定机构现场检定\n4. 获取检定证书并归档', 1);

-- 培训记录
INSERT INTO training_record (user_id, training_name, training_date, result, certificate, valid_until) VALUES
(1, '实验室安全准入培训', '2026-01-15', '通过', 'SAFE-2026-0001', '2027-01-15'),
(2, '危化品使用培训', '2026-02-20', '通过', 'HAZ-2026-0002', '2027-02-20'),
(3, '消防安全培训', '2026-03-10', '通过', 'FIRE-2026-0003', '2027-03-10');

-- 实验课程
INSERT INTO course (course_name, teacher_id, lab_id, class_time, semester) VALUES
('大学物理实验', 2, 1, '周一上午 8:00-10:00', '2026春季'),
('有机化学实验', 2, 2, '周二下午 14:00-16:00', '2026春季'),
('电子技术实验', 2, 3, '周三上午 10:00-12:00', '2026春季'),
('生物实验', 2, 4, '周四下午 14:00-16:00', '2026春季');


-- ============================================================
-- 设备图片/品牌/规格数据
-- ============================================================
-- ============================================================
-- 为全部设备补充品牌、规格、图片数据
-- ============================================================
-- 示波器类（category_id=1）：数字示波器、手持示波器
UPDATE device SET brand='Rigol', specification='100MHz带宽，4通道，1GSa/s采样率', image_url='/images/device_oscilloscope.png' WHERE category_id=1 AND device_name='数字示波器';
UPDATE device SET brand='Fluke', specification='200MHz带宽，2通道，手持便携式', image_url='/images/device_handheld.png' WHERE category_id=1 AND device_name='手持示波器';

-- 万用表类（category_id=2）
UPDATE device SET brand='Fluke', specification='6.5位数字万用表，自动量程', image_url='/images/device_multimeter.png' WHERE category_id=2 AND device_name='数字万用表';
UPDATE device SET brand='Keithley', specification='台式高精度万用表，0.0035%基本精度', image_url='/images/device_multimeter.png' WHERE category_id=2 AND device_name='台式万用表';

-- 信号源类（category_id=3）
UPDATE device SET brand='Rigol', specification='20MHz任意波形，双通道输出', image_url='/images/device_generator.png' WHERE category_id=3 AND device_name IN ('函数信号发生器','任意波形发生器');
UPDATE device SET brand='Keysight', specification='6GHz射频信号源，低相位噪声', image_url='/images/device_generator.png' WHERE category_id=3 AND device_name='射频信号源';

-- 电源类（category_id=4）
UPDATE device SET brand='Rigol', specification='双路输出，0-30V/3A，低纹波', image_url='/images/device_power.png' WHERE category_id=4 AND device_name='直流稳压电源';
UPDATE device SET brand='Keysight', specification='可编程电源，0-60V/10A，程控接口', image_url='/images/device_power.png' WHERE category_id=4 AND device_name='可编程电源';

-- 计算机类（category_id=5）
UPDATE device SET brand='联想', specification='i7处理器，16GB内存，512GB SSD', image_url='/images/device_computer.png' WHERE category_id=5 AND device_name='台式计算机';
UPDATE device SET brand='戴尔', specification='至强处理器，32GB内存，专业图形工作站', image_url='/images/device_computer.png' WHERE category_id=5 AND device_name='工作站';
UPDATE device SET brand='联想', specification='i5处理器，16GB内存，14英寸', image_url='/images/device_computer.png' WHERE category_id=5 AND device_name='笔记本电脑';

-- 网络设备类（category_id=6）
UPDATE device SET brand='华为', specification='24口千兆交换机，三层交换', image_url='/images/device_network.png' WHERE category_id=6 AND device_name='千兆交换机';
UPDATE device SET brand='TP-Link', specification='双频无线AP，WiFi6，PoE供电', image_url='/images/device_network.png' WHERE category_id=6 AND device_name='无线AP';
UPDATE device SET brand='戴尔', specification='机架式服务器，双路CPU，128GB内存', image_url='/images/device_network.png' WHERE category_id=6 AND device_name='服务器';
UPDATE device SET brand='华为', specification='企业级路由器，多WAN口', image_url='/images/device_network.png' WHERE category_id=6 AND device_name='路由器';
UPDATE device SET brand='深信服', specification='下一代防火墙，IPS入侵防护', image_url='/images/device_network.png' WHERE category_id=6 AND device_name='防火墙';

-- 投影设备类（category_id=7）
UPDATE device SET brand='爱普生', specification='4500流明，1080P分辨率', image_url='/images/device_projector.png' WHERE category_id=7 AND device_name='投影仪';
UPDATE device SET brand='红叶', specification='120英寸电动幕布', image_url='/images/device_projector.png' WHERE category_id=7 AND device_name='投影幕布';
UPDATE device SET brand='索尼', specification='6500流明激光投影，4K分辨率', image_url='/images/device_projector.png' WHERE category_id=7 AND device_name='激光投影';
UPDATE device SET brand='JBL', specification='会议音响系统，无线麦克风', image_url='/images/device_projector.png' WHERE category_id=7 AND device_name='音响系统';

-- 测量仪器类（category_id=8）
UPDATE device SET brand='梅特勒', specification='0.01精度pH计，自动校准', image_url='/images/device_measurement.png' WHERE category_id=8 AND device_name='pH计';
UPDATE device SET brand='泰仕', specification='30-130dB量程，数字噪声计', image_url='/images/device_measurement.png' WHERE category_id=8 AND device_name='噪声计';
UPDATE device SET brand='德图', specification='温湿度一体测量，数据记录', image_url='/images/device_measurement.png' WHERE category_id=8 AND device_name='温湿度计';
UPDATE device SET brand='梅特勒', specification='0.1mg精度，220g量程电子天平', image_url='/images/device_measurement.png' WHERE category_id=8 AND device_name='电子天平';

-- 通信设备类（category_id=9）
UPDATE device SET brand='Keysight', specification='26.5GHz网络分析仪', image_url='/images/device_communication.png' WHERE category_id=9 AND device_name='网络分析仪';
UPDATE device SET brand='罗德与施瓦茨', specification='3.6GHz频谱分析仪', image_url='/images/device_communication.png' WHERE category_id=9 AND device_name='频谱分析仪';

-- 实验平台类（category_id=10）
UPDATE device SET brand='Xilinx', specification='FPGA开发板，Artix-7系列', image_url='/images/device_platform.png' WHERE category_id=10 AND device_name='FPGA开发板';
UPDATE device SET brand='普中科技', specification='单片机实验箱，51/STM32双平台', image_url='/images/device_platform.png' WHERE category_id=10 AND device_name='单片机实验箱';

-- 修正前3台设备图片对应错误
UPDATE device SET image_url='/images/device_oscilloscope.png' WHERE device_no IN ('DSO-001','DSO-002','DSO-003');
UPDATE device SET image_url='/images/device_handheld.png' WHERE device_name='手持示波器';

-- 为没有分类的设备补充默认图片
UPDATE device SET image_url='/images/device_measurement.png' WHERE image_url IS NULL OR image_url='';


-- ============================================================
-- 操作日志表
-- ============================================================
CREATE TABLE IF NOT EXISTS operation_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    username VARCHAR(50),
    module VARCHAR(50) COMMENT '操作模块',
    action VARCHAR(100) COMMENT '操作动作',
    detail VARCHAR(500) COMMENT '操作详情',
    ip VARCHAR(50),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES `user`(id)
) COMMENT='操作日志表';


-- 设备报废申请表
CREATE TABLE IF NOT EXISTS scrap_apply (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    device_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    reason VARCHAR(500) NOT NULL,
    status TINYINT DEFAULT 0 COMMENT '0 待审核 1 已通过 2 已拒绝',
    audit_user_id BIGINT,
    audit_time DATETIME,
    audit_remark VARCHAR(500),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (device_id) REFERENCES device(id),
    FOREIGN KEY (user_id) REFERENCES `user`(id)
) COMMENT='设备报废申请表';


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
UNION ALL SELECT '公告', COUNT(*) FROM notice
UNION ALL SELECT '实验室', COUNT(*) FROM lab_room
UNION ALL SELECT '耗材', COUNT(*) FROM consumable
UNION ALL SELECT '危化品', COUNT(*) FROM hazardous_chemical
UNION ALL SELECT '废弃物', COUNT(*) FROM waste
UNION ALL SELECT '实验室类型', COUNT(*) FROM lab_type
UNION ALL SELECT '环境监测点', COUNT(*) FROM environment_sensor
UNION ALL SELECT '能耗监测点', COUNT(*) FROM energy_meter
UNION ALL SELECT '报警记录', COUNT(*) FROM alarm_record
UNION ALL SELECT '仪器', COUNT(*) FROM instrument
UNION ALL SELECT '知识库', COUNT(*) FROM knowledge
UNION ALL SELECT '操作日志', COUNT(*) FROM operation_log
UNION ALL SELECT '报废申请', COUNT(*) FROM scrap_apply
UNION ALL SELECT '反馈建议', COUNT(*) FROM feedback
UNION ALL SELECT '收藏', COUNT(*) FROM favorite;

