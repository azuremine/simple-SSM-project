package com.lin.service.impl;

import com.lin.dao.EmployeeMapper;
import com.lin.domain.Employee;
import com.lin.domain.EmployeeExample;
import com.lin.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 业务层调用持久层
 */

@Service("employeeService")
public class EmployeeServiceImpl implements EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;

    @Autowired
    private EmployeeExample example;

    /**
     * 查询所有员工
     * @return
     */
    @Override
    public List<Employee> getAll() {
        //Service层调用Dao层
        return employeeMapper.selectByExampleWithDept(null);
    }

    /**
     * 新增员工
     * @param employee
     * @return
     */
    @Override
    public int saveEmp(Employee employee) {
        return employeeMapper.insertSelective(employee);
    }

    /**
     * 检验用户名是否可用
     * @param empName
     * @return  返回true ：代表可用
     *          返回false ：代表不可用
     */
    @Override
    public long checkEmp(String empName) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(example);
        return count;
    }

    /**
     * 按照员工id查询员工
     * @return
     */
    @Override
    public Employee getOne(Integer id) {
        return employeeMapper.selectByPrimaryKey(id);
    }

    /**
     * 修改员工信息
     * @param employee
     * @return
     */
    @Override
    public int updateEmp(Employee employee) {
        return employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /**
     * 删除单个员工
     * @param empId
     * @return
     */
    @Override
    public int deleteEmp(Integer empId) {
        return employeeMapper.deleteByPrimaryKey(empId);
    }

    @Override
    public void deleteBatch(List<Integer> ids) {
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpIdIn(ids);
        employeeMapper.deleteByExample(example);
    }
}
