package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.Feedback;
import com.lab.reserve.mapper.FeedbackMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/feedback")
public class FeedbackController {

    @Autowired
    private FeedbackMapper feedbackMapper;

    @GetMapping
    public Result<List<Feedback>> list(@RequestParam(required = false) Integer status) {
        String role = AuthContext.getRoleCode();
        Long userId = null;
        if ("STUDENT".equals(role) || "TEACHER".equals(role)) {
            userId = AuthContext.getUserId();
        }
        return Result.ok(feedbackMapper.selectList(status, userId));
    }

    @PostMapping
    public Result<?> submit(@RequestBody Feedback feedback) {
        if (feedback.getTitle() == null || feedback.getTitle().trim().isEmpty()) {
            throw new BusinessException("反馈标题不能为空");
        }
        if (feedback.getContent() == null || feedback.getContent().trim().isEmpty()) {
            throw new BusinessException("反馈内容不能为空");
        }
        feedback.setUserId(AuthContext.getUserId());
        feedback.setStatus(0);
        feedbackMapper.insert(feedback);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/reply")
    public Result<?> reply(@RequestBody Feedback feedback) {
        if (feedback.getId() == null) throw new BusinessException("反馈ID不能为空");
        Feedback exist = feedbackMapper.selectById(feedback.getId());
        if (exist == null) throw new BusinessException("反馈不存在");
        exist.setReply(feedback.getReply());
        exist.setReplyUserId(AuthContext.getUserId());
        exist.setReplyTime(LocalDateTime.now());
        exist.setStatus(1);
        feedbackMapper.updateById(exist);
        return Result.ok();
    }
}
