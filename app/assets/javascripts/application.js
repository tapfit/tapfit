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

var previousOffset;

$(document).ready(function() {
    
    var timer; 

    /* Scroll event handler */
    $(window).bind('scroll',function(e){
        clearTimeout(timer);
        timer = setTimeout(parralaxScrolling, 100);
        handleStickyDiv();
    });
    
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
        $(".stickyDiv h4").html("A single membership to your city's best fitness. <a href='#packages'>Pre-Order Today</a>");
        $("body").css("padding-top", "0");
    } 
    else if (scrolled <= offsetTwo) {
        $(".stickyDiv").addClass("dock");
        $(".stickyDiv h4").text("Mobility is a breeze. Ain't no commitements");
        $("body").css("padding-top", $(".stickyDiv").height());
    } 
    else if (scrolled <= offsetThree) {
        $(".stickyDiv h4").text("Working out is more fun when it's social"); 
    }
    else if (scrolled <= offsetFour) {
        $(".stickyDiv h4").text("Variety is the essence of life. And life is TapFit.");
    }

    if (scrolled >= offsetFour) {
        $(".stickyDiv").css("top", offsetFour-scrolled + "px");
    }
    else {
        $(".stickyDiv").css("top", "0");
    }
}

function parralaxScrolling(){
    var scrolled = $(window).scrollTop();
    var marginOne = parseInt($("#iphone-1").css("margin-top")); 
    var marginTwo = parseInt($("#iphone-2").css("margin-right")); 
    var marginThree = parseInt($("#iphone-3").css("margin-top"));
    
    var offset = $("#banner").height() + $("#top").height();
    var offsetTwo = offset + $(".about").height();
    var offsetThree = offsetTwo + $(".benefits").height();
    var offsetFour = offsetThree + $(".wrapup").height();

    if (scrolled - previousOffset > 0) {
        if (scrolled <= offset) {
        }
        else if (scrolled <= offsetThree) {
            $("#iphone-2").animate({
                marginLeft: "0px",
            }, 500, function() {
            });
        }
        else if (scrolled <= offsetFour) {
            $("#iphone-3").animate({
                opacity: "1",
            }, 500, function() {
            });
        }
    }
    else {
        if (scrolled <= offset) {
            $("#iphone-2").animate({
                marginLeft: "-1000px",
            }, 500, function() {
            });
        }
        else if (scrolled <= offsetThree) {
        }
    }
   
    previousOffset = scrolled;
}
