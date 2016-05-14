/*---LEFT BAR ACCORDION----*/
$(function () {
    $('#nav-accordion').dcAccordion({
        eventType: 'click',
        autoClose: true,
        saveState: true,
        disableLink: true,
        speed: 'slow',
        showCount: false,
        autoExpand: true,
//        cookie: 'dcjq-accordion-1',
        classExpand: 'dcjq-current-parent'
    });
});

// right slidebar
$(function () {
    $.slidebars();
});

var Script = function () {

//    sidebar dropdown menu auto scrolling

    jQuery('#sidebar .sub-menu > a').click(function () {
        var o = ($(this).offset());
        diff = 250 - o.top;
        if (diff > 0)
            $("#sidebar").scrollTo("-=" + Math.abs(diff), 500);
        else
            $("#sidebar").scrollTo("+=" + Math.abs(diff), 500);
    });

//    sidebar toggle

    $(function () {
        function responsiveView() {
            var wSize = $(window).width();
            if (wSize <= 768) {
                $('#container').addClass('sidebar-close');
                $('#sidebar > ul').hide();
            }

            if (wSize > 768) {
                $('#container').removeClass('sidebar-close');
                $('#sidebar > ul').show();
            }
        }

        $(window).on('load', responsiveView);
        $(window).on('resize', responsiveView);
    });

    $('.fa-bars').click(function () {

        if ($('#sidebar > ul').is(":visible") === true) {
            $('#main-content').css({
                'margin-left': '0px'
            });
            $('#sidebar').css({
                'margin-left': '-210px'
            });
            $('#sidebar > ul').hide();
            $("#container").addClass("sidebar-closed");
        } else {
            $('#main-content').css({
                'margin-left': '210px'
            });
            $('#sidebar > ul').show();
            $('#sidebar').css({
                'margin-left': '0'
            });
            $("#container").removeClass("sidebar-closed");
        }
        var owl = $("#owl-demo").data("owlCarousel");
        owl.reinit();
    });

// custom scrollbar
    $("#sidebar").niceScroll({
        styler: "fb",
        cursorcolor: "#e8403f",
        cursorwidth: '3',
        cursorborderradius: '10px',
        background: '#404040',
        spacebarenabled: false,
        cursorborder: '',
        scrollspeed: 60
    });

    //$("html").niceScroll({styler:"fb",cursorcolor:"#e8403f", cursorwidth: '6', cursorborderradius: '10px', background: '#404040', spacebarenabled:false,  cursorborder: '', zindex: '1000', scrollspeed: 100, mousescrollstep: 60});

    $(".table-responsive").niceScroll({
        styler: "fb",
        cursorcolor: "#e8403f",
        cursorwidth: '6',
        cursorborderradius: '10px',
        background: '#404040',
        spacebarenabled: false,
        cursorborder: '',
        zindex: '1000',
        horizrailenabled: true
    });


// widget tools

    jQuery('.panel .tools .fa-chevron-down').click(function () {
        var el = jQuery(this).parents(".panel").children(".panel-body");
        if (jQuery(this).hasClass("fa-chevron-down")) {
            jQuery(this).removeClass("fa-chevron-down").addClass("fa-chevron-up");
            el.slideUp(200);
        } else {
            jQuery(this).removeClass("fa-chevron-up").addClass("fa-chevron-down");
            el.slideDown(200);
        }
    });

// by default collapse widget

//    $('.panel .tools .fa').click(function () {
//        var el = $(this).parents(".panel").children(".panel-body");
//        if ($(this).hasClass("fa-chevron-down")) {
//            $(this).removeClass("fa-chevron-down").addClass("fa-chevron-up");
//            el.slideUp(200);
//        } else {
//            $(this).removeClass("fa-chevron-up").addClass("fa-chevron-down");
//            el.slideDown(200); }
//    });

    jQuery('.panel .tools .fa-times').click(function () {
        jQuery(this).parents(".panel").parent().remove();
    });


//    tool tips

    $('.tooltips').tooltip();

//    popovers

    $('.popovers').popover();


// custom bar chart

    if ($(".custom-bar-chart")) {
        $(".bar").each(function () {
            var i = $(this).find(".value").html();
            $(this).find(".value").html("");
            $(this).find(".value").animate({
                height: i
            }, 2000)
        })
    }


// date pickers
    $('input[name="birthday"],input[name="gmt_start"],input[name="gmt_end"]').datepicker({
        format: 'yyyy-mm-dd',
        language: 'zh-CN'
    });

// global utils
    function makeDictEditor(name, itemCount) {
        itemCount = itemCount || 2;

        var selector = 'textarea[name="' + name + '"]';
        var $textarea = $(selector);
        var dict;
        try {
            dict = JSON.parse($textarea.val());
        } catch (e) {
            dict = {};
        }
        if (!dict) {
            dict = {};
        }

        $textarea.addClass('hidden');

        function getItemHtml(index) {
            var res = '<div class="col-md-3"><label class="control-label" for="coupon-desc-title-{{i}}">优惠内容{{i}}</label></div>' +
                '<div class="col-md-9"><input class="form-control" type="text" id="coupon-desc-title-{{i}}"></div>' +
                '<div class="col-md-3"><label class="control-label" for="coupon-desc-content-{{i}}">优惠详情{{i}}</label></div>' +
                '<div class="col-md-9"><textarea class="form-control" rows="2" id="coupon-desc-content-{{i}}">' +
                '</textarea></div>';
            return res.replace(/\{\{i}}/g, index + 1);
        }

        var itemsHtml = _.map(_.range(itemCount), getItemHtml).join('');
        var $replaced = $('<div class="container-fluid">' +
            '<div class="row">' + itemsHtml + '</div>' +
            '</div>');

        // fill in initial values
        var keys = _.keys(dict);
        _.times(Math.min(itemCount, _.size(dict)), function (i) {
            var key = keys[i];
            var value = dict[key];
            var $input = $replaced.find('#coupon-desc-title-' + (i + 1));
            $input.val(key);
            var $textarea = $replaced.find('#coupon-desc-content-' + (i + 1));
            $textarea.val(value);
        });

        $textarea.parent().append($replaced);

        $textarea.closest('form').on('submit', function () {
            var submitDict = {};
            _.times(itemCount, function (i) {
                var $input = $replaced.find('#coupon-desc-title-' + (i + 1));
                var key = $input.val();
                if (!key) {
                    return;
                }
                var $textarea = $replaced.find('#coupon-desc-content-' + (i + 1));
                submitDict[key] = $textarea.val();
            });

            $textarea.val(JSON.stringify(submitDict));
        });
    }

    function makeListEditor(name, itemCount) {
        itemCount = itemCount || 5;

        var selector = 'textarea[name="' + name + '"]';
        var $textarea = $(selector);

        $textarea.addClass('hidden');

        var list;
        try {
            list = JSON.parse($textarea.val());
        } catch (e) {
            list = [];
        }
        if (!list) {
            list = [];
        }

        var itemTemplate = _.template('<div class="col-xs-6 col-sm-3 col-md-2">' +
            '<input class="form-control" type="text" id="tag-input-<%=name%>-<%=index%>">' +
            '</div>');

        var itemsHtml = _.map(_.range(itemCount), function (i) {
            return itemTemplate({
                name: name,
                index: i
            });
        }).join('');
        var $replaced = $('<div class="container-fluid"><div class="row">' +
            itemsHtml +
            '</div></div>');

        _.times(Math.min(list.length, itemCount), function (i) {
            var $input = $replaced.find('#tag-input-' + name + '-' + i);
            $input.val(list[i]);
        });

        $textarea.parent().append($replaced);

        $textarea.closest('form').on('submit', function () {
            var submitList = [];

            _.times(itemCount, function (i) {
                var $input = $replaced.find('#tag-input-' + name + '-' + i);
                var tag = $input.val();
                if (tag) {
                    submitList.push(tag);
                }
            });

            $textarea.val(JSON.stringify(submitList));
        });
    }

    function makeSingleImageUploader(name, options) {
        options = options || {};
        options.buttonLabel = options.buttonLabel || '上传';
        options.preview = _.isBoolean(options.preview) ? options.preview : true;

        var QINIU_DOMAIN = '7xt08d.com1.z0.glb.clouddn.com';
        var DOWNTOKEN_URL = '/cms/downtoken/';

        var selector = 'input[name="' + name + '"]';
        var $input = $(selector);

        $input.attr('readonly', true);

        var uploadContainerId = 'upload-container-' + name;
        var $uploadContainer = $('<div id="' + uploadContainerId + '"></div>');
        var uploadButtonId = 'upload-button-' + name;
        var $uploadButton = $('<div class="text-center" style="margin: 10px 0;">' +
            '<button id="' + uploadButtonId + '" class="btn btn-info btn-sm">' +
            '<i class="fa fa-upload"></i> ' + options.buttonLabel + '</button> ' +
            '<span class="upload-progress" style="display: none;">0%</span></div>');
        $uploadContainer.append($uploadButton);
        $input.parent().append($uploadContainer);

        var $uploadProgress = $uploadButton.find('.upload-progress');

        var oldKey = $input.val();

        var uploadedImageId = 'uploaded-image-' + name;

        var imageTemplate = options.preview ? _.template('<div class="thumb" style="margin: 10px auto; max-width: 300px;">' +
            '<img class="img-responsive" src="<%= src %>" alt="<%= key %>" id="' + uploadedImageId + '">' +
            '</div>') : _.template('');

        $uploadContainer.append('<div class="row">' + imageTemplate({
                src: '#',
                key: oldKey
            }) + '</div>');


        if (oldKey) {
            $.ajax({
                url: DOWNTOKEN_URL,
                method: 'POST',
                dataType: 'json',
                data: {
                    key: oldKey,
                    domain: QINIU_DOMAIN
                }
            }).done(function (data) {
                $uploadContainer.find('#' + uploadedImageId).attr('src', data.url);
            });
        }

        var uploader = Qiniu.uploader({
            runtimes: 'html5,flash,html4',      // 上传模式,依次退化
            browse_button: uploadButtonId,         // 上传选择的点选按钮，**必需**
            // 在初始化时，uptoken, uptoken_url, uptoken_func 三个参数中必须有一个被设置
            // 切如果提供了多个，其优先级为 uptoken > uptoken_url > uptoken_func
            // 其中 uptoken 是直接提供上传凭证，uptoken_url 是提供了获取上传凭证的地址，如果需要定制获取 uptoken 的过程则可以设置 uptoken_func
            // uptoken : '<Your upload token>', // uptoken 是上传凭证，由其他程序生成
            uptoken_url: '/cms/uptoken/',         // Ajax 请求 uptoken 的 Url，**强烈建议设置**（服务端提供）
            // uptoken_func: function(file){    // 在需要获取 uptoken 时，该方法会被调用
            //    // do something
            //    return uptoken;
            // },
            get_new_uptoken: false,             // 设置上传文件的时候是否每次都重新获取新的 uptoken
            downtoken_url: DOWNTOKEN_URL,
            // Ajax请求downToken的Url，私有空间时使用,JS-SDK 将向该地址POST文件的key和domain,服务端返回的JSON必须包含`url`字段，`url`值为该文件的下载地址
            unique_names: true,              // 默认 false，key 为文件名。若开启该选项，JS-SDK 会为每个文件自动生成key（文件名）
            // save_key: true,                  // 默认 false。若在服务端生成 uptoken 的上传策略中指定了 `sava_key`，则开启，SDK在前端将不对key进行任何处理
            domain: QINIU_DOMAIN,     // bucket 域名，下载资源时用到，**必需**
            container: uploadContainerId,             // 上传区域 DOM ID，默认是 browser_button 的父元素，
            max_file_size: '100mb',             // 最大文件体积限制
            flash_swf_url: '/static/cms/assets/plupload-2.1.8/js/Moxie.swf',  //引入 flash,相对路径
            max_retries: 3,                     // 上传失败最大重试次数
            dragdrop: true,                     // 开启可拖曳上传
            drop_element: uploadContainerId,          // 拖曳上传区域元素的 ID，拖曳文件或文件夹后可触发上传
            chunk_size: '4mb',                  // 分块上传时，每块的体积
            auto_start: true,                   // 选择文件后自动上传，若关闭需要自己绑定事件触发上传,
            multi_selection: false, // 上传多文件
            //x_vars : {
            //    自定义变量，参考http://developer.qiniu.com/docs/v6/api/overview/up/response/vars.html
            //    'time' : function(up,file) {
            //        var time = (new Date()).getTime();
            // do something with 'time'
            //        return time;
            //    },
            //    'size' : function(up,file) {
            //        var size = file.size;
            // do something with 'size'
            //        return size;
            //    }
            //},
            init: {
                'FilesAdded': function (up, files) {
                    plupload.each(files, function (file) {
                        $uploadProgress.text('0%').css('display', '');
                    });
                },
                'BeforeUpload': function (up, file) {
                    // 每个文件上传前,处理相关的事情
                },
                'UploadProgress': function (up, file) {
                    $uploadProgress.text(file.percent + '%');
                },
                'FileUploaded': function (up, file, info) {
                    // 每个文件上传成功后,处理相关的事情
                    // 其中 info 是文件上传成功后，服务端返回的json，形式如
                    // {
                    //    "hash": "Fh8xVqod2MQ1mocfI4S4KpRL6D98",
                    //    "key": "gogopher.jpg"
                    //  }
                    // 参考http://developer.qiniu.com/docs/v6/api/overview/up/response/simple-response.html

                    // var domain = up.getOption('domain');
                    var res = JSON.parse(info);
                    // var sourceLink = '//' + domain + '/' + res.key;  //获取上传成功后的文件的Url

                    $uploadContainer.find('#' + uploadedImageId).attr({
                        src: res.url,
                        alt: res.key
                    });

                    $input.val(res.key);

                    $uploadProgress.css('display', 'none');
                },
                'Error': function (up, err, errTip) {
                    //上传出错时,处理相关的事情
                },
                'UploadComplete': function () {
                    //队列文件处理完毕后,处理相关的事情
                },
                // 'Key': function (up, file) {
                //     // 若想在前端对每个文件的key进行个性化处理，可以配置该函数
                //     // 该配置必须要在 unique_names: false , save_key: false 时才生效
                //
                //     var key = "";
                //     // do something with key here
                //     return key
                // }
            }
        });
    }

    window.makeDictEditor = makeDictEditor;
    window.makeListEditor = makeListEditor;
    window.makeSingleImageUploader = makeSingleImageUploader;
}();