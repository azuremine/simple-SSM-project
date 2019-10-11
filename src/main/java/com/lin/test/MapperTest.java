package com.lin.test;

import com.lin.dao.DepartmentMapper;
import com.lin.dao.EmployeeMapper;
import com.lin.domain.Department;
import com.lin.domain.Employee;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.UUID;


/**
 * 测试dao层的工作
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations="classpath:applicationContext.xml")
public class MapperTest {

    @Autowired
    private EmployeeMapper employeeMapper;

    @Autowired
    private DepartmentMapper departmentMapper;

    @Autowired
    private SqlSession sqlSession;

    @Test
    public void testCRUD(){

//        //1、创建SpringIOC容器
//        ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
//        //2.从容器中获取mapper
//        DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
//        System.out.println(employeeMapper);
//        //3、部门插入
//        departmentMapper.insertSelective(new Department(null,"开发部"));
//        departmentMapper.insertSelective(new Department(null,"测试部"));
        //4、生成员工数据
//        employeeMapper.insertSelective(new Employee(null,"Jerry","M","Jerry@qq.com",1));
//        employeeMapper.insertSelective(new Employee(null,"Vicent","M","Vicent@qq.com",2));

        //5、批量插入多个员工，批量，使用可以执行批量操作的SqlSession
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for(int i = 0; i< 100 ; i++ ){
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null,uid,"M",uid+"@qq.com",1));
        }
        System.out.println("批量完成！");
//        List<Employee> employees = employeeMapper.selectByExampleWithDept(null);
//        for(Employee employee : employees){
//            System.out.println(employee.getEmpId() + " " + employee.getEmpName());
//        }
    }
}
