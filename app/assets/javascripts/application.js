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
    $(window).bind('scroll',function(e){
        handleStickyDiv();
    });
    handleStickyDiv();
});

/* Scroll the background layers */
function handleStickyDiv(){
    var scrolled = $(window).scrollTop();
    var offset = $("#banner").height() + $("#top").height();
    var offsetTwo = offset + $(".about").height();

    if (scrolled < offset) {
        $(".stickyDiv").removeClass("dock");
        $("body").css("padding-top", "0");
    } 
    else if (scrolled <= offsetTwo) {
        $(".stickyDiv").addClass("dock");
        $("body").css("padding-top", $(".stickyDiv").height());
    } 

    if (scrolled >= offsetTwo) {
        $(".stickyDiv").css("top", offsetTwo-scrolled + "px");
    }
    else {
        $(".stickyDiv").css("top", "0");
    }
}
