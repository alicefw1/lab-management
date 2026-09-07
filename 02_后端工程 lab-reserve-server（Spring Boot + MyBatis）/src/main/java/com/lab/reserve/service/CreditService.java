package com.lab.reserve.service;

import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.CreditLog;
import com.lab.reserve.entity.User;
import com.lab.reserve.mapper.CreditLogMapper;
import com.lab.reserve.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CreditService {

    public static final int DEFAULT_SCORE = 100;
    public static final int MIN_BORROW_SCORE = 60;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private CreditLogMapper creditLogMapper;

    @Transactional(rollbackFor = Exception.class)
    public void changeScore(Long userId, String changeType, int scoreChange, String reason) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        int current = user.getCreditScore() == null ? DEFAULT_SCORE : user.getCreditScore();
        int newScore = Math.max(0, current + scoreChange);
        userMapper.updateCreditScore(userId, newScore);

        CreditLog log = new CreditLog();
        log.setUserId(userId);
        log.setChangeType(changeType);
        log.setScoreChange(scoreChange);
        log.setReason(reason);
        creditLogMapper.insert(log);
    }

    public void checkBorrowEligibility(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        int score = user.getCreditScore() == null ? DEFAULT_SCORE : user.getCreditScore();
        if (score < MIN_BORROW_SCORE) {
            throw new BusinessException("诚信分不足（当前 " + score + " 分，需 ≥ " + MIN_BORROW_SCORE + " 分），暂时无法借用设备");
        }
    }

    public int getScore(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) return DEFAULT_SCORE;
        return user.getCreditScore() == null ? DEFAULT_SCORE : user.getCreditScore();
    }
}
