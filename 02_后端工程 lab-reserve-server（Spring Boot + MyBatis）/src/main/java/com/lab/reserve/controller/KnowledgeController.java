package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.Knowledge;
import com.lab.reserve.mapper.KnowledgeMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/knowledge")
public class KnowledgeController {

    @Autowired
    private KnowledgeMapper knowledgeMapper;

    @GetMapping
    public Result<List<Knowledge>> list(@RequestParam(required = false) String category,
                                         @RequestParam(required = false) String keyword) {
        return Result.ok(knowledgeMapper.selectList(category, keyword));
    }

    @GetMapping("/{id}")
    public Result<Knowledge> get(@PathVariable Long id) {
        Knowledge k = knowledgeMapper.selectById(id);
        if (k == null) throw new BusinessException("知识不存在");
        knowledgeMapper.incrementView(id);
        k.setViewCount(k.getViewCount() + 1);
        return Result.ok(k);
    }

    @RequireRole({"ADMIN", "LAB_ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping
    public Result<?> save(@RequestBody Knowledge knowledge) {
        if (knowledge.getTitle() == null || knowledge.getTitle().trim().isEmpty()) {
            throw new BusinessException("标题不能为空");
        }
        if (knowledge.getViewCount() == null) knowledge.setViewCount(0);
        knowledgeMapper.insert(knowledge);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        knowledgeMapper.deleteById(id);
        return Result.ok();
    }
}
