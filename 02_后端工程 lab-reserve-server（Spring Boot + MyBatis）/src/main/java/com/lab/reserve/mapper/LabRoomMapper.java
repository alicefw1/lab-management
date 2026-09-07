package com.lab.reserve.mapper;

import com.lab.reserve.entity.LabRoom;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LabRoomMapper {
    List<LabRoom> selectList(@Param("keyword") String keyword);

    LabRoom selectById(Long id);

    int insert(LabRoom labRoom);

    int updateById(LabRoom labRoom);

    int deleteById(Long id);

    int countAll();
}
