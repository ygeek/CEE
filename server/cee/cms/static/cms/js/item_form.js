function update_item_fields()
{
    type = $('select[name="type"]').val();
    if (type == 'navigation') {
        $('div[name="location"]').show();
    } else {
        $('div[name="location"]').hide();
    }
    if (type == 'note') {
        $('div[name="event"]').hide();
    } else {
        $('div[name="event"]').show();
    }
}

function makeItemContentEditor()
{
    var $content_textarea = $('textarea[name="content"]');
    $content_textarea.hide();
    var content = {}
    try {
        content = JSON.parse($content_textarea.val());
        if (content == null) content = {};
    } catch (e) {
        content = {};
    }
    options = {'navigation': '导航', 'note': '纸条', 'lock': '锁箱'};
    type = content.type;
    if (!(type in options)) type = 'navigation';
    if (!content.text) content.text = '';
    if (!content.event) content.event = '';
    if (!content.icon) content.icon = '';
    if (!content.longitude) content.longitude = 0;
    if (!content.latitude) content.latitude = 0;
    editor = '<div class="container-fluid">';
    editor += '<div class="form-group">';
    editor += '<div name="type">';
    editor += '  <label for="type">类型</label>';
    editor += '  <select class="form-control" name="type">';
    editor += '</div>';
    for (var key in options) {
        var value = options[key];
        editor += '<option value="' + key + '"';
        if (key == type) editor += 'selected';
        editor += '>' + value + '</option>';
    }
    editor += '</select>';
    editor += '<div name="text">';
    editor += '  <label for="text">文字描述</label>';
    editor += '  <input class="form-control" type="text" name="text"';
    editor += '         value="' + content.text + '">';
    editor += '</div>';
    editor += '<div name="event">';
    editor += '  <label for="event">事件</label>';
    editor += '  <input class="form-control" type="text" name="event"';
    editor += '         value="' + content.event + '">';
    editor += '</div>';
    editor += '<div name="location">';
    editor += '  <label for="longitude">经度</label>';
    editor += '  <input class="form-control" type="number" step="any" name="longitude"';
    editor += '         value="' + content.longitude + '">';
    editor += '  <label for="latitude">纬度</label>';
    editor += '  <input class="form-control" type="number" step="any" name="latitude"';
    editor += '         value="' + content.latitude + '">';
    editor += '</div>';
    editor += '<div name="icon">';
    editor += '  <label for="icon">图片</label>';
    editor += '  <input class="form-control" type="text" name="icon"';
    editor += '         value="' + content.icon + '">';
    editor += '</div>';
    editor += '</div>';
    editor += '</div>';
    $content_textarea.after(editor);
    $('select[name="type"]').change(update_item_fields);
    update_item_fields();
    $content_textarea.closest('form').submit(function() {
        var content = {};
        content.type = $('select[name="type"]').val();
        content.icon = $('input[name="icon"]').val();
        content.text = $('input[name="text"]').val();
        if (content.type != 'note') {
            content.event = $('input[name="event"]').val();
        }
        if (content.type == 'navigation') {
            content.longitude = $('input[name="longitude"]').val();
            content.latitude = $('input[name="latitude"]').val();
        }
        $content_textarea.val(JSON.stringify(content));
    });
}

(function(){
    makeItemContentEditor();
    //makeDictEditor('desc');
    makeSingleImageUploader('icon', {buttonLabel: '上传 276x213'});
})();
