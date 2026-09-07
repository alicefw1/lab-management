package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.dto.ApproveBorrowRequest;
import com.lab.reserve.dto.ReturnDeviceRequest;
import com.lab.reserve.entity.BorrowApply;
import com.lab.reserve.entity.BorrowRecord;
import com.lab.reserve.mapper.BorrowApplyMapper;
import com.lab.reserve.mapper.BorrowRecordMapper;
import com.lab.reserve.service.BorrowBusinessService;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/borrow")
public class BorrowController {

    @Autowired
    private BorrowApplyMapper borrowApplyMapper;

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @Autowired
    private BorrowBusinessService borrowBusinessService;

    @PostMapping("/apply")
    public Result<?> apply(@RequestBody BorrowApply apply) {
        borrowBusinessService.apply(apply);
        return Result.ok();
    }

    @GetMapping("/applies")
    public Result<List<BorrowApply>> applies(@RequestParam(required = false) Integer status,
                                             @RequestParam(required = false) Long userId) {
        if (isPersonalRole()) {
            userId = AuthContext.getUserId();
        }
        return Result.ok(borrowApplyMapper.selectList(status, userId));
    }

    @RequireRole({"LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/approve")
    public Result<?> approve(@RequestBody ApproveBorrowRequest request) {
        borrowBusinessService.approve(request);
        return Result.ok();
    }

    @GetMapping("/records")
    public Result<List<BorrowRecord>> records(@RequestParam(required = false) Integer status,
                                              @RequestParam(required = false) Long userId) {
        if (isPersonalRole()) {
            userId = AuthContext.getUserId();
        }
        return Result.ok(borrowRecordMapper.selectList(status, userId));
    }

    @RequireRole({"LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/return")
    public Result<?> returnDevice(@RequestBody ReturnDeviceRequest request) {
        borrowBusinessService.returnDevice(request);
        return Result.ok();
    }

    @RequireRole({"LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/loss")
    public Result<?> reportLoss(@RequestBody com.lab.reserve.dto.DeviceLossRequest request) {
        if (request == null || request.getRecordId() == null) {
            throw new BusinessException("借用记录ID不能为空");
        }
        borrowBusinessService.reportLoss(request.getRecordId(), request.getReason());
        return Result.ok();
    }

    private boolean isPersonalRole() {
        String role = AuthContext.getRoleCode();
        return "STUDENT".equals(role) || "TEACHER".equals(role);
    }
}
