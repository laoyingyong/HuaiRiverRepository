/** 左侧下拉菜单控制 **/

$(".leftsidebar_box dt img").attr("src", "img/select_xl01.png");
$(function ()//入口函数
{
    $(".leftsidebar_box dd").hide(); //后代选择器，隐藏leftsidebar_box后代的dd元素
    /**系统默认显示第一行菜单**/
    //$(".first_dt").parent().find('dd').show(); // 默认显示第一行菜单
    //$(".first_dt img").attr("src", "img/select_xl.png"); //当前焦点一级菜单项图标
    //$(".first_dt").css({ "background-color": "#1f6b75" }); // 焦点一级菜单项的样式
    /**一级菜单项单击事件**/
    $(".leftsidebar_box dt").click(function ()
    {
        //判断当前一级菜单下的二级菜单项是否隐藏
        if ($(this).parent().find('dd').is(":hidden"))
        {
            $(this).parent().find('dd').slideToggle(); //滑动方式展开子菜单
            $(this).css({ "background-color": "#1f6b75" }); //焦点一级菜单项背景颜色             
            $(this).parent().find('img').attr("src", "img/select_xl.png"); //当前焦点一级菜单项图标
        }
        else
        {
            $(this).parent().find('dd').slideUp(); //滑动方式隐藏子菜单
            $(this).css({ "background-color": "#339999" }); //非焦点一级菜单项背景颜色
            $(this).parent().find('img').attr("src", "img/select_xl01.png"); //非焦点一级菜单项图标
        }
    });


    /**二级菜单项单击事件**/
    $(".leftsidebar_box dd").click(function ()
    {
        $(".leftsidebar_box dd").css({ "background-color": "#4c4e5a", "color": "#f5f5f5" }); //二级菜单项背景颜色
        $(this).css({ "background-color": "#38393F", "color": "#a9a9a9" }); //选中项二级菜单项背景颜色
    });


});








