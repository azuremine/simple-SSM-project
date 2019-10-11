<%--
  Created by IntelliJ IDEA.
  User: Vicent Lin
  Date: 2019/9/18
  Time: 16:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>员工列表</title>
    <%
        String appContext = request.getContextPath();
        String basePath = request.getScheme()+"://"+request.getServerName()+":"+ request.getServerPort() + appContext;
    %>
    <!-- Web路径：
    不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
    以/开头的相对路径，找资源，以服务器的路径为标准（http://localhost:3306），需要加上项目名
            http://localhost:3306/SSM1
            -->
    <!-- 引入jquery -->
    <script type="text/javascript" src="<%=basePath%>/static/js/jquery.min.js"></script>
    <!-- 引入样式 -->
    <link href="<%=basePath%>/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="<%=basePath%>/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<!-- 新增按钮模态框 -->
<div class="modal fade" id="empAddModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel1">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="inputEmpName" class="col-sm-2 control-label">EmpName：</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="inputEmpName" placeholder="EmpName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmail" class="col-sm-2 control-label">Email：</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="inputEmail" placeholder="Email@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender：</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="inputeMale" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="inputFemale" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="dept_add_select" class="col-sm-2 control-label">Department：</label>
                        <div class="col-sm-3">
                            <!-- 部门提交id即可-->
                            <select class="form-control" name="dId" id="dept_add_select"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<!-- 编辑按钮模态框 -->
<div class="modal fade" id="empUpdateModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel2">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="inputEmpName" class="col-sm-2 control-label">EmpName：</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmail" class="col-sm-2 control-label">Email：</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="updateEmail" placeholder="Email@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender：</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="updateMale" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="updateFemale" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="dept_update_select" class="col-sm-2 control-label">Department：</label>
                        <div class="col-sm-3">
                            <!-- 部门提交id即可-->
                            <select class="form-control" name="dId" id="dept_update_select"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<!-- 搭建显示页面 -->
<div class="container">
    <!-- 标题 -->
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <!-- 按钮 -->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <!-- 新增按钮 -->
            <button type="button" id="emp_add_model_btn" class="btn btn-info">新增</button>
            <button type="button" id="emp_delete_all_btn" class="btn btn-danger ">删除</button>
        </div>
    </div>
    <!-- 显示表格信息 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <td>
                        <input type="checkbox" id="check_all">
                    </td>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <!-- 分页信息 -->
    <div class="row">
        <!-- 分页文字信息 -->
        <div class="col-md-6" id="page_info_area"></div>
        <!-- 分页条 -->
        <div class="col-md-6" id="page_nav_area"></div>
    </div>
</div>

<div>
    <script type="text/javascript">

        //总记录数
        var totalPageRecoed;

        //当前页码
        var pageNum;

        //1、页面加载以后，直接去发送一个ajax请求，要到分页数据
        $(function () {
            //去首页
            to_page(1);
        });

        //跳转到第几页
        function to_page(pn) {
            $.ajax({
                url:"<%=basePath%>/emps",
                data:"pn=" + pn,
                type:"GET",
                success:function (result) {
                    //console.log(result);
                    //1、解析并显示员工信息
                    buid_emp_table(result);
                    //2、解析并显示分页数据
                    bulid_page_info(result);
                    //3、解析显示分页条数据
                    bulid_page_nav(result);
                }
            });
        }
        
        //解析显示员工信息
        function buid_emp_table(result) {
            //清除check_all的选中状态
            $("#check_all").prop("checked",false);
            //首先清空table表
            $("#emps_table tbody").empty();

            var emps = result.extend.pageInfo.list;
            $.each(emps,function (index,item) {
                var checkBoxTd = $("<td><input type='checkbox' class='check_item'></td>");
                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender=="M"?"男":"女");
                var emailTd = $("<td></td>").append(item.email);
                var deptNameTd = $("<td></td>").append(item.department.deptName);
                /**
                 * <button type="button" class="btn btn-info btn-sm">
                 <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                 编辑
                 </button>
                 * @type {jQuery|HTMLElement}
                 */
                var editBtn = $("<button></button>").addClass("btn btn-info btn-sm edit_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");

                //为编辑按钮添加一个自定义属性，来表示当前员工的id
                editBtn.attr("edit_id",item.empId);

                /**
                 * <button type="button" class="btn btn-danger btn-sm">
                 <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                 删除
                 </button>
                 * @type {jQuery}
                 */
                var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");

                //为删除按钮添加一个自定义属性，来表示当前员工的id
                delBtn.attr("del_id",item.empId);

                var btn_Td = $("<td></td>").append(editBtn).append(" ").append(delBtn);

                //append()方法执行完成以后还是返回原来的元素，即"<tr></tr>"
                $("<tr></tr>").append(checkBoxTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btn_Td)
                    .appendTo("#emps_table tbody");

            });
        }

        //解析显示分页信息
        function bulid_page_info(result) {
            //首先清空分页信息
            $("#page_info_area").empty();
            var info = result.extend.pageInfo;
            $("#page_info_area").append("当前第" + info.pageNum +"页，总共" + info.pages + "页，总共"+ info.total +" 记录");
            totalPageRecoed = info.total;
            pageNum = info.pageNum;
        }

        /**
         * <nav aria-label="Page navigation">
         <ul class="pagination">
            <li class="disabled"><a>首页</a></li>
         </ul>
         </nav>
         * @param result
         */
        //解析显示分页条，并添加点击相应
        function bulid_page_nav(result) {
            //首先清空分页导航条信息
            $("#page_nav_area").empty();
            var info = result.extend.pageInfo;

            var ul = $("<ul></ul>").addClass("pagination");

            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));

            if(info.hasPreviousPage == false){
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            }else {
                firstPageLi.click(function () {
                    to_page(1);
                });
                prePageLi.click(function () {
                    to_page(info.pageNum - 1);
                });
            }

            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
            var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));

            if(info.hasNextPage == false){
                nextPageLi.addClass("disabled");
                lastPageLi.addClass("disabled");
            }else {            nextPageLi.click(function () {
                to_page(info.pageNum + 1);
            });
                lastPageLi.click(function () {
                    to_page(info.pages);
                });
            }

            //添加首页和前一页的提示
            ul.append(firstPageLi).append(prePageLi);

            //遍历出来的页码号 1，2，3，4，5
            $.each(info.navigatepageNums,function (index,item) {
                var numLi = $("<li></li>").append($("<a></a>").append(item));
                if(info.pageNum == item){
                    numLi.addClass("active");
                }
                numLi.click(function () {
                    to_page(item);
                });
                ul.append(numLi);
            });

            //添加后一页和末页的提示
            ul.append(nextPageLi).append(lastPageLi);

            //把ul加入到nav元素中
            var nav = $("<nav></nav>")
                .append(ul)
                .appendTo("#page_nav_area");
        }

        //清空表单样式及内容
        function reset_form(ele){
            $(ele)[0].reset();
            $(ele).find("*").removeClass("has-success has-error");
            $(ele).find(".help-block").text("");
            $("#dept_add_select").empty();
        }

        //点击新增按钮弹出模态框
        $("#emp_add_model_btn").click(function () {

            //首先清空表单数据
            reset_form("#empAddModel form");

            //发送ajax请求查询到部门信息，显示在下拉列表中
            getDepts("#dept_add_select");
            //弹出模态框
            $('#empAddModel').modal({
                backdrop:"static"
            });
        });

        //查出部门信息并显示在下拉列表中
        function getDepts(ele) {
            $.ajax({
                url:"<%=basePath%>/getDepts",
                type:"GET",
                success:function (result) {
                    $.each(result.extend.depts,function () {
                        var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                        optionEle.appendTo(ele);
                    });
                }
            });
        }

        //校验用户名是否可用
        $("#inputEmpName").change(function () {
            //发送ajaxa请求校验用户名是否可用
            var empName = this.value;
            $.ajax({
                url:"<%=basePath%>/checkEmp",
                type:"POST",
                data:"empName=" + empName,
                success:function (result) {
                    //console.log(result);
                    if(result.code == 100){
                        show_validata_add_form("#inputEmpName","success","用户名可用");
                        $("#emp_save_btn").attr("ajax-value","success");
                    }else if(result.code == 200){
                        show_validata_add_form("#inputEmpName","error",result.extend.va_msg);
                        $("#emp_save_btn").attr("ajax-value","error");
                    }
                }
            })
        });

        //点击保存，保存员工
        $("#emp_save_btn").click(function () {
            //1、模态框中填写的表单数据提交给服务器进行保存
            //1、先对要提交给服务器的数据进行校验
            if(!validata_add_form()){
                return false;
            }
            //1、判断之前的ajax用户名校验是否成功，如果成功
            if($(this).attr("ajax-value") == "error"){
                return false;
            }
            //2、发送Ajax请求保存员工
            $.ajax({
                url:"<%=basePath%>/emp",
                type:"POST",
                data:$("#empAddModel form").serialize(),
                success:function (result) {
                    if(result.code == 100){
                        //员工保存成功
                        alert(result.msg);
                        //1、关闭模态框
                        $("#empAddModel").modal('hide');
                        //2、跳转到新增员工页面，显示刚才保存的员工
                        to_page(totalPageRecoed);
                    }else {
                        //显示失败信息
                        //console.log(result);
                        //有哪个字段的错误信息就显示哪个字段的
                        // }
                        if(undefined != result.extend.errorFields.email){
                            //显示邮箱错误信息
                            show_validata_add_form("#inputEmail","error",result.extend.errorFields.email);
                        }
                        if(undefined != result.extend.errorFields.empName){
                            //显示员工名字的错误信息
                            show_validata_add_form("#inputEmpName","error",result.extend.errorFields.empName);
                        }
                    }
                }
            });
        });

        //jQuery校验
        //校验表单数据方法
        function validata_add_form() {
            //1、检验姓名
            var empName = $("#inputEmpName").val();
            var regName = /(^[a-zA-Z0-9]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
            if(!regName.test(empName)) {
                //alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
                show_validata_add_form("#inputEmpName","error","用户名可以是2-5位中文或者6-16位英文和数字的组合");
                return false;
            }else {
                show_validata_add_form("#inputEmpName","success","");
            }
            //2、校验邮箱
            var email = $("#inputEmail").val();
            var regEmail = /^[a-z]([a-zA-Z0-9_]{5,20})@([a-z0-9]{1,10})([.]{1})([a-z]{2,4})$/;
            if(!regEmail.test(email)){
                //alert("邮箱格式不正确");
                show_validata_add_form("#inputEmail","error","邮箱格式不正确");
                return false;
            }else {
                show_validata_add_form("#inputEmail","success","");
            }
            return true;
        }
        
        function show_validata_add_form(ele,status,msg) {
            //清除当前元素的校验状态
            $(ele).parent().removeClass("has-success has-error");
            $(ele).next("span").text("");
            if("success" == status){
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);
            }else if("error" == status){
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);
            }
        }

        //1、在按钮创建之前就绑定了click,所以绑定不上，
        //1）可以在创建按钮的时候绑定，2）绑定点击.live()
        //jquery新版没有live，使用on进行代替
        //编辑按钮单击事件绑定
        $(document).on("click",".edit_btn",function () {

            //清空部门下拉选项
            $("#dept_update_select").empty();

            //1、查出部门信息，并显示部门列表
            getDepts("#dept_update_select");

            //2、查出员工信息，并显示员工信息
            getEmp($(this).attr("edit_id"));

            //弹出模态框
            $('#empUpdateModel').modal({
                backdrop:"static"
            });
        });

        //点击更新，更新员工信息
        $("#emp_update_btn").click(function () {
            //1、前端校验邮箱格式
            var email = $("#updateEmail").val();
            var regEmail = /^[a-z]([a-zA-Z0-9_]{5,20})@([a-z0-9]{1,10})([.]{1})([a-z]{2,4})$/;
            if(!regEmail.test(email)){
                show_validata_add_form("#updateEmail","error","邮箱格式不正确");
                return false;
            }else {
                show_validata_add_form("#updateEmail","success","");
            }
            //2、发送ajax请求更新员工信息
            $.ajax({
                url:"<%=basePath%>/emp/" + $(this).attr("edit_id"),
                type:"PUT",
                data:$("#empUpdateModel form").serialize() ,
                success:function (resule) {
                    if(resule.code == 100){
                        //处理成功
                        //1、关闭模态框
                        $("#empUpdateModel").modal('hide');
                        //2、显示更新的数据页面
                        to_page(pageNum);
                    }else{
                        //2、处理失败
                    }
                }
            });
        });

        //删除按钮单击事件绑定
        $(document).on("click",".delete_btn",function () {
            var empName = $(this).parents("tr").find("td:eq(2)").text();
            //1、弹出是否删除对话框
            if(confirm("确认删除【" + empName + "】员工吗？")){
                //确认发送ajax请求删除员工
                $.ajax({
                    url:"<%=basePath%>/emp/" + $(this).attr("del_id"),
                    type:"DELETE",
                    success:function (result) {
                        if(result.code == 100){
                            alert("删除成功！");
                            to_page(pageNum);
                        }else {
                            alert("删除失败！");
                        }
                    }
                });
            }
        });

        //获得某个员工的信息
        function getEmp(id){
            $.ajax({
                url:"<%=basePath%>/emp/" + id,
                type:"GET",
                success:function (result) {
                    setEmpInfo(result);
                }
            });
        }

        //将获得的员工信息填充到编辑模态框中
        function setEmpInfo(result){
            var empInfo = result.extend.emp;
            //填充EmpName
            $("#empName_update_static").text(empInfo.empName);
            //填充邮箱
            $("#updateEmail").val(empInfo.email);
            //填充性别
            $("#empUpdateModel input[name = gender]").val([empInfo.gender]);
            //选择部门
            $("#empUpdateModel select").val([empInfo.dId]);
            //把员工的id绑定到更新按钮
            $("#emp_update_btn").attr("edit_id",empInfo.empId);
        }

        //完成全选/全不选功能
        $("#check_all").click(function () {
            //attr获取checked是undefined
            //我们这些dom原生的属性；attr获取自定义属性的值，prop用来获取原生属性
            //prop修改和读取dom原生属性的值
            $(".check_item").prop("checked",$(this).prop("checked"));
        });

        //为每个checkbox添加单击事件，check_item为后来动态添加的元素
        $(document).on("click",".check_item",function () {
            //判断当前选中的元素是不是5个
            var flag = $(".check_item:checked").length==$(".check_item").length;
            $("#check_all").prop("checked",flag);
        });

        //点击多项删除按钮
        $("#emp_delete_all_btn").click(function () {
            //1、获取选中项的empName
            var empNames = "";
            $.each($(".check_item:checked"),function () {
                empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
            });
            empNames = empNames.substring(0,empNames.length-1);
            if(confirm("确认要删除【"+ empNames + "】这些员工吗？")){
                //发送ajax请求，批量删除员工
                var empIds = "";
                $.each($(".check_item:checked"),function () {
                    empIds += $(this).parents("tr").find("td:eq(1)").text() + ",";
                });
                empIds = empIds.substring(0,empIds.length-1);
                $.ajax({
                    url:"<%=basePath%>/emp/" + empIds,
                    type:"DELETE",
                    success:function (result) {
                        if(result.code == 100){
                            alert("批量删除成功！");
                            to_page(pageNum);
                        }else {
                            alert("删除失败！");
                        }
                    }
                });
            }
        });

    </script>
</div>

</body>
</html>
