package com.lin.service.impl;

import com.lin.dao.DepartmentMapper;
import com.lin.domain.Department;
import com.lin.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("departmentService")
public class DepartmentServiceImpl implements DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    /**
     * 查询所有部门信息
     * @return
     */
    @Override
    public List<Department> getAllDepts() {
        //service调用dao层
        return departmentMapper.selectByExample(null);
    }
}
