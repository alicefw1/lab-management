package com.lab.reserve.controller;

import com.lab.reserve.common.AuthContext;
import com.lab.reserve.entity.BorrowApply;
import com.lab.reserve.entity.BorrowRecord;
import com.lab.reserve.entity.RepairRecord;
import com.lab.reserve.mapper.BorrowApplyMapper;
import com.lab.reserve.mapper.BorrowRecordMapper;
import com.lab.reserve.mapper.RepairRecordMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/my")
public class MyRecordController {

    @Autowired
    private BorrowApplyMapper borrowApplyMapper;

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @Autowired
    private RepairRecordMapper repairRecordMapper;

    @GetMapping("/applies")
    public Result<List<BorrowApply>> myApplies(@RequestParam(required = false) Integer status) {
        return Result.ok(borrowApplyMapper.selectList(status, AuthContext.getUserId()));
    }

    @GetMapping("/records")
    public Result<List<BorrowRecord>> myRecords(@RequestParam(required = false) Integer status) {
        return Result.ok(borrowRecordMapper.selectList(status, AuthContext.getUserId()));
    }

    @GetMapping("/repairs")
    public Result<List<RepairRecord>> myRepairs(@RequestParam(required = false) Integer status) {
        return Result.ok(repairRecordMapper.selectList(status, AuthContext.getUserId()));
    }
}
