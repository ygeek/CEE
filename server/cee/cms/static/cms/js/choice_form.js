(function(){
    makeSingleImageUploader('image_key', {buttonLabel: '上传 232pt x 79pt'});
    makeSingleImageUploader('answer_image_key');
    $('select[name="task"]').closest('div.form-group').remove();
})();
