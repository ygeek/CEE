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

    $inputName.on('change', function() {
        var name = $inputName.val();
        setAnchorName(name);
    });
}());