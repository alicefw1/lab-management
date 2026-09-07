package com.lab.reserve.controller;

import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.Favorite;
import com.lab.reserve.mapper.FavoriteMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/favorites")
public class FavoriteController {

    @Autowired
    private FavoriteMapper favoriteMapper;

    @GetMapping
    public Result<List<Favorite>> myFavorites(@RequestParam(required = false) String targetType) {
        return Result.ok(favoriteMapper.selectByUser(AuthContext.getUserId(), targetType));
    }

    @PostMapping
    public Result<?> add(@RequestBody Favorite favorite) {
        if (favorite.getTargetType() == null || favorite.getTargetId() == null) {
            throw new BusinessException("收藏目标不能为空");
        }
        Long userId = AuthContext.getUserId();
        int count = favoriteMapper.countByUserTarget(userId, favorite.getTargetType(), favorite.getTargetId());
        if (count > 0) {
            return Result.ok("已收藏", null);
        }
        favorite.setUserId(userId);
        favoriteMapper.insert(favorite);
        return Result.ok("已收藏", null);
    }

    @DeleteMapping("/{targetType}/{targetId}")
    public Result<?> remove(@PathVariable String targetType, @PathVariable Long targetId) {
        favoriteMapper.delete(AuthContext.getUserId(), targetType, targetId);
        return Result.ok();
    }

    @GetMapping("/check/{targetType}/{targetId}")
    public Result<Boolean> check(@PathVariable String targetType, @PathVariable Long targetId) {
        int count = favoriteMapper.countByUserTarget(AuthContext.getUserId(), targetType, targetId);
        return Result.ok(count > 0);
    }
}
