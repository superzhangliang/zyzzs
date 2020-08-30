package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.InputsManager;
import com.gdcy.zyzzs.pojo.NumChangeRecord;

public interface InputsManagerService {
    int deleteByPrimaryKey(Long id);

    int insert(InputsManager record);

    int insertSelective(InputsManager record);

    InputsManager selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(InputsManager record);

    int updateByPrimaryKey(InputsManager record);

	int countByEntity(InputsManager record);

	List<InputsManager> selectByEntity(InputsManager record);

	List<NumChangeRecord> selectNumChangeRecord(NumChangeRecord record);

	Integer countNumChangeRecord(NumChangeRecord record);
    

}
