(function () {
    makeListEditor('tags');

    makeSingleImageUploader('tour_image_key', {buttonLabel: '上传 750x300'});
    makeSingleImageUploader('hud_image_key', {buttonLabel: '上传 696x753'});


    var QINIU_DOMAIN = '7xt08d.com1.z0.glb.clouddn.com';
    var DOWNTOKEN_URL = '/cms/downtoken/';

    var images = [];

    var progressTemplate = _.template('<div class="upload-progress row" id="file_<%= id %>">' +
        '<div class="col-md-6 name"><%= name %></div>' +
        '<div class="col-md-6 progress-container">' +
        '<div class="progress" style="width: <%= percent %>%;"></div>' +
        '</div>' +
        '</div>');

    var imageTemplate = _.template('<div class="col-lg-3 col-md-4 col-xs-6 thumb" id="image_<%= key %>">' +
        '<a class="thumbnail" href="#" data-key="<%= key %>">' +
        '<img class="img-responsive" src="<%= src %>" alt="<%= key %>">' +
        '</a></div>');

    function initImages() {
        var val = $('textarea[name="image_keys"]').val();
        var imageList;
        try {
            imageList = JSON.parse(val);
        } catch (e) {
            imageList = [String(val)];
        }

        _.each(imageList, function (key) {
            addImage(key, '#')
        });

        _.each(imageList, function (key) {
            $.ajax({
                url: DOWNTOKEN_URL,
                method: 'POST',
                dataType: 'json',
                data: {
                    key: key,
                    domain: QINIU_DOMAIN
                }
            }).done(function(data) {
                replaceImage(key, data.url);
            });
        });

        refreshHint();
    }

    initImages();

    function addImage(key, src) {
        images.push(key);
        $('#qiniu-upload-container')
            .find('.images-container')
            .append(imageTemplate({
                src: src,
                key: key
            }));
        refreshHint();
    }

    function removeImage(key) {
        images = _.without(images, key);
        $(document.getElementById('image_' + key)).remove();
        refreshHint();
    }

    function replaceImage(key, src) {
        $(document.getElementById('image_' + key))
            .find('img')
            .attr('src', src);
    }

    function refreshHint() {
        if (images.length === 0) {
            $('#qiniu-upload-container').removeClass('has-image');
        } else {
            $('#qiniu-upload-container').addClass('has-image');
        }
        $('textarea[name="image_keys"]').val(JSON.stringify(images));
    }

    $('#qiniu-upload-container').delegate('a.thumbnail', 'click', function (event) {
        event.preventDefault();
        var key = $(this).data('key');
        removeImage(key);
    });

    var uploader = Qiniu.uploader({
        runtimes: 'html5,flash,html4',      // 上传模式,依次退化
        browse_button: 'pickfiles',         // 上传选择的点选按钮，**必需**
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
        container: 'qiniu-upload-container',             // 上传区域 DOM ID，默认是 browser_button 的父元素，
        max_file_size: '100mb',             // 最大文件体积限制
        flash_swf_url: '/static/cms/assets/plupload-2.1.8/js/Moxie.swf',  //引入 flash,相对路径
        max_retries: 3,                     // 上传失败最大重试次数
        dragdrop: true,                     // 开启可拖曳上传
        drop_element: 'container',          // 拖曳上传区域元素的 ID，拖曳文件或文件夹后可触发上传
        chunk_size: '4mb',                  // 分块上传时，每块的体积
        auto_start: true,                   // 选择文件后自动上传，若关闭需要自己绑定事件触发上传,
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
                    // 文件添加进队列后,处理相关的事情
                    $('#qiniu-upload-container')
                        .find('.uploading-list')
                        .append(progressTemplate({
                            id: file.id,
                            name: file.name,
                            percent: 0
                        }));
                });
            },
            'BeforeUpload': function (up, file) {
                // 每个文件上传前,处理相关的事情
            },
            'UploadProgress': function (up, file) {
                // 每个文件上传时,处理相关的事情
                $('#file_' + file.id).find('.progress').css('width', file.percent + '%');
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

                $(document.getElementById('file_' + file.id)).remove();

                addImage(res.key, res.url)
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
})();