package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.entity.OperationLog;
import com.lab.reserve.mapper.OperationLogMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/logs")
@RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
public class OperationLogController {

    @Autowired
    private OperationLogMapper operationLogMapper;

    @GetMapping
    public Result<List<OperationLog>> list(@RequestParam(required = false) String module,
                                            @RequestParam(required = false) String keyword,
                                            @RequestParam(required = false) Integer limit) {
        if (limit == null || limit <= 0) limit = 100;
        return Result.ok(operationLogMapper.selectList(module, keyword, limit));
    }
}
