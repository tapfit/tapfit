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

$(document).ready(function() {

/* Scroll event handler */
$(window).bind('scroll',function(e){
parallaxScroll();
});

$(window).bind('resize',function(e){
adjustElementsOnResize();
});

$('a.link_to_top').click(function(){
$('html, body').animate({
scrollTop:$('#header').offset().top
}, 1000, function() {
parallaxScroll(); // Callback is required for iOS
});
return false;
});

$('a.link_to_benefits').click(function(){
$('html, body').animate({
scrollTop:$('#benefits').offset().top
}, 1000, function() {
parallaxScroll(); // Callback is required for iOS
});
return false;
});

$('a.link_to_what').click(function(){
$('html, body').animate({
scrollTop:$('#what').offset().top
}, 1000, function() {
parallaxScroll(); // Callback is required for iOS
});
return false;
});

$('a.link_to_who').click(function(){
$('html, body').animate({
scrollTop:$('#who').offset().top
}, 1000, function() {
parallaxScroll(); // Callback is required for iOS
});
return false;
});

$('a.link_to_trainers').click(function(){
$('html, body').animate({
scrollTop:$('#trainers').offset().top
}, 1000, function() {
parallaxScroll(); // Callback is required for iOS
});
return false;
});

$('a.link_to_wellness').click(function(){
$('html, body').animate({
scrollTop:$('#wellness').offset().top
}, 1000, function() {
parallaxScroll(); // Callback is required for iOS
});
return false;
});

});

/* Scroll the background layers */
function parallaxScroll(){
var scrolled = $(window).scrollTop();
$('.splash_phone').css('top',(0-(scrolled*.25))+'px');
$('.benefits_ss').css('top',(400-(scrolled*.40))+'px');
//$('#what_icon').css('left',(1200-(scrolled*.25))+'px');
//$('#who_icon').css('top',(920-(scrolled*.25))+'px');
//$('#trainers_icon').css('left',(1080-(scrolled*.10))+'px');
//$('#parallax-bg2').css('top',(0-(scrolled*.5))+'px');
//$('#parallax-bg3').css('top',(0-(scrolled*.75))+'px');
}

/* Adjust screen elements such as the phone on resize */
function adjustElementsOnResize(){
var bodyHeight = $(window).height();
//$('.splash_phone').css('height',bodyHeight*.8+'px');
}

