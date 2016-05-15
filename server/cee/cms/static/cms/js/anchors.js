(function () {
    var $container = $('.map-image-container');
    var $wrapper = $container.find('.map-image-wrapper');
    var $img = $wrapper.find('img');

    var anchors = window.g_anchors || [];

    var anchorTemplate = _.template(
        '<div class="anchor" style="left: <%=anchor.dx%>px; top: <%=anchor.dy%>px;">' +
        '<div class="anchor-mark"></div>' +
        '<div class="anchor-name"><%=anchor.name%></div>' +
        '</div>'
    );

    _.each(anchors, function (anchor) {
        $wrapper.append(anchorTemplate({
            anchor: anchor
        }));
    });
}());