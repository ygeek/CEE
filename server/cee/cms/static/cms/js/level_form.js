(function () {
    var $typeSelect = $('select[name="type"]');
    var $contentArea = $('textarea[name="content"]');

    var textFieldTemplate = _.template('<div class="col-md-3"><%=label%></div>' +
        '<div class="col-md-9"><input class="form-control" type="text" name="<%=name%>" required></div>');

    var numberFieldTemplate = _.template('<div class="col-md-3"><%=label%></div>' +
        '<div class="col-md-9"><input class="form-control" type="number" name="<%=name%>" required></div>');

    var textareaTemplate = _.template('<div class="col-md-3"><%=label%></div>' +
        '<div class="col-md-9"><textarea class="form-control" name="<%=name%>" rows="5" required/></div>');

    var content;
    try {
        content = JSON.parse($contentArea.val());
    } catch (e) {
        content = {};
    }
    content = content || {};

    $contentArea.addClass('hidden');

    var $replaced = $('<div class="container-fluid"></div>');

    $contentArea.parent().append($replaced);

    replaceForm($typeSelect.val());

    $typeSelect.on('change', function () {
        var type = $(this).val();
        replaceForm(type);
    });

    $contentArea.closest('form').on('submit', function () {
        collectData($typeSelect.val());
        $contentArea.val(JSON.stringify(content));
    });

    function fillField(name) {
        var $input = $replaced.find('[name="' + name + '"]');
        $input.val(content[name] || '');
    }

    function fillInitialData(type) {
        switch (type) {
            case 'dialog':
                fillField('img');
                fillField('sayer');
                fillField('text');
                break;
            case 'video':
                fillField('video_key');
                break;
            case 'number':
            case 'text':
                fillField('text');
                fillField('answer');
                fillField('img');
                break;
            case 'empty':
                fillField('event');
                fillField('img');
                break;
            case 'h5':
                fillField('url');
                break;
        }
    }

    function collectField(name) {
        var $input = $replaced.find('[name="' + name + '"]');
        content[name] = $input.val();
    }

    function collectData(type) {
        content = {
            type: type
        };

        switch (type) {
            case 'dialog':
                collectField('img');
                collectField('sayer');
                collectField('text');
                break;
            case 'video':
                collectField('video_key');
                break;
            case 'number':
            case 'text':
                collectField('text');
                collectField('answer');
                collectField('img');
                break;
            case 'empty':
                collectField('event');
                collectField('img');
                break;
            case 'h5':
                collectField('url');
                break;
        }
    }

    function doReplaceForm(form, type) {
        $replaced.append(form);
        fillInitialData(type);
    }

    function replaceForm(type) {
        $replaced.empty();

        switch (type) {
            case 'dialog':
                doReplaceForm(getDialogForm(), type);
                makeSingleImageUploader('img');
                break;
            case 'video':
                doReplaceForm(getVideoForm(), type);
                makeSingleImageUploader('video_key', {
                    preview: false
                });
                break;
            case 'number':
                doReplaceForm(getNumberForm(), type);
                makeSingleImageUploader('img');
                break;
            case 'text':
                doReplaceForm(getTextForm(), type);
                makeSingleImageUploader('img');
                break;
            case 'empty':
                doReplaceForm(getEmptyForm(), type);
                makeSingleImageUploader('img');
                break;
            case 'h5':
                doReplaceForm(getH5Form(), type);
                break;
        }
    }

    function getDialogForm() {
        return $('<div class="row">' +
            textFieldTemplate({
                name: 'sayer',
                label: '说话人姓名'
            }) +
            textareaTemplate({
                name: 'text',
                label: '对白'
            }) +
            textFieldTemplate({
                name: 'img',
                label: '背景图'
            }) +
            '</div>');
    }

    function getVideoForm() {
        return $('<div class="row">' +
            textFieldTemplate({
                name: 'video_key',
                label: '视频'
            }) +
            '</div>');
    }

    function getNumberForm() {
        return $('<div class="row">' +
            textareaTemplate({
                name: 'text',
                label: '谜题说明'
            }) +
            numberFieldTemplate({
                name: 'answer',
                label: '答案'
            }) +
            textFieldTemplate({
                name: 'img',
                label: '配图'
            }) +
            '</div>');
    }

    function getTextForm() {
        return $('<div class="row">' +
            textareaTemplate({
                name: 'text',
                label: '谜题说明'
            }) +
            textFieldTemplate({
                name: 'answer',
                label: '答案'
            }) +
            textFieldTemplate({
                name: 'img',
                label: '配图'
            }) +
            '</div>');
    }

    function getEmptyForm() {
        return $('<div class="row">' +
            textFieldTemplate({
                name: 'event',
                label: '事件名称'
            }) +
            textFieldTemplate({
                name: 'img',
                label: '配图'
            }) +
            '</div>');
    }

    function getH5Form() {
        return $('<div class="row">' +
            textFieldTemplate({
                name: 'url',
                label: 'URL'
            }) +
            '</div>');
    }
}());