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
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function() {
   
    /* ---------------------------- */
    /* Setup Google Map Global Vars */ 
    /* ---------------------------- */
    var latlng = new google.maps.LatLng(39.1000, -84.5167);
    var settings = {
        zoom: 12,
        center: latlng,
        scrollwheel: false,
        mapTypeControl: true,
        mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
        navigationControl: true,
        navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL},
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    window.gmap = new google.maps.Map(document.getElementById("map-canvas"), settings);

    /* ------------------- */
    /* Track Google Events */
    /* ------------------- */
    trackGoogleEvents();
    google.maps.event.addDomListener(window, 'load', initialize);
    
    /* -------------------------------------- */
    /* Reset Google Map on Dropdown Selection */
    /* -------------------------------------- */
    $('.city a').click(function(){
        var newCityString = this.id;
        var latLonString = this.name;
        var latLonParts = latLonString.split(",");
        var newCenter = new google.maps.LatLng(latLonParts[0], latLonParts[1]);

        gmap.setOptions({
            center: newCenter,
            zoom: 12
        });

        $('.your-city a').text(newCityString);

        return false;
    });

    /* ---------------------- */
    /* Handle Pre-Order Modal */
    /* ---------------------- */
    $('.preorder-button').click(function(){
        displayOrderModal(this.id);
        return false;
    });
    
    /* ---------------------------- */
    /* Change Modal Display Amounts */
    /* ---------------------------- */
    $('#quantity').bind('change',function(e){
        displayOrderModal($('#quantity').val());
    });
    
    /* -------------------- */
    /* Scroll event handler */
    /* -------------------- */
    if (screen.width > 500) {
        $('a').click(function(){
            if ($('[name="' + $.attr(this, 'href').substr(1) + '"]').length) {
                $('html, body').animate({
                    scrollTop: $('[name="' + $.attr(this, 'href').substr(1) + '"]').offset().top,
                }, 500, function(){
                    anchorClick();
                });
            } else if ($('[name="' + $.attr(this, 'href').substr(2) + '"]').length) {
                $('html, body').animate({
                    scrollTop: $('[name="' + $.attr(this, 'href').substr(2) + '"]').offset().top,
                }, 500, function(){
                    anchorClick();
                });
            }
        });
    }
});

/* --------------------------------- */
/* Handle display of pre-order modal */
/* --------------------------------- */
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

/* --------------------- */
/* Google Event Tracking */
/* --------------------- */

/* 1. Tracking purchase events */
function trackPurchase() {
    _gaq.push(['_trackEvent', 'Purchase', 'submitted']);
}

/* 2. Tracking anchors as page clicks */
function anchorClick() {
    _gaq.push(['_trackPageview', {
        'page': location.pathname + location.search + location.hash,
        'title': location.hash.substring(1)}]);
}

/* 3. Track iPhone and Android button clicks */
function trackGoogleEvents() {
    // iPhone
    $('.iphone-download-button').click(function(){
        _gaq.push(['_trackEvent', 'Download Button', 'clicked', 'iPhone']);
    });
    // Android
    $('.android-download-button').click(function(){
        _gaq.push(['_trackEvent', 'Download Button', 'clicked', 'Android']);
    });
    // Interest Button
    $('.interest-button').click(function(){
        _gaq.push(['_trackEvent', 'Interest Button', 'clicked', this.id]);
    });
}

/* ------- end of Google Tracking ------- */


/* --------------------------------- */
/* Initialization of Google Maps API */
/* --------------------------------- */
function initialize() {
    
    var locations = [
        ['The Gym at Carew Towers', 39.10084, -84.51323],
        ['The Yoga Bar', 39.1055571, -84.5108673],
        ['Bella Forza Fitness', 39.159744, -84.417765],
        ['Pendleton Pilates - Downtown', 39.10928, -84.506504],
        ['Cardio Dance Party', 39.1649316, -84.4130655],
        ['CORE a Movement Studio', 39.1111792, -84.5157747],
        ['YogahOMe', 39.270849, -84.32657],
        ['Revolution Fitness', 39.1594829, -84.4209857],
        ['Elemental OM', 39.22869, -84.353502],
        ['Yoga Alive', 39.2035953, -84.3696394],
        ['Cincinnati Yoga School', 39.1830538, -84.4273112],
        ['The Breathing Room Pilates and Yoga', 39.1330777, -84.4594937],
        ['YMCA - Central Parkway', 39.107212, -84.518711],
        ['Studio S', 39.1390598, -84.4417212],
        ['Pure Barre', 39.152442, -84.430756],
        ['YMCA - Carl H. Lindner', 39.111144, -84.528854],
        ['YMCA - Melrose', 39.131205, -84.489717],
        ['YMCA - Duck Creek', 39.169489, -84.409684],
        ['YMCA - Blue Ash', 39.223695, -84.375418],
        ['YMCA - Clippard', 39.233637, -84.597211],
        ['YMCA - Powel Crosley', 39.241509, -84.510669],
        ['YMCA - Gamble-Nippert', 39.148318, -84.60516],
        ['YMCA - M.E. Lyons', 39.09054, -84.328495],
        ['On Your Mark Coaching & Training - Bucktown', 41.9138847, -87.6774323],
        ['Atlas CrossFit', 41.9012544, -87.6431378],
        ['River North CrossFit', 41.8932521, -87.6363977],
        ['Barre Bee Fit', 41.9167097, -87.6577974],
        ['Nature Yoga', 41.9031445, -87.6779867],
        ['Yoga Now - Gold Coast',  41.89608, -87.6329276],
        ['FunDance Fitness', 41.737211, -87.582987],
        ['Bare Feet Power Yoga', 41.8804822, -87.6524788],
        ['Harmony Mind Body Fitness', 41.917785, -87.652345],
        ['The Yoga Boutique', 41.952246, -87.648284],
        ['Sana Vita Studio', 41.8910584, -87.6592908],
        ['Bikram Yoga West Loop',  41.87918, -87.6430883],
        ['Tandang Garimot Martial Arts', 41.9352302, -87.6625821],
        ['Flow Studios - Lincoln Park', 41.923184,  -87.63933],
        ['Tejas Yoga', 41.865598, -87.626239],
        ['Lateral Fitness', 41.895852, -87.636599],
        ['Division St. CrossFit', 41.9030143, -87.6810734],
        ['The Chicago School of Hot Yoga', 41.9264022, -87.6501308],
        ['Flex Pilates Chicago', 41.8973412, -87.6351556],
        ['Barre Bee Fit', 41.9034555, -87.6314024],
        ['Bikram Yoga Andersonville', 41.9858259, -87.6692729],
        ['Sixpax', 41.8649401, -87.6239355],
        ['Om on the Range - Lakeview', 41.9505722, -87.6733206],
        ['Chaturanga Holistic Fitness', 41.794884, -87.588002],
        ['Spring Pilates Wellness Center', 41.9444315, -87.6635916],
        ['Power Sculpt Fitness', 41.938976, -87.6677231],
        ['TruHarmony Yoga', 41.917848, -87.656364],
        ['Chi-Town Shakti', 41.998064, -87.6647568],
        ['Sat Nam Yoga', 41.883273, -87.660034],
        ['Core Chicago Pilates & Fitness', 41.9281372, -87.6585444],
        ['Yoga Fuzion', 41.890262, -87.631646],
        ['Mind Art Core', 41.9718651, -87.6792478],
        ['All About Dance', 41.9109405, -87.641206],
        ['Pilates Chicago - Pilates Chicago', 42.0079853, -87.6622784],
        ['Thrive Fitness', 41.9614493, -87.6784897],
        ['Frog Temple Pilates', 41.9160578, -87.6690699],
        ['Real Ryder Revolution Chicago', 41.890262, -87.631646],
        ['Mazi Dance Fitness Centre', 41.9104704, -87.6774544],
        ['Urbancore Pilates & Fitness', 41.9484079, -87.6748908],
        ['Kareem Team Fitness', 41.890536, -87.679889],
        ['Reach Pilates Studio', 41.943504, -87.6795269],
        ['YogaShopChicago', 41.950683, -87.743573],
        ['Morning Bird Studio', 41.9494861, -87.6497041],
        ['At the Core',  41.86057, -87.622876],
        ['Chicago River North Pilates', 41.897189, -87.635209],
        ['Bezz Training', 41.9895602, -87.669857],
        ['Rock Solid Health', 41.910596, -87.691124],
        ['Shred 415', 41.904116,  -87.63572],
        ['THE MERCURY METHOD', 41.9081408, -87.6741061],
        ['Bikram Yoga Chicago - South Loop', 41.8720925, -87.6294633],
        ['Bikram Yoga Chicago - Lincoln Park', 41.9323365, -87.6449175],
        ['Yoga Loft Chicago', 41.8900083, -87.628553],
        ['Village Yoga Chicago', 41.908519, -87.6505156],
        ['Train Chicago Studios', 41.896265, -87.636159],
        ['Core Fitness Chicago', 41.911164, -87.654897],
        ['Chicago Dance - River North', 41.8947105, -87.6394215],
        ['CrossTown Fitness Chicago', 41.8813752, -87.6533581],
        ['Sweat Chicago', 41.903737, -87.628417],
        ['Power Yoga Chicago - Lakeview', 41.931681, -87.6572359],
        ['yogaview - yogaview Elston', 41.922283, -87.672209],
        ['Bikram Yoga Chicago - Wicker Park', 41.906176, -87.671081],
        ['The Fulton Fit House', 41.886537, -87.648418],
        ['Core Evolution', 41.8943727, -87.6327797],
        ['Total Results Training', 41.9137534, -87.6565672],
        ['Village Yoga Chicago', 41.897165, -87.667665],
        ['Training with Victoria D. Gray', 41.8827663, -87.636707],
        ['Healing Foundations', 41.9396318, -87.6813649],
        ['Coming Spring 2014!', 37.7833, -122.4167],
        ['Coming Spring 2014!', 40.6700, -73.9400]
    ];

    var infowindow = new google.maps.InfoWindow();
    var marker, i;

    for (i = 0; i < locations.length; i++) {
        marker = new google.maps.Marker({
            position: new google.maps.LatLng(locations[i][1], locations[i][2]),
            map: gmap
        });

        google.maps.event.addListener(marker, 'click', (function(marker, i) {
            return function() {
                infowindow.setContent(locations[i][0]);
                infowindow.open(gmap, marker);
            }
        })(marker, i));
    }
}
