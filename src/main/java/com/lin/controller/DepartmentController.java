package com.lin.controller;

import com.lin.domain.Department;
import com.lin.service.DepartmentService;
import com.lin.utils.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理和部门有关的请求
 */
@Controller
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    /**
     * 查询所有部门
     * @return
     */
    @RequestMapping("/getDepts")
    @ResponseBody
    public Message getDeptsWithJson(){

        //查出的所有部门信息
        List<Department> allDepts = departmentService.getAllDepts();
        return Message.success().add("depts",allDepts);
    }
}
