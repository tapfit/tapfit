// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var previousOffset = 0;
var isAnimating = false;

$(document).ready(function() {
    /* Scroll event handler */
    if (screen.width > 500) {
        
        // Bind handleStickDiv to scroll
        $(window).bind('scroll',function(e){
            handleStickyDiv();
        });

        // Bind anchor scrolling to click
        $('a').click(function(){
            $('html, body').animate({
                scrollTop: $('[name="' + $.attr(this, 'href').substr(1) + '"]').offset().top,
            }, 500);
            return false;
        });
        
        // Set up slideshow
        setInterval(slideshow, 3000);

        // Handle stickyDiv on document ready
        handleStickyDiv();
    }
});

/* Scroll the background layers */
function handleStickyDiv(){
    var scrolled = $(window).scrollTop();
    var offset = $("#banner").height() - $("header#top").height();
    var offsetTwo = offset + $(".process").height();
    var offsetThree = offsetTwo + $(".plans").height();
    var offsetFour = offsetThree + $(".locations").height();

    $(".sticky_links").removeClass("active");
    $(".sticky_links").addClass("inactive");

    if (scrolled < offset) {
    } 
    else if (scrolled <= offsetTwo) {
        $("#link_about").addClass("active");
        $("#link_about").removeClass("inactive");
    }
    else if (scrolled <= offsetThree) {
        $("#link_plans").addClass("active");
        $("#link_plans").removeClass("inactive");
    }
    else if (scrolled <= offsetFour) {
        $("#link_locations").addClass("active");
        $("#link_locations").removeClass("inactive");
    }
    else {
        $(".sticky_links").removeClass("active");
        $(".sticky_links").addClass("inactive");
    }
}

function slideshow() {
    var $active = $('.slideshow li.inView');
    if ( $active.length == 0 ) $active = $('.slideshow li:last');
    var $next = $active.next().length ? $active.next()
                                      : $('.slideshow li:first');

    $active.removeClass('inView');

    $next.css({opacity: 0.0})
        .addClass('inView')
        .animate({opacity: 1.0}, 1000, function(){
        });
}
