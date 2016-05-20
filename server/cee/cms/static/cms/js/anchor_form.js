(function () {
    var $form = $('form');
    var $inputX = $form.find('input[name="dx"]');
    var $inputY = $form.find('input[name="dy"]');
    var $inputName = $form.find('input[name="name"]');

    $inputX.attr('readonly', true);
    $inputY.attr('readonly', true);

    var $container = $('.map-image-container');
    var $wrapper = $container.find('.map-image-wrapper');
    var $img = $wrapper.find('img');

    var anchorTemplate = _.template(
        '<div class="anchor" style="left: <%=anchor.dx%>px; top: <%=anchor.dy%>px;">' +
        '<div class="anchor-mark"></div>' +
        '<div class="anchor-name"><%=anchor.name%></div>' +
        '</div>'
    );

    var $anchor = getAnchorElement();

    function getAnchorElement() {
        var $anchor = $wrapper.find('.anchor');
        if (!$anchor.length) {
            $anchor = $(anchorTemplate({
                anchor: {
                    name: $inputName.val() || 'name',
                    dx: $inputX.val() || 0,
                    dy: $inputY.val() || 0
                }
            }));
            $wrapper.append($anchor);
        }
        return $anchor;
    }

    function setAnchorPosition(x, y) {
        $anchor.css({
            left: x + 'px',
            top: y + 'px'
        });
    }

    function setAnchorName(name) {
        $anchor.find('.anchor-name').text(name);
    }

    $img.on('click', function (event) {
        var x = event.offsetX;
        var y = event.offsetY;
        setAnchorPosition(x, y);
        $inputX.val(x);
        $inputY.val(y);
    });

    $inputName.on('change', function () {
        var name = $inputName.val();
        setAnchorName(name);
    });


    var stories = window.g_stories;
    var tasks = window.g_tasks;

    var $refIdInput = $('input[name="ref_id"]');
    var $refIdGroup = $refIdInput.closest('.form-group');

    var $storiesGroup = $('<div class="form-group">' +
        '<label for="id_stories" class="col-md-3 control-label">故事</label>' +
        '<div class="col-md-9">' +
        '<select id="id_stories" class="form-control"></select>' +
        '</div>' +
        '</div>');

    var $storySelect = $storiesGroup.find('select');
    _.each(stories, function (item) {
        $storySelect.append('<option value="' + item.id + '">' + item.text + '</option>');
    });

    var $tasksGroup = $('<div class="form-group">' +
        '<label for="id_tasks" class="col-md-3 control-label">选择题组</label>' +
        '<div class="col-md-9">' +
        '<select id="id_tasks" class="form-control"></select>' +
        '</div>' +
        '</div>');

    var $taskSelect = $tasksGroup.find('select');
    _.each(tasks, function (item) {
        $taskSelect.append('<option value="' + item.id + '">' + item.text + '</option>');
    });

    $storiesGroup.insertAfter($refIdGroup);
    $tasksGroup.insertAfter($storiesGroup);

    $refIdGroup.addClass('hidden');

    var $typeSelect = $('select[name="type"]');

    function handleTypeSelect(init) {
        var type = $typeSelect.val();

        if (type === 'task') {
            $storiesGroup.addClass('hidden');
            $tasksGroup.removeClass('hidden');
            if (init) {
                $taskSelect.val($refIdInput.val());
            } else {
                $refIdInput.val($taskSelect.val());
            }
        } else if (type === 'story') {
            $storiesGroup.removeClass('hidden');
            $tasksGroup.addClass('hidden');
            if (init) {
                $storySelect.val($refIdInput.val());
            } else {
                $refIdInput.val($storySelect.val());
            }
        }
    }

    handleTypeSelect(true);

    $typeSelect.on('change', function () {
        handleTypeSelect(false);
    });

    $storySelect.on('change', function () {
        $refIdInput.val($storySelect.val());
    });

    $taskSelect.on('change', function () {
        $refIdInput.val($taskSelect.val());
    });
}());