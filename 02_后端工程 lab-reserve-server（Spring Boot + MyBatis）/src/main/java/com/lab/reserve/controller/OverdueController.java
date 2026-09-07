package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.entity.BorrowApply;
import com.lab.reserve.entity.BorrowRecord;
import com.lab.reserve.mapper.BorrowApplyMapper;
import com.lab.reserve.mapper.BorrowRecordMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/overdue")
@RequireRole({"LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
public class OverdueController {

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @Autowired
    private BorrowApplyMapper borrowApplyMapper;

    @PostMapping("/refresh")
    public Result<Map<String, Object>> refresh() {
        List<BorrowRecord> records = borrowRecordMapper.selectList(1, null);
        LocalDateTime now = LocalDateTime.now();
        int count = 0;
        for (BorrowRecord record : records) {
            BorrowApply apply = borrowApplyMapper.selectById(record.getApplyId());
            if (apply != null && apply.getExpectedReturnTime() != null
                    && now.isAfter(apply.getExpectedReturnTime())) {
                record.setStatus(3);
                borrowRecordMapper.updateById(record);
                count++;
            }
        }
        Map<String, Object> data = new HashMap<>();
        data.put("updated", count);
        return Result.ok(data);
    }

    @GetMapping("/records")
    public Result<List<BorrowRecord>> records() {
        return Result.ok(borrowRecordMapper.selectList(3, null));
    }
}
