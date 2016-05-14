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
            _.times(itemCount, function(i) {
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

    window.makeDictEditor = makeDictEditor;
}();