package com.lab.reserve.mapper;

import com.lab.reserve.entity.Notice;

import java.util.List;

public interface NoticeMapper {
    List<Notice> selectList();

    Notice selectById(Long id);

    int insert(Notice notice);

    int updateById(Notice notice);

    int deleteById(Long id);
}
