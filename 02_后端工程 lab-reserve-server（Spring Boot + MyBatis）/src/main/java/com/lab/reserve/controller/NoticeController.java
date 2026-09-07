package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.Notice;
import com.lab.reserve.mapper.NoticeMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/notices")
public class NoticeController {

    @Autowired
    private NoticeMapper noticeMapper;

    @GetMapping
    public Result<List<Notice>> page() {
        return Result.ok(noticeMapper.selectList());
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping
    public Result<?> save(@RequestBody Notice notice) {
        if (notice.getTitle() == null || notice.getTitle().trim().isEmpty()) {
            throw new BusinessException("公告标题不能为空");
        }
        if (notice.getContent() == null || notice.getContent().trim().isEmpty()) {
            throw new BusinessException("公告内容不能为空");
        }
        notice.setPublishUserId(AuthContext.getUserId());
        notice.setPublishTime(LocalDateTime.now());
        if (notice.getStatus() == null) notice.setStatus(1);
        noticeMapper.insert(notice);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        noticeMapper.deleteById(id);
        return Result.ok();
    }
}
