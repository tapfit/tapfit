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
    
    //var timer; 

    /* Scroll event handler */
    $(window).bind('scroll',function(e){

        /*if (isAnimating == false) {
            clearTimeout(timer);
            timer = setTimeout(onePageScrolling, 50);
        }*/

        parralaxScrolling();
        handleStickyDiv();
    });
    
    parralaxScrolling();
    handleStickyDiv();
});

/* Scroll the background layers */
function handleStickyDiv(){
    var scrolled = $(window).scrollTop();
    var offset = $("#banner").height() + $("#top").height();
    var offsetTwo = offset + $(".about").height();
    var offsetThree = offsetTwo + $(".benefits").height();
    var offsetFour = offsetThree + $(".wrapup").height();

    if (scrolled < offset) {
        $(".stickyDiv").removeClass("dock");
        $(".stickyDiv h4").text("A single membership to your city's best fitness.");
        $("body").css("padding-top", "0");
    } 
    else if (scrolled <= offsetTwo) {
        $(".stickyDiv").addClass("dock");
        $(".stickyDiv h4").text("Finally...the freedom to work out whenever and however you want.");
        $("body").css("padding-top", $(".stickyDiv").height());
    } 
    else if (scrolled <= offsetThree) {
        $(".stickyDiv h4").text("Any workout, any class, everywhere you are.");
    }
    else if (scrolled <= offsetFour) {
        $(".stickyDiv h4").text("No more contracts or commitments. TapFit is fitness that fits your life.");
    }

    if (scrolled >= offsetFour) {
        $(".stickyDiv").css("top", offsetFour-scrolled + "px");
    }
    else {
        $(".stickyDiv").css("top", "0");
    }
}

function onePageScrolling(){
    
    isAnimating = true;

    var scrolled = $(window).scrollTop();
    var offset = $("#banner").height() + $("#top").height();
    var offsetTwo = offset + $(".about").height();
    var offsetThree = offsetTwo + $(".benefits").height() + 50;
    var offsetFour = offsetThree + $(".wrapup").height();
    var scrollTo = 0;

    if (scrolled <= offsetFour) {
        $('body').addClass('stop-scrolling');

        if (scrolled >= previousOffset) {
            // The user is scrolling down
            if (scrolled <= offset) {
                scrollTo = offset;
            } else if (scrolled <= offsetTwo) {
                scrollTo = offsetTwo;
            } else if (scrolled <= offsetThree) {
                scrollTo = offsetThree;
            } else if (scrolled <= offsetFour) {
                scrollTo = offsetFour;
            } else {
            }
        }
        else {
            // The user is scrolling up
            if (scrolled <= offset) {
                scrollTo = 0;
            } else if (scrolled <= offsetTwo) {
                scrollTo = offset;
            } else if (scrolled <= offsetThree) {
                scrollTo = offsetTwo;
            } else {
                scrollTo = offsetThree;
            }
        }
        
        $('body').animate({
            scrollTop: scrollTo,
        }, 500, function() {
            previousOffset = scrolled;
            isAnimating = false;
            $('body').removeClass('stop-scrolling');
        });
    }
    else {
        previousOffset = scrolled;
        isAnimating = false;
    }
    
}

function parralaxScrolling(){

    var scrolled = $(window).scrollTop();
    var phoneWidth = parseInt($(".iphone").css("width"));
    var phoneTop = parseInt($(".iphone").css("top"));
    var phoneOpacity = $("#iphone-1").css("opacity");
    var phoneOpacityTwo = $("#iphone-2").css("opacity");
    
    var offset = $("#banner").height() + $("#top").height();
    var offsetTwo = offset + $(".about").height();
    var offsetThree = offsetTwo + $(".benefits").height() + 80;
    var offsetFour = offsetThree + $(".wrapup").height();

    if (scrolled <= offset) {
        $(".iphone").css("top", "70px");
    } else if (scrolled <= offsetTwo) {
        $(".iphone").css({
            "top": scrolled-493 + "px",
        });
        $("#iphone-1").css("opacity", (offsetTwo-2*(scrolled-offset))/offsetTwo);
    } else if (scrolled <= offsetThree) {
        $(".iphone").css({
            "top": scrolled-493 + "px",
        });
        $("#iphone-2").css("opacity", (offsetThree-3*(scrolled-offsetTwo))/offsetThree);
    } else if (scrolled <= offsetFour) {
    } else {
    }
}
