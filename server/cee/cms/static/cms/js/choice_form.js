(function(){
    makeSingleImageUploader('image_key', {buttonLabel: '上传 696x237'});
    makeSingleImageUploader('answer_image_key', {buttonLabel: '上传 696x432'});
    $('select[name="task"]').closest('div.form-group').remove();
})();
