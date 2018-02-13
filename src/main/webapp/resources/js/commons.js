/**
 * Created by wc on 2015/5/17.
 */



var bjw = {
    base :  'http://' + window.location.host + '/admin'
}

//正则
//1-13位数字
var regularNumber = /^\d{1,13}$/;
//6位数字
var regularAreaCode = /^\d{6}$/;
//身份证验证
var regularIdCard = /(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}$)/;
//邮箱验证
var regularEmail = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
//非空字符
var regularName = /^((\s.*)|(.*\s))$/;
//
var regularText =/^[1-20]*$/;
//手机号验证
var regularTel = /^1[3|4|5|8][0-9]\d{4,8}$/;

var regDouble = /^\d+(\.\d{1,2})?$/;
//var regDouble = /^\d+(\.\d{1,2})?$/;

//密码正则 长度6-16位 只能有数字、字母和常用特殊字符
var regularPassword=/^(?=.{6,16}$)(?![0-9]+$)(?!.*(.).*\1)[0-9a-zA-Z]+$/;


//判断值是否为空
function getvalue(val){
    if(val==undefined){
        val='--';
        return val ;
    }else{
        return val;
    }
}
//(function($){
//    $.fn.UI = function(options){
//        var defaults = {
//            iconClass    :    'darkorange',
//            ButtonClass    :    'yellow'
//        };
//
//        $.extend(defaults,options);
//
//        $("i").removeClass("darkorange");
//        $("i").addClass(options.iconClass);
//    }
//})(jQuery);

jQuery.bar = function(options) {
    var defaults = {
        iconClass    :    'darkorange',
        ButtonClass    :    'yellow'
    };

    $.extend(defaults,options);

    $("i").removeClass("darkorange");
    $("i").addClass(options.iconClass);

    $(".btn").removeClass("btn-success");
    $(".btn").addClass(options.ButtonClass);

};
//jQuery.bar = function(param) {
//    alert('This function takes a parameter, which is "' + param + '".');
//};
// 对Date的扩展，将 Date 转化为指定格式的String
// 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符，
// 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)
// 例子：
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18
Date.prototype.format = function (fmt) { //author: meizz
    var o = {
        "M+": this.getMonth() + 1, //月份
        "d+": this.getDate(), //日
        "h+": this.getHours(), //小时
        "m+": this.getMinutes(), //分
        "s+": this.getSeconds(), //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds() //毫秒
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

//日期转换为时间戳
function getTimeStamp(time){
	time=time.replace(/-/g, '/');
	 var date=new Date(time);
	return date.getTime();
}
//时间戳转换为日期
function getTime(ns){
	var val=getvalue(ns);
	if(val!='--'){
		//val=val.time;
		var myDate = new Date(val);
		 return myDate.format("yyyy-MM-dd hh:mm:ss");
	}else{
		return '--';
	}
}
//判断是否为整数
function isInt(num) {
    var type = /^[0-9]*[0-9][0-9]*$/;
    var re = new RegExp(type);
    if (num.match(re) == null) {
      return true;
    }
    return false;
}
//$(document).ajaxComplete(function(event, request, settings) {
//	//console.log(request);
//	try{
//		var demo=JSON.parse(request.responseText);
//		if(demo.flag !=0){
//			if(demo.code==401){
//				location.href = '../cookLogin.jsp';
//				//Notify(demo.msg, 'top-right', '500', 'danger', 'fa-desktop', true);
//			}else if(demo.code!=0 && demo.msg != ""){
//				Notify(demo.msg, 'top-right', '500', 'danger', 'fa-desktop', true);
//			}
//		}else{
//			if(demo.code!=0){
//				Notify(demo.msg, 'top-right', '500', 'danger', 'fa-desktop', true);
//			}
//
//		}
//	}catch(e){
//		return;
//	}
//
//	//flag:请求成功失败  0,1
//	//code:操作成功失败  0,1
//})

//去掉尾部空格
function trimStr(str){
	return str.replace(/(^\s*)|(\s*$)/g,"");
}
//是否大于当前时间，大于返回false；
function nowDate(reviewDate){
    var d1 = new Date(reviewDate.replace(/\-/g, "\/"));
    var myDate = new Date();
    var d2 = myDate.format("yyyy-MM-dd ");
    var today = new Date(d2.replace(/-/g, "/"));
    if (d1 > today) {
      return false;
    }
return true;
}

function inverseOr(val){
    var returnarr = new Array;
    var max = 0;
    var min = 0;
    var arr =[1,2,4,8];
    var len = arr.length;
    for(var i=0;i<len;i++){
        max += arr[i];
    }

    if(val<min || val > max){
        return null;
    }

    while (val>0){
        for (var j = len - 1; j >= 0; i --) {
            if (arr[j] > val) {
                continue;
            }
            val = val ^ arr[j];
            returnarr.push(arr[j]);
        }
    }
    return returnarr;
}

/******************上传图片接口*********************/
/*function uploadImg(){
    $("#imgFile").fileinput({
        language:'zh',
        uploadUrl: "${base}/ctl/resource/upload?type=hotel", // 图片上传接口
        showPreview : true,
        showRemove: false,
        showUpload : true,
        maxFileSize : 850,  //上传图片的最大限制  50KB
        allowedFileExtensions: ["jpg", "png"],
        initialCaption: "请选择图片",
    });
    $("#imgFile").on("fileuploaded", function (event, data, previewId, index) {
        //console.log(data);
        if (null != data) {
            return data.response.data[0];
        }
    });
}*/

/******************验证方法*********************/
//验证手机号码
$.validator.addMethod("isMobile", function(value,element) {
    var length = value.length;
    var mobile = /^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/;
    return this.optional(element) || (length == 11 && mobile.test(value));
}, "请正确填写手机号码");

//验证邮箱
$.validator.addMethod("isEmail", function(value,element) {
    var email =  /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/;
    return this.optional(element) || email.test(value);
}, "请正确填写邮箱");

//验证整数
$.validator.addMethod("isNumber", function(value,element) {
    var number = /^\d+$/;
    return this.optional(element) || number.test(value);
}, "请输入一个整数");

//验证小数
$.validator.addMethod("isDouble", function(value,element) {
    var doubles = /^\d+(\.\d+)?$/;
    return this.optional(element) || doubles.test(value);
}, "请输入一个浮点数");

//不能小于1
$.validator.addMethod("isLessThan1", function(value,element) {
    if(value<1||value=='-'){
        return this.optional(element) || false;
    }else{
        return this.optional(element) || true;
    }
}, "不能小于1");

//不能小于0
$.validator.addMethod("isLessThan0", function(value,element) {
    if(value<0||value=='-'){
        return this.optional(element) || false;
    }else{
        return this.optional(element) || true;
    }
}, "不能小于0");

//验证真实姓名
$.validator.addMethod("isRealName", function(value,element) {
    var realName = /[\u4e00-\u9fa5]/gm;
    if(value.indexOf(" ")>0){
        //layer.msg("名字不能包含空格！");
        return this.optional(element) || false;
    }
    return this.optional(element) || realName.test(value);
}, "请正确填写名字");

//验证用户名
$.validator.addMethod("isFormatUserName", function(value,element) {
    var regularUsername = /^[a-zA-Z_]{1}[0-9a-zA-Z_]{3,19}$/;
    if(value.indexOf(" ")>0){
        //layer.msg("名字不能包含空格！");
        return this.optional(element) || false;
    }
    return this.optional(element) || regularUsername.test(value);
}, "只能输入英文,数字,下划线,字符长度 4-20");

//验证身份证号码
$.validator.addMethod("isIdCard", function(value,element) {
    var regularIdCard = /(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}$)/;
    return this.optional(element) || regularIdCard.test(value);
}, "请正确填写身份证号码");

//验证开始时间大于结束时间
$.validator.addMethod("isTime", function(value,element) {
    var start = parseInt($("#checkInAt").val().replace(/:/,""));
    var end = parseInt(value.replace(/:/,""));
    console.log("start:"+start);
    console.log("end:"+end);
    if(start>=end){
        return this.optional(element) || false;
    }
    return this.optional(element) || true;
}, "开始时间不能大于结束时间");


//封装Map
function Map(){
    this.container = new Object();
}
Map.prototype.put = function(key, value){
    this.container[key] = value;
}
Map.prototype.get = function(key){
    return this.container[key];
}
Map.prototype.keySet = function() {
    var keyset = new Array();
    var count = 0;
    for (var key in this.container) {
        // 跳过object的extend函数
        if (key == 'extend') {
            continue;
        }
        keyset[count] = key;
        count++;
    }
    return keyset;
}
Map.prototype.size = function() {
    var count = 0;
    for (var key in this.container) {
        // 跳过object的extend函数
        if (key == 'extend'){
            continue;
        }
        count++;
    }
    return count;
}
Map.prototype.remove = function(key) {
    delete this.container[key];
};
Map.prototype.toString = function(){
    var str = "";
    for (var i = 0, keys = this.keySet(), len = keys.length; i < len; i++) {
        str = str + keys[i] + "=" + this.container[keys[i]] + ";\n";
    }
    return str;
};
//扩展数组方法:获取是否包含
Array.prototype.indexOf = function(val) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == val) return i;
    }
    return -1;
};

//扩展数组方法:删除指定元素
Array.prototype.remove = function(index) {
    if (isNaN(index) || index > this.length) {
        return false;
    }
    this.splice(index, 1);
};

(function($) {
    $.fn.extend({
        browser : function (options) {
            var $this = $(this);
            var settings = {
                type: "1",
                title: "文件上传",
                isUpload: true,
                showPreview : false,
                showRemove: true,
                maxFileSize: 10240,
                allowedFileExtensions: ["jpg", "png", "jpeg"],
                uploadUrl: bjw.base + "/res/upload",
                initialCaption: "请选择文件",
                maxCount: 1,
                data: [],
                callback: null
            };

            $.extend(settings, options);

            return this.each(function() {
                var $browserButton = $(this);

                $browserButton.click(function () {
                    var $dialog = bootbox.dialog({
                        message: content,
                        title: settings.title,
                        className: "modal-darkorange",

                        buttons: {
                            success: {
                                label: "确定",
                                className: "btn-blue",
                                callback: function () {
                                    if (settings.showPreview) {
                                        if ($this.attr("type") == "text") {
                                            $this.val(settings.data[0].url);
                                        }
                                        var $view = $this.next();
                                        if ($view.hasClass("filePreview")) {
                                            $view.attr("href", bjw.base + settings.data[0].url);
                                        } else {
                                            var $view = $("<a class='filePreview' style='position:relative;float: right; margin-top: -25px; margin-right: -30px;' target='_blank' href='" + bjw.base + settings.data[0].url + "'>查看</a>")
                                            $view.insertAfter($this);

                                        }
                                        // if ($this.) {
                                        //
                                        // }
                                    }
                                    if (settings.callback != null && typeof settings.callback == "function") {
                                        if(settings.data.length == 0){
                                            alert("没有上传图片");
                                            return;
                                        }
                                        settings.callback(settings.data);
                                    }
                                }
                            },
                            "取消": {
                                className: "btn-danger",
                                callback: function () { }
                            }
                        }
                    });
                    $dialog.on("hidden.bs.modal", function () {
                        $.extend(settings, options);
                        settings.data = [];
                    });

                });

            });
            function content(){
                var html = '    <div class="row">'
                    + '<div class="col-md-12">'
                    +   '<div class="form-group">'
                    +       '<input type="file" name="file" id="uploadFile" class="form-control" placeholder="To" required="">'
                    +   '</div>'

                    +   '</div>'
                    + '</div>';
                html += '<div class="row">'
                    +   '<div class="col-md-12" id="fileContainer"></div>'
                    +  '</div>';
                // html = '<div style="width: 620px !important;">' + html + '</div>';
                var object = $('<div/>').html(html).contents();
                $upload = object.find('#uploadFile');
                var $fileContainer = object.find('#fileContainer');
                $upload.fileinput({
                    language:'zh',
                    uploadUrl: bjw.base + "/res/upload", // 图片上传接口
                    showPreview : false,
                    showRemove: false,
                    maxFileSize : 10240,  //上传图片的最大限制  50KB
                    allowedFileExtensions: settings.allowedFileExtensions,
                    initialCaption: settings.initialCaption
                });
                $upload.on("fileuploaded", function (event, data, previewId, index) {
                    if (settings.data.length >= settings.maxCount) {
                        alert("达到最大限制, 无法上传");
                        return false;
                    }

                    if (null != data) {
                        var fileType = data.files[0].type;
                        var fileName = data.files[0].name;
                        var file = data.response.data.url;
                        file.fileType = fileType;
                        file.fileName = fileName;
                        settings.data.push(file);

                        if (fileType.indexOf("image") >= 0) {
                            // $fileContainer.append("<img title='" + fileName + "' src='" + bjw.base + file.smallPath + "'>")

                            //var priviewPath = file.url  + "?" + new Date().getTime();
                            //if (file.smallPath) {
                            //    priviewPath = file.smallPath + "?" + new Date().getMilliseconds();
                            //}
                            var imageHtml = '<div class="file-preview-item file-preview-frame file-preview-success" id="" data-fileindex="0" style="width: 110px;">'
                                + '<img src="' + bjw.base + "/"+file + '" class="file-preview-image" style="width: 110px; height: 140px;">'
                                + '<div style=>'
                                +    '<span style="float: left;width: 80px;display:block;white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' + fileName +　'</span>'
                                +    '<button type="button" style="float: right" class="kv-file-remove btn btn-xs btn-default" title="删除文件"><i class="glyphicon glyphicon-trash text-danger"></i></button>'
                                + '</div>'
                                + '  </div>';
                            $fileContainer.append(imageHtml)

                        } else {
                            // $fileContainer.append('<span title="' + fileName + '" class="file-icon-4x"><i class="glyphicon glyphicon-file"></i></span>');
                            var otherHtml = '<div class="file-preview-item file-preview-frame"  style="width: 110px;">' +
                                '<div  style="width: 110px; height: 140px;">' +
                                '<span class="file-icon-4x" style="position: relative;top: 40px;">' +
                                '<i class="glyphicon glyphicon-file"></i>' +
                                '</span> ' +
                                '</div>'
                                + '<div style=>'
                                +    '<span style="float: left">' + fileName +　'</span>'
                                +    '<button type="button" style="float: right" class="kv-file-remove btn btn-xs btn-default" title="删除文件"><i class="glyphicon glyphicon-trash text-danger"></i></button>'
                                + '</div>'

                            '</div>';
                            $fileContainer.append(otherHtml);
                        }

                        $(".file-preview-item .kv-file-remove").unbind().click();
                        $(".file-preview-item .kv-file-remove").on("click", function () {
                            var $item = $(this).parents(".file-preview-item");
                            var index = $item.index();
                            $item.remove();

                            settings.data.remove(index);
                        });

                    } else {
                        Notify("上传图片失败", 'top-right', '5000', 'danger', 'fa-desktop', true);
                    }

                });
                return object
            }

        }

    });
})(jQuery);

/**
 * 时间计算，传入一个时间和当前时间，计算时间差
 * @param 开始时间
 * @returns 时间差
 */
function countTime (startTime) {
    //var date1 = '2016-12-29 16:00:00'; //开始时间
    var date1 = startTime;
    var date2 = new Date(); //结束时间
    var date3 = date2.getTime() - new Date(date1).getTime(); //时间差的毫秒数
    //计算出相差天数
    var days = Math.floor(date3 / (24 * 3600 * 1000))
    //计算出小时数
    var leave1 = date3 % (24 * 3600 * 1000) //计算天数后剩余的毫秒数
    var hours = Math.floor(leave1 / (3600 * 1000))
    //计算相差分钟数
    var leave2 = leave1 % (3600 * 1000) //计算小时数后剩余的毫秒数
    var minutes = Math.floor(leave2 / (60 * 1000))
    //计算相差秒数
    var leave3 = leave2 % (60 * 1000) //计算分钟数后剩余的毫秒数
    var seconds = Math.round(leave3 / 1000)
    console.log(" 相差 " + days + "天 " + hours + "小时 " + minutes + " 分钟" + seconds + " 秒");
    var msg = "";
    if (days == 0) {
        if (hours == 0) {
            if (minutes == 0) {
                msg ="1分钟";
            }
            else {
                msg = minutes + "分钟";
            }
        }
        else {
            msg = hours + "小时 " + minutes + "分钟";
        }
    }
    else if (days > 7) {
        msg = startTime;
    }
    else {
        msg = days + "天 " + hours + "小时 " + minutes + "分钟";

    }
    return msg;
}

/***
 * 图片放大
 */
$(function (){
    $(".enlarge").css("cursor", "pointer");
    $(".enlarge").click(function (){
        layer.open({
            type: 1,
            title: false,
            closeBtn: 1,
            skin: 'yourclass',
            shadeClose: true,
            shade: 0.5,
            area:['800px' , '500px'],
            content: "<img src='" + $(this).attr("src") + "'/>"
        });
    });
});
