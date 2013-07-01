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
};


/*
 * 验证注册表单
 * */
store.validateRegisterForm=function(){
  /* 表单验证 */
  $('#register-form').validate({
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
store.showAlertInfo=function(text){
  $("#alert-info").append("<strong>"+text+"</strong>").show();
};

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
  $('#login-form').validate({
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

