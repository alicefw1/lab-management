package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.dto.CreditChangeRequest;
import com.lab.reserve.entity.CreditLog;
import com.lab.reserve.mapper.CreditLogMapper;
import com.lab.reserve.service.CreditService;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/credit")
public class CreditController {

    @Autowired
    private CreditService creditService;

    @Autowired
    private CreditLogMapper creditLogMapper;

    // 我的诚信分
    @GetMapping("/my")
    public Result<Map<String, Object>> myScore() {
        Long userId = AuthContext.getUserId();
        Map<String, Object> data = new HashMap<>();
        data.put("score", creditService.getScore(userId));
        data.put("minBorrowScore", CreditService.MIN_BORROW_SCORE);
        data.put("logs", creditLogMapper.selectList(userId));
        return Result.ok(data);
    }

    // 管理员查看全部诚信记录
    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @GetMapping("/logs")
    public Result<List<CreditLog>> logs(@RequestParam(required = false) Long userId) {
        return Result.ok(creditLogMapper.selectList(userId));
    }

    // 管理员手动调整诚信分
    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/adjust")
    public Result<?> adjust(@RequestBody CreditChangeRequest request) {
        if (request.getUserId() == null) throw new BusinessException("用户ID不能为空");
        if (request.getScoreChange() == null || request.getScoreChange() == 0) {
            throw new BusinessException("分数变化不能为0");
        }
        String changeType = request.getChangeType();
        if (changeType == null || changeType.isEmpty()) {
            changeType = request.getScoreChange() > 0 ? "加分" : "扣分";
        }
        creditService.changeScore(request.getUserId(), changeType, request.getScoreChange(), request.getReason());
        return Result.ok();
    }
}
