-- 后端查询优化索引脚本
-- 执行说明：请在已导入基础建表脚本后执行；同一数据库中不要重复执行同名索引。

ALTER TABLE borrow_apply ADD INDEX idx_borrow_apply_user_status (user_id, status);
ALTER TABLE borrow_apply ADD INDEX idx_borrow_apply_device_status (device_id, status);
ALTER TABLE borrow_apply ADD INDEX idx_borrow_apply_apply_time (apply_time);

ALTER TABLE borrow_record ADD INDEX idx_borrow_record_user_status (user_id, status);
ALTER TABLE borrow_record ADD INDEX idx_borrow_record_device_status (device_id, status);
ALTER TABLE borrow_record ADD INDEX idx_borrow_record_borrow_time (borrow_time);

ALTER TABLE repair_record ADD INDEX idx_repair_record_user_status (user_id, status);
ALTER TABLE repair_record ADD INDEX idx_repair_record_device_status (device_id, status);
ALTER TABLE repair_record ADD INDEX idx_repair_record_report_time (report_time);

ALTER TABLE device ADD INDEX idx_device_category_status (category_id, status);
ALTER TABLE device ADD INDEX idx_device_name_no (name, device_no);
