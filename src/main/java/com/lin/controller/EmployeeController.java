package com.lin.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.lin.domain.Employee;
import com.lin.service.EmployeeService;
import com.lin.utils.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工CRUD请求
 */
@Controller
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;
    
    /**
     * 查询所有员工数据（分页），表现层调用业务层
     * @return
     */
    @RequestMapping("/empsWithModel")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn, Model model){
        //表现层调用业务层
        //这不是一个分页查询
        //一如PageHelper分页插件
        //在查询之前只需要调用,传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
        //startPage后跟的这个查询就是分页查询
        List<Employee> emps = employeeService.getAll();
        //用PageInfo对结果进行包装,只需将PageInfo交给页面就行了
        //页面封装了详细的分页信息，包括有我们查询出来的结果,传入连续显示的页数
        PageInfo page = new PageInfo(emps,5);
        model.addAttribute("pageInfo", page);
        return "list";
    }


    @RequestMapping("/empsWithJson1")
    @ResponseBody
    public PageInfo getEmpsWithJson1(@RequestParam(value = "pn",defaultValue = "1")Integer pn){
        //表现层调用业务层
        //这不是一个分页查询
        //一如PageHelper分页插件
        //在查询之前只需要调用,传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
        //startPage后跟的这个查询就是分页查询
        List<Employee> emps = employeeService.getAll();
        //用PageInfo对结果进行包装,只需将PageInfo交给页面就行了
        //页面封装了详细的分页信息，包括有我们查询出来的结果,传入连续显示的页数
        PageInfo page = new PageInfo(emps,5);
        return page;
    }

    /**
     * 需要导入json包
     * @param pn
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Message getEmpsWithJson2(@RequestParam(value = "pn",defaultValue = "1")Integer pn){
        //表现层调用业务层
        //这不是一个分页查询
        //一如PageHelper分页插件
        //在查询之前只需要调用,传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
        //startPage后跟的这个查询就是分页查询
        List<Employee> emps = employeeService.getAll();
        //用PageInfo对结果进行包装,只需将PageInfo交给页面就行了
        //页面封装了详细的分页信息，包括有我们查询出来的结果,传入连续显示的页数：5页
        PageInfo page = new PageInfo(emps,5);
        return Message.success().add("pageInfo",page);
    }


    /**
     * 员工保存
     * 1、后端校验，要支持JSR303校验
     * 2、需要导入Hibernate-validator
     * @param emp
     * @return
     */
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Message saveEmp(@Valid Employee emp, BindingResult result){
        if(result.hasErrors()){
            //校验失败，应该返回失败，在模态框中显示校验失败的信息
            Map<String,Object> map = new HashMap<String,Object>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors){
                System.out.print("错误的字段名：" + fieldError.getField());
                System.out.print("错误信息：" + fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Message.fail().add("errorFields",map);
        }else {
            employeeService.saveEmp(emp);
            return Message.success();
        }
    }


    /**
     * 后端校验
     * 检查用户名是否可用
     * @param empName
     * @return
     */
    @RequestMapping("/checkEmp")
    @ResponseBody
    public Message checkEmp(@RequestParam("empName") String empName){

        //先判断用户名是否合法是合法的表达式,java里的正则表达式没有\ \
        String regEmpName = "(^[a-zA-Z0-9]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
        if(!empName.matches(regEmpName)){
            return Message.fail().add("va_msg","用户名必须是6-16位数字和字母的组合或者2-5位中文");
        }
        //数据库用户名重复校验
        long count= employeeService.checkEmp(empName);
        if(count == 0){
            return Message.success();
        }else {
            return Message.fail().add("va_msg","用户名不可用");
        }
    }

    /**
     * 获取员工信息
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Message getEmp(@PathVariable("id") Integer id){
        Employee emp = employeeService.getOne(id);
        return Message.success().add("emp",emp);
    }

    /**
     * 更新员工信息
     * @param employee
     * @return
     *
     * 原因：
     * Tomcat服务器：
     *      1、请求体中的数据，封装成一个map
     *      2、request.getParameter("empName")就会从这个map中取值
     *      3、SpringMVC封装POJO对象的时候
     *              会把POKO中的每个属性的值，request.getParameter("email")拿到;
     * AJAX发送PUT请求引发的血案:
     *      PUT请求：请求体中的数据，request.getParamter("empName")拿不到，
     *      Tomacat一看是PUT请求不会封装请求体中的数据为Map，只有POST形式的请求才封装请求体
     *
     * 解决方案：
     * 要能支持直接发送PUT之类的请求还要封装请求体中的数据
     * 1、配置上HttpPutFormContentFilter：
     * 2、他的作用：将请求提中的数据解析包装成一个map
     * 3、request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据
     */
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Message updateEmp(Employee employee){
        employeeService.updateEmp(employee);
        return Message.success();
    }

    /**
     * 单个批量二合一。删除员工
     * 批量删除：1，2，3
     * 单个删除：1
     * @param ids
     * @return
     */
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    @ResponseBody
    public Message deleteEmp(@PathVariable("ids") String ids){
        List<Integer> del_ids = new ArrayList<Integer>();
        if (ids.contains(",")) {
            //批量删除
            String[] str_ids = ids.split(",");
            //组装id的集合
            for(String id : str_ids){
                 del_ids.add(Integer.parseInt(id));
            }
            employeeService.deleteBatch(del_ids);
        }else {
            //单个删除
            employeeService.deleteEmp(Integer.parseInt(ids));
        }
        return Message.success();
    }
}
