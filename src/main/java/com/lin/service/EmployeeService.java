package com.lin.service;

import com.lin.domain.Employee;

import java.util.List;

public interface EmployeeService {

    //查询所有员工
    List<Employee> getAll();

    //新增员工
    int saveEmp(Employee employee);

    //检验用户名是否可用
    long checkEmp(String empName);

    //按照员工id查询一个员工
    Employee getOne(Integer id);

    //修改员工信息
    int updateEmp(Employee employee);

    //删除单个员工
    int deleteEmp(Integer empId);

    //批量删除员工
    void deleteBatch(List<Integer> ids);
}
