package com.lab.reserve.service;

import com.lab.reserve.common.AuthContext;
import com.lab.reserve.entity.OperationLog;
import com.lab.reserve.mapper.OperationLogMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OperationLogService {

    @Autowired
    private OperationLogMapper operationLogMapper;

    public void log(String module, String action, String detail) {
        try {
            OperationLog log = new OperationLog();
            log.setUserId(AuthContext.getUserId());
            log.setUsername(AuthContext.getUsername());
            log.setModule(module);
            log.setAction(action);
            log.setDetail(detail);
            operationLogMapper.insert(log);
        } catch (Exception e) {
            // 日志记录失败不影响主流程
        }
    }
}
