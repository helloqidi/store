// Put your application scripts here

/*
 *定义module
 * */
var store = {
  visitor : {},
  redirect: function(url,delay) {
    setTimeout(function(){
        window.location = url;
        },delay);
  }

};//store end


/*
 * 初始化
 * */
store.initial = function(){
  //placeholder属性插件
  $('input, textarea').placeholder();
};
