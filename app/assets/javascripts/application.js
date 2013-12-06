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
            if ($('[name="' + $.attr(this, 'href').substr(1) + '"]').length || $('[name="' + $.attr(this, 'href').substr(2) + '"]').length) {
                $('html, body').animate({
                    scrollTop: $('[name="' + $.attr(this, 'href').substr(1) + '"]').offset().top,
                }, 500, function(){
                    anchorClick();
                });
            }
        });
        
        // Uncomment this for splash page slideshow
        // setInterval(slideshow, 3000);

        // Handle stickyDiv on document ready
        handleStickyDiv();
    }

    $('#quantity').bind('change',function(e){
        displayOrderModal($('#quantity').val());
    });
});

/* Scroll the background layers */
function handleStickyDiv(){
    var scrolled = $(window).scrollTop();
    var offset = $("#banner").height() - $("header#top").height();
    var offsetTwo = offset + $(".process").outerHeight( true );
    var offsetThree = offsetTwo + $(".features").outerHeight( true );
    var offsetFour = offsetThree + $(".plans").outerHeight( true );
    var offsetFive = offsetFour + $(".cities").outerHeight( true );
    var offsetSix = offsetFive + $(".locations").outerHeight( true );

    $(".sticky_links").removeClass("active");
    $(".sticky_links").addClass("inactive");

    if (scrolled < offset) {
    } 
    else if (scrolled <= offsetTwo) {
        $("#link_about").addClass("active");
        $("#link_about").removeClass("inactive");
    }
    else if (scrolled <= offsetThree) {
        $("#link_features").addClass("active");
        $("#link_features").removeClass("inactive");
    }
    else if (scrolled <= offsetFour) {
        $("#link_plans").addClass("active");
        $("#link_plans").removeClass("inactive");
    }
    else if (scrolled <= offsetFive) {
        $("#link_cities").addClass("active");
        $("#link_cities").removeClass("inactive");
    }
    else {
        $("#link_locations").addClass("active");
        $("#link_locations").removeClass("inactive");
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

function displayOrderModal(package_id) {

    $("#quantity").val(package_id);

    var price = packages[0]['amount'];
    var total = packages[0]['fit_coins'];
    var discount = Math.round((1-price/total)*100);

    $(".original-price").html("$<del>" + total + "</del>");
    $(".quantity").html(discount + "%<br><span class='small'>discount</span>");
    $(".total").html("$" + price);

    $.each( packages, function(key, value) {
        if (value['id'] == package_id) {
            
            price = value['amount'];
            total = value['fit_coins'];
            discount = Math.round((1-price/total)*100);

            $(".original-price").html("$<del>" + total + "</del>");
            $(".quantity").html(discount + "%<br><span class='small'>discount</span>");
            $(".total").html("$" + price);
    
            _gaq.push(['_trackEvent', 'Purchase', 'clicked', total.toString()]);
        }
    });

    $(".content-modal").fadeIn();
}

function closeOrderModal() {
    $(".content-modal").fadeOut();
}

function trackPurchase() {
    _gaq.push(['_trackEvent', 'Purchase', 'submitted']);
}
        
function anchorClick() {
    _gaq.push(['_trackPageview', {
        'page': location.pathname + location.search + location.hash,
        'title': location.hash.substring(1)}]);
}
