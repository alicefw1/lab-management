SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE lab_equipment;

CREATE TABLE IF NOT EXISTS lab_class (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  class_name VARCHAR(100) NOT NULL,
  grade_year INT NOT NULL,
  major_name VARCHAR(100),
  department_name VARCHAR(100),
  counselor_id BIGINT,
  status TINYINT NOT NULL DEFAULT 1,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_class_name_year(class_name,grade_year),
  CONSTRAINT fk_class_counselor FOREIGN KEY(counselor_id) REFERENCES `user`(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='行政班级';

CREATE TABLE IF NOT EXISTS class_student (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  class_id BIGINT NOT NULL,
  student_id BIGINT NOT NULL,
  join_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_class_student(class_id,student_id),
  CONSTRAINT fk_cs_class FOREIGN KEY(class_id) REFERENCES lab_class(id) ON DELETE CASCADE,
  CONSTRAINT fk_cs_student FOREIGN KEY(student_id) REFERENCES `user`(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班级学生关联';

CREATE TABLE IF NOT EXISTS experiment_project (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  project_code VARCHAR(50),
  project_name VARCHAR(150) NOT NULL,
  course_name VARCHAR(100),
  hours DECIMAL(4,1) NOT NULL DEFAULT 2,
  objectives TEXT,
  safety_notes TEXT,
  report_template TEXT,
  creator_id BIGINT,
  status TINYINT NOT NULL DEFAULT 1,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_project_code(project_code),
  CONSTRAINT fk_project_creator FOREIGN KEY(creator_id) REFERENCES `user`(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验项目库';

CREATE TABLE IF NOT EXISTS experiment_schedule (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  project_id BIGINT NOT NULL,
  class_id BIGINT NOT NULL,
  lab_id BIGINT NOT NULL,
  teacher_id BIGINT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  requirements TEXT,
  status TINYINT NOT NULL DEFAULT 0 COMMENT '0待开始 1进行中 2已完成 3已取消',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_schedule_lab_time(lab_id,start_time,end_time),
  KEY idx_schedule_teacher_time(teacher_id,start_time,end_time),
  CONSTRAINT fk_schedule_project FOREIGN KEY(project_id) REFERENCES experiment_project(id),
  CONSTRAINT fk_schedule_class FOREIGN KEY(class_id) REFERENCES lab_class(id),
  CONSTRAINT fk_schedule_lab FOREIGN KEY(lab_id) REFERENCES lab_room(id),
  CONSTRAINT fk_schedule_teacher FOREIGN KEY(teacher_id) REFERENCES `user`(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验教学安排';

CREATE TABLE IF NOT EXISTS experiment_attendance (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  schedule_id BIGINT NOT NULL,
  student_id BIGINT NOT NULL,
  status VARCHAR(20) NOT NULL COMMENT 'PRESENT ABSENT LATE LEAVE',
  check_in_time DATETIME,
  remark VARCHAR(255),
  operator_id BIGINT,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_attendance(schedule_id,student_id),
  CONSTRAINT fk_att_schedule FOREIGN KEY(schedule_id) REFERENCES experiment_schedule(id) ON DELETE CASCADE,
  CONSTRAINT fk_att_student FOREIGN KEY(student_id) REFERENCES `user`(id),
  CONSTRAINT fk_att_operator FOREIGN KEY(operator_id) REFERENCES `user`(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验考勤';

CREATE TABLE IF NOT EXISTS experiment_report (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  schedule_id BIGINT NOT NULL,
  student_id BIGINT NOT NULL,
  title VARCHAR(200) NOT NULL,
  content MEDIUMTEXT NOT NULL,
  attachment_url VARCHAR(500),
  status TINYINT NOT NULL DEFAULT 1 COMMENT '0草稿 1已提交 2已批改',
  submit_time DATETIME,
  score DECIMAL(5,2),
  feedback TEXT,
  grader_id BIGINT,
  grade_time DATETIME,
  UNIQUE KEY uk_report(schedule_id,student_id),
  KEY idx_report_grading(status,submit_time),
  CONSTRAINT fk_report_schedule FOREIGN KEY(schedule_id) REFERENCES experiment_schedule(id) ON DELETE CASCADE,
  CONSTRAINT fk_report_student FOREIGN KEY(student_id) REFERENCES `user`(id),
  CONSTRAINT fk_report_grader FOREIGN KEY(grader_id) REFERENCES `user`(id),
  CONSTRAINT ck_report_score CHECK(score IS NULL OR (score BETWEEN 0 AND 100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验报告及成绩';

CREATE TABLE IF NOT EXISTS supplier (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  supplier_code VARCHAR(50),
  supplier_name VARCHAR(150) NOT NULL,
  contact_name VARCHAR(50), phone VARCHAR(30), email VARCHAR(100), address VARCHAR(255),
  business_scope VARCHAR(255), rating DECIMAL(2,1) NOT NULL DEFAULT 5.0,
  status TINYINT NOT NULL DEFAULT 1,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_supplier_code(supplier_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备供应商';

CREATE TABLE IF NOT EXISTS maintenance_plan (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  device_id BIGINT NOT NULL,
  plan_name VARCHAR(150) NOT NULL,
  cycle_days INT NOT NULL DEFAULT 90,
  last_date DATE, next_date DATE NOT NULL,
  content TEXT, responsible_name VARCHAR(50),
  status TINYINT NOT NULL DEFAULT 1,
  creator_id BIGINT,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_maintenance_due(status,next_date),
  CONSTRAINT fk_plan_device FOREIGN KEY(device_id) REFERENCES device(id),
  CONSTRAINT fk_plan_creator FOREIGN KEY(creator_id) REFERENCES `user`(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备预防性维护计划';

CREATE TABLE IF NOT EXISTS maintenance_record (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  plan_id BIGINT NOT NULL,
  maintenance_time DATETIME NOT NULL,
  content TEXT, result VARCHAR(255) NOT NULL,
  cost DECIMAL(12,2) NOT NULL DEFAULT 0,
  operator_id BIGINT, attachment_url VARCHAR(500),
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_record_plan FOREIGN KEY(plan_id) REFERENCES maintenance_plan(id) ON DELETE CASCADE,
  CONSTRAINT fk_record_operator FOREIGN KEY(operator_id) REFERENCES `user`(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备维护记录';

INSERT IGNORE INTO lab_class(class_name,grade_year,major_name,department_name,counselor_id)
SELECT '计科2301',2023,'计算机科学与技术','计算机学院',id FROM `user` WHERE username='teacher001' LIMIT 1;
INSERT IGNORE INTO class_student(class_id,student_id)
SELECT c.id,u.id FROM lab_class c JOIN `user` u ON u.username IN('student','student001') WHERE c.class_name='计科2301' AND c.grade_year=2023;
INSERT IGNORE INTO experiment_project(project_code,project_name,course_name,hours,objectives,safety_notes,report_template,creator_id)
SELECT 'EXP-JAVA-01','Spring Boot 数据访问实验','Java Web开发',4,'掌握分层架构与数据库事务','实验前检查开发环境，禁止修改公共服务器配置','实验目的、环境、步骤、结果、分析与结论',id FROM `user` WHERE username='teacher001' LIMIT 1;
INSERT INTO experiment_schedule(project_id,class_id,lab_id,teacher_id,start_time,end_time,requirements,status)
SELECT p.id,c.id,l.id,u.id,DATE_ADD(NOW(),INTERVAL 2 DAY),DATE_ADD(DATE_ADD(NOW(),INTERVAL 2 DAY),INTERVAL 2 HOUR),'携带校园卡，提前完成预习',0
FROM experiment_project p JOIN lab_class c ON c.class_name='计科2301' JOIN lab_room l JOIN `user` u ON u.username='teacher001'
WHERE p.project_code='EXP-JAVA-01' AND NOT EXISTS(SELECT 1 FROM experiment_schedule s WHERE s.project_id=p.id AND s.class_id=c.id) LIMIT 1;
INSERT IGNORE INTO supplier(supplier_code,supplier_name,contact_name,phone,email,business_scope,rating)
VALUES('SUP-001','陕西科教仪器有限公司','张工','029-88886666','service@example.edu.cn','实验仪器供应、校准与维保',4.8);
INSERT INTO maintenance_plan(device_id,plan_name,cycle_days,next_date,content,responsible_name,creator_id)
SELECT d.id,CONCAT(d.device_name,'季度保养'),90,DATE_ADD(CURDATE(),INTERVAL 30 DAY),'清洁、校准、线缆和安全状态检查','实验室管理员',u.id
FROM device d JOIN `user` u ON u.username='admin' WHERE NOT EXISTS(SELECT 1 FROM maintenance_plan p WHERE p.device_id=d.id) LIMIT 3;
