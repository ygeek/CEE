(function(){
    makeSingleImageUploader('image_key');
    makeSingleImageUploader('answer_image_key');
    $('select[name="task"]').closest('div.form-group').remove();
})();
