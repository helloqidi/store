// Put your application scripts here

/*
 *定义module
 * */
var store={
  visitor: {},
  redirect: function(url,delay) {
    setTimeout(function(){
        window.location = url;
        },delay);
  }

};//store end


/*
 * 初始化
 * */
store.initial=function(){
  //placeholder属性插件
  $('input, textarea').placeholder();
  store.versionIEWarn();
  store.listToggleLink();
  store.loading();
};

/*loading进度*/
store.loading = function(show){
    $("#loading").ajaxStart(function(){
        $(this).show();
    }).ajaxStop(function(){
        $(this).hide();
    });
};

/*
 * 验证注册表单
 * */
store.validateRegisterForm=function(){
  /* 表单验证 */
  $("#register-form").validate({
    rules:{
      "user[email]":{
        required: true,
        email: true,
        minlength: 3,
        maxlength: 100
      },
      "user[password]":{
        required: true,
        minlength: 4,
        maxlength: 40
      },
      "user[password_confirmation]":{
        required: true,
        equalTo: "#user_password"
      },
      "user[name]":{
        required: true,
        minlength: 2,
        maxlength: 100        
      }
    },
    messages: {
      "user[email]":{
        required: "邮箱不能为空",
        email: "邮箱格式不正确",
        minlength: "最少3个字符",
        maxlength: "最多100个字符"
      },
      "user[password]":{
        required: "密码不能为空",
        minlength: "最少4个字符",
        maxlength: "最多40个字符"
      },
      "user[password_confirmation]":{
        required: "确认密码不能为空",
        equalTo: "两次输入的密码不一致"
      },
      "user[name]":{
        required: "昵称不能为空",
        minlength: "最少2个字符",
        maxlength: "最多100个字符"
      }
    },
    errorClass: "help-inline store-text-error",
    submitHandler: function(form) {
      $(form).ajaxSubmit({});
    }
  });
};


/*
 * 显示头部的alert info信息
 * */
store.showErrorInfo=function(text){
  store.showInfo('error',text);
};
store.showSuccessInfo=function(text){
  store.showInfo("success",text);
};
//switch_info包括:success,error
store.showInfo=function(switch_info,text){
  alert_info_id_name="alert-info";
  $("#"+alert_info_id_name+" strong").text(text);

  if(switch_info=="success"){
    $("#"+alert_info_id_name+"").removeClass("alert-error").addClass("alert-success").show();
  };
  if(switch_info=="error"){
    $("#"+alert_info_id_name+"").removeClass("alert-success").addClass("alert-error").show();
  };
  
}

/*
 * 判断浏览器版本,对IE6，7给予提示
 * */
store.versionIEWarn=function(text){
  if(navigator.userAgent.indexOf("MSIE 6.0")>0){ 
    store.showAlertInfo("您正在使用 IE6 浏览器，建议升级为IE9以上版本！");
  };
  /*
  if(navigator.userAgent.indexOf("MSIE 7.0")>0){
    store.showAlertInfo("您正在使用 IE7 浏览器，建议升级为IE9以上版本！");
  };*/
};


/*
 * 验证登录表单
 * */
store.validateLoginForm=function(){
  /* 表单验证 */
  $("#login-form").validate({
    rules:{
      "email":{
        required: true,
        email: true,
        minlength: 3,
        maxlength: 100
      },
      "password":{
        required: true,
        minlength: 4,
        maxlength: 40
      }
    },
    messages: {
      "email":{
        required: "邮箱不能为空",
        email: "邮箱格式不正确",
        minlength: "最少3个字符",
        maxlength: "最多100个字符"
      },
      "password":{
        required: "密码不能为空",
        minlength: "最少4个字符",
        maxlength: "最多40个字符"
      }
    },
    errorClass: "help-inline store-text-error",
    submitHandler: function(form) {
      $(form).ajaxSubmit({});
    }
  });
};

/*
 * 验证修改个人资料表单
 * */
store.validateProfileForm=function(){
  /* 表单验证 */
  $("#profile-form").validate({
    rules:{
      "user[email]":{
        required: true,
        email: true,
        minlength: 3,
        maxlength: 100
      },
      "user[name]":{
        required: true,
        minlength: 2,
        maxlength: 100        
      }
    },
    messages: {
      "user[email]":{
        required: "邮箱不能为空",
        email: "邮箱格式不正确",
        minlength: "最少3个字符",
        maxlength: "最多100个字符"
      },
      "user[name]":{
        required: "昵称不能为空",
        minlength: "最少2个字符",
        maxlength: "最多100个字符"
      }
    },
    errorClass: "help-inline store-text-error",
    submitHandler: function(form) {
      $(form).ajaxSubmit({});
    }
  });
};


/*
 * 创建商品表单
 * */
store.validateNewItemForm=function(){
  /* 表单验证 */
  $("#new-item-form").validate({
    rules:{
      "item[title]":{
        required: true
      },
      "item[description]":{
        required: true   
      }
    },
    messages: {
      "item[title]":{
        required: "标题不能为空"
      },
      "item[description]":{
        required: "描述不能为空"
      }
    },
    errorClass: "help-inline store-text-error",
    submitHandler: function(form) {
      //增加富文本编辑框的验证
      if($('#item_description').valid()!=false){
        $(form).ajaxSubmit({});
      }
    }
  });
};



/*
 * 编辑商品表单
 * */
store.validateEditItemForm=function(){
  /* 表单验证 */
  $("#edit-item-form").validate({
    rules:{
      "item[title]":{
        required: true
      },
      "item[description]":{
        required: true   
      }
    },
    messages: {
      "item[title]":{
        required: "标题不能为空"
      },
      "item[description]":{
        required: "描述不能为空"
      }
    },
    errorClass: "help-inline store-text-error",
    submitHandler: function(form) {
      //增加富文本编辑框的验证
      if($('#item_description').valid()!=false){
        $(form).ajaxSubmit({});
      }
    }
  });
};


/*
 * 创建分类表单
 * */
store.validateNewCategoryForm=function(){
  /* 表单验证 */
  $("#new-category-form").validate({
    rules:{
      "category[name]":{
        required: true
      }
    },
    messages: {
      "category[name]":{
        required: "名称不能为空"
      }
    },
    errorClass: "help-inline store-text-error",
    submitHandler: function(form) {
        $(form).ajaxSubmit({});
    }
  });
};

/*
 * 创建推荐表单
 * */
store.validateNewRecommendForm=function(){
  /* 表单验证 */
  $("#new-recommend-form").validate({
    rules:{
      "recommend[title]":{
        required: true
      },
      "recommend[description]":{
        required: true
      },
      "recommend[category_id]":{
        required: true
      }
    },
    messages: {
      "recommend[title]":{
        required: "标题不能为空"
      },
      "recommend[description]":{
        required: "描述不能为空"
      },
      "recommend[category_id]":{
        required: "分类不能为空"
      }
    },
    errorClass: "help-inline store-text-error",
    submitHandler: function(form) {
      //增加富文本编辑框的验证
      if($('#recommend_description').valid()!=false){
        $(form).ajaxSubmit({});
      }
    }
  });
};

/*展开/收起阅读*/
store.listToggleLink=function(){
  //展开
  $('body').on('click',"a.list-show-link",function() {
    //文字
    $(this).text("收起");
    $recommendDesc = $(this).parent().prev("div.recommend-desc");
    $recommendDesc.css("height","100%").css("min-height","220px");
    $(this).toggleClass("list-show-link");
    $(this).toggleClass("list-hide-link");
    //图片
    $recommendPhoto = $recommendDesc.prev('.recommend-photo');
    $recommendPhoto.removeClass("fl");
    $recommendImg = $recommendPhoto.find("img").first();
    var originalSrc = $recommendImg.attr("src");
    $recommendImg.attr("src",$recommendImg.attr("backup_src"));
    $recommendImg.attr("backup_src",originalSrc);
    $recommendImg.attr("width",$recommendImg.attr("backup_width"));

    return false;
  });

  //收起
  $('body').on('click',"a.list-hide-link",function() {
    //文字
    $(this).text("展开阅读");
    $recommendDesc = $(this).parent().prev("div.recommend-desc");
    $recommendDesc.css("height","220px");
    $(this).toggleClass("list-show-link");
    $(this).toggleClass("list-hide-link");
    //图片
    $recommendPhoto = $recommendDesc.prev('.recommend-photo');
    $recommendPhoto.addClass("fl");
    var originalSrc = $recommendImg.attr("src");
    $recommendImg.attr("src",$recommendImg.attr("backup_src"));
    $recommendImg.attr("backup_src",originalSrc);
    $recommendImg.attr("width","180px");
    //回滚
    var scroll_id = $recommendImg.attr("recommend_id");
    $('html,body').animate({
        'scrollTop' : $('#recommend-'+scroll_id).offset().top
    });

    return false;
  });

};

/**
 * 全选，反选，取消，具体操作(传递ids数组)
 * */
store.adminSelect = function(){
    //全选
    $("#select_all").bind('click',function(){
        $("input:checkbox[name]").each(function(){
            $(this).attr("checked", true);
        });
    });

    //反选
    $("#select_un").bind('click',function(){
        $("input:checkbox[name]").each(function(){
            $(this).attr("checked",!this.checked);
        });
    });

    //取消
    $("#select_cancel").bind('click',function(){
        $("input:checkbox[name]").each(function(){
            $(this).attr("checked", false);
        });
    });

    //具体操作,传递数组ids
    $(".select_post").bind('click',function(){
        var arrChk = new Array()
        $("input:checkbox[name]").each(function(){
            if($(this).is(':checked')){
                arrChk+=this.value + ',';
            }
        });

        if(arrChk != ''){
            if(!confirm("确定要执行此操作？")){
                return false
            }
            var to_url=$(this).attr("href")
            $.ajax({
                url: to_url,
                type: 'post',
                data: {
                    'ids' : arrChk
                }
            });
        }
        else{
            alert("请至少选择一项");
        }
        //禁止本身的href事件
        return false;
    });
};


/*
 * 创建自由区块表单
 * */
store.validateNewFreeBlockForm=function(){
  /* 表单验证 */
  $("#new-block-form").validate({
    rules:{
      "free_block[tag]":{
        required: true
      },
      "free_block[order]":{
        digits:true
      }
    },
    messages: {
      "free_block[tag]":{
        required: "标识不能为空"
      },
      "free_block[order]":{
        digits: "输入整数"
      }
    },
    errorClass: "help-inline store-text-error",
    submitHandler: function(form) {
        $(form).ajaxSubmit({});
    }
  });
};
