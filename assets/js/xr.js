// Agency Theme JavaScript

(function($) {
    "use strict"; // Start of use strict

    // jQuery for page scrolling feature - requires jQuery Easing plugin
    $('a.page-scroll').bind('click', function(event) {
        var $anchor = $(this);
        var u = $anchor.attr('href');
        var hash = u.substring(u.indexOf('#'));
        var $section = $('html').find(hash)
        $('html, body').stop().animate({
            scrollTop: ($section.offset().top - 50)
        }, 1250, 'easeInOutExpo');
        event.preventDefault();
    });

    // Highlight the top nav as scrolling occurs
    // $('body').scrollspy({
    //     target: '.navbar-fixed-top',
    //     offset: 51
    // });

    // Closes the Responsive Menu on Menu Item Click
    // dropdown-toggle
    $('#main-nav div.navbar-collapse ul li a').not(".xr-nav-dropdown-toggle").click(function(){
        $('#main-navbar-toggler:visible').click();
    });

    $('#sub-nav div.navbar-collapse ul li a').not(".xr-nav-dropdown-toggle").click(function(){
        $('#sub-navbar-toggler:visible').click();
    });

    // Offset for Main Navigation
    // $('#main-nav').affix({
    //     offset: {
    //         top: 100
    //     }
    // })

    $(document).on('click', '[data-toggle="lightbox"]', function(event) {
        event.preventDefault();
        $(this).ekkoLightbox();
    });

    $('#hero-video-play-icon').click(function(event) {
        event.preventDefault();
        $('#home-header-video-frame').removeClass('d-none');
        $('#home-header-video-cover').addClass('d-none');
    });

    $(':input[name=branches-list-filter]').on('input',function() {
        // get value just typed into textbox
        var val = this.value.toLowerCase();
        // find all .xr-color-box divs
        $('#branches-list .row').find('.xr-color-box')
            // find those that should be visible
            .filter(function() {
                return $(this).data('id').toLowerCase().indexOf( val ) > -1;
            })
            // make them visible
            .show()
            // now go back and get only the visible ones
            .end().filter(':visible')
            // filter only those for which typed value 'val' does not match the `data-id` value
            .filter(function() {
                return $(this).data('id').toLowerCase().indexOf( val ) === -1;
            })
            // fade those out
            .fadeOut();
    });

})(jQuery); // End of use strict
