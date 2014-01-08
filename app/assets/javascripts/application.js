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
    var latlng = new google.maps.LatLng(41.8819, -87.6278);
    var settings = {
        zoom: 10,
        center: latlng,
        scrollwheel: false,
        mapTypeControl: true,
        mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
        navigationControl: true,
        navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL},
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    if ( document.getElementById('map-canvas') != null ) {
        setupGoogleMap(settings);
    }

    /* ------------------- */
    /* Track Google Events */
    /* ------------------- */
    trackGoogleEvents();
    
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
   
            mixpanel.track("Package button clicked", {
                "Amount": total.toString()
            });
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
    mixpanel.track("Package purchased");
}

/* 2. Tracking anchors as page clicks */
function anchorClick() {
    mixpanel.track(location.hash.substring(1) + " page loaded");
}

/* 3. Track iPhone and Android button clicks */
function trackGoogleEvents() {
    // iPhone
    $('.iphone-download-button').click(function(){
        mixpanel.track("Download button clicked", {
            "Type": "iPhone"
        });

    });
    // Android
    $('.android-download-button').click(function(){
        mixpanel.track("Download button clicked", {
            "Type": "Android"
        });
    });
    // Interest Button
    $('.interest-button').click(function(){
        mixpanel.track("Waitlist button clicked", {
            "Waitlist City": $('.your-city a').text()
        });
    });
}

/* ------- end of Google Tracking ------- */


/* --------------------------------- */
/* Initialization of Google Maps API */
/* --------------------------------- */

function setupGoogleMap(settings) {
    
    window.gmap = new google.maps.Map(document.getElementById("map-canvas"), settings);
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
            zoom: 10
        });

        $('.your-city a').text(newCityString);

        // Track city on map
        mixpanel.track("Map changed", {
            "New City": newCityString
        });

        if (this.id == "New York" || this.id == "San Francisco") {
            $('#map-canvas-overlay').show();
        } else {
            $('#map-canvas-overlay').hide();
        }

        return false;
    });
}

function initialize() {
    
    var locations = [
        ['Pure Wellness', 41.9283134, -87.6489863],
        ['On Your Mark Coaching & Training - Bucktown', 41.9138847, -87.6774323],
        ['Bella Forza Fitness', 39.159744, -84.417765],
        ['Pendleton Pilates - Downtown', 39.10928, -84.506504],
        ['Pendleton Pilates - Hyde Park Square', 39.1397479, -84.4429267],
        ['Cardio Dance Party', 39.1649316, -84.4130655],
        ['The Pilates ConneXion', 39.0221329, -84.584858],
        ['Move Your Hyde Power Yoga', 39.1392393, -84.4417051],
        ['Atlas CrossFit', 41.9012544, -87.6431378],
        ['Heaven Meets Earth', 42.0644293, -87.7125563],
        ['CORE a movement studio', 39.1111792, -84.5157747],
        ['River North CrossFit', 41.8932521, -87.6363977],
        ['Cincinnati Bikram Yoga', 39.159599, -84.4037117],
        ['Fit Philosophie', 39.0871897, -84.4484917],
        ['Simply Power Yoga', 39.1057944, -84.3958009],
        ['Simply Power Yoga', 39.226856, -84.254577],
        ['Fitness Physiques by Nico G', 39.2340067, -84.376737],
        ['Clear Wellness', 39.1265281, -84.4792107],
        ['Move Your Hyde Power Yoga', 39.102547, -84.515796],
        ['LeeLaa Yoga', 39.5589727, -84.2327267],
        ['Daniels Fitness Training', 39.047824, -84.502859],
        ['Barre Bee Fit', 41.9167097, -87.6577974],
        ['Nature Yoga', 41.9031445, -87.6779867],
        ['Yoga Now - Gold Coast', 41.89608, -87.6329276],
        ['Full Body Yoga', 38.990797, -84.69547],
        ['It\'s Working Out', 39.1163076, -84.4372744],
        ['Its Yoga Cincinnati', 39.1438312, -84.5213777],
        ['The Yoga Bar', 39.1055571, -84.5108673],
        ['YogahOMe', 39.270849, -84.32657],
        ['Pendleton Pilates', 39.3827906, -84.3771176],
        ['DRISHTIQ Yoga', 39.3211987, -84.3313767],
        ['FunDance Fitness', 41.737211, -87.582987],
        ['Bare Feet Power Yoga', 41.8804822, -87.6524788],
        ['Harmony Mind Body Fitness', 41.917785, -87.652345],
        ['The Yoga Boutique', 41.952246, -87.648284],
        ['Sana Vita Studio', 41.8910584, -87.6592908],
        ['Bikram Yoga West Loop', 41.87918, -87.6430883],
        ['Tandang Garimot Martial Arts', 41.9352302, -87.6625821],
        ['Flow Studios - Lincoln Park', 41.923184, -87.63933],
        ['Tejas Yoga', 41.865598, -87.626239],
        ['Yoga Tree', 41.9773536, -87.6685125],
        ['Lateral Fitness', 41.895852, -87.636599],
        ['Division St. CrossFit', 41.9030143, -87.6810734],
        ['Revolution Fitness', 39.1594829, -84.4209857],
        ['The Chicago School of Hot Yoga', 41.9264022, -87.6501308],
        ['Flex Pilates Chicago', 41.8973412, -87.6351556],
        ['Barre Bee Fit', 41.9034555, -87.6314024],
        ['Bikram Yoga Andersonville', 41.9858259, -87.6692729],
        ['Sixpax', 41.8649401, -87.6239355],
        ['Om on the Range - Lakeview', 41.9505722, -87.6733206],
        ['Chaturanga Holistic Fitness', 41.794884, -87.588002],
        ['Spring Pilates Wellness Center', 41.9444315, -87.6635916],
        ['Power Sculpt Fitness', 41.938976, -87.6677231],
        ['Down Dog Hot Yoga', 42.0451, -87.682323],
        ['Crossfit E-Town', 42.0566236, -87.6941321],
        ['Grateful Yoga', 42.0469094, -87.6873604],
        ['TruHarmony Yoga', 41.917848, -87.656364],
        ['Elemental OM', 39.22869, -84.353502],
        ['Yoga Alive', 39.2035953, -84.3696394],
        ['Chi-Town Shakti', 41.998064, -87.6647568],
        ['Studio Fit Chicago', 41.917883, -87.653882],
        ['Sat Nam Yoga', 41.883273, -87.660034],
        ['Core Chicago Pilates & Fitness', 41.9281372, -87.6585444],
        ['TriFit', 41.9433059, -87.6747365],
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
        ['Hip Circle Studio', 42.0327971, -87.6807211],
        ['Akemi Fitness Method', 42.0459138, -87.6789685],
        ['Fit Girl Studio', 42.0484793, -87.6855598],
        ['Reach Pilates Studio', 41.943504, -87.6795269],
        ['360.Mind.Body.Soul', 41.7590664, -87.5682457],
        ['Living Fit Chicago', 41.991514, -87.663793],
        ['YogaShopChicago', 41.950683, -87.743573],
        ['Imprint Movement Studio', 42.0584413, -87.6842702],
        ['Yoga with Pooja', 39.351096, -84.329509],
        ['Morning Bird Studio', 41.9494861, -87.6497041],
        ['At the Core', 41.86057, -87.622876],
        ['Chicago River North Pilates', 41.897189, -87.635209],
        ['Bezz Training', 41.9895602, -87.669857],
        ['Cincinnati Yoga School', 39.1830538, -84.4273112],
        ['Pole Kittens - Cincinnati', 39.167515, -84.498481],
        ['The Breathing Room Pilates and Yoga', 39.1330777, -84.4594937],
        ['YogahOMe', 39.15377, -84.427078],
        ['Yoga Alive', 39.1483036, -84.4477242],
        ['BodyMind Balance', 39.1459576, -84.4641912],
        ['Burdo Studios', 39.152484, -84.380469],
        ['Pure Barre', 39.037213, -84.5366449],
        ['Rock Solid Health', 41.910596, -87.691124],
        ['Shred 415', 41.904116, -87.63572],
        ['The Mercury Method', 41.9081408, -87.6741061],
        ['513FIT', 39.158728, -84.404666],
        ['Bikram Yoga Chicago - South Loop', 41.8720925, -87.6294633],
        ['Bikram Yoga Chicago - Lincoln Park', 41.9323365, -87.6449175],
        ['Yoga Loft Chicago', 41.8900083, -87.628553],
        ['Village Yoga Chicago', 41.908519, -87.6505156],
        ['Train Chicago Studios', 41.896265, -87.636159],
        ['Core Fitness Chicago', 41.911164, -87.654897],
        ['Chicago Dance - River North', 41.8947105, -87.6394215],
        ['Modo Yoga Cincinnati', 39.1095952, -84.422518],
        ['Modo Yoga Northern Kentucky', 39.0498658, -84.577167],
        ['Modo Yoga Clifton', 39.127753, -84.51776],
        ['The Gym at Carew Towers', 39.10084, -84.513236],
        ['CrossTown Fitness Chicago', 41.8813752, -87.6533581],
        ['Barre Bee Fit', 41.890123, -87.6323401],
        ['Sweat Chicago', 41.903737, -87.628417],
        ['Pendleton Pilates - Loveland', 39.2534015, -84.2960294],
        ['Eastside Wellness Connections', 39.072862, -84.358282],
        ['The Punch House', 39.155751, -84.469994],
        ['YMCA - Central Parkway', 39.107212, -84.518711],
        ['YMCA - Carl H. Lindner', 39.111144, -84.528854],
        ['YMCA - Melrose', 39.131205, -84.489717],
        ['YMCA - Duck Creek', 39.169489, -84.409684],
        ['YMCA - Blue Ash', 39.223695, -84.375418],
        ['YMCA - Campbell County', 39.060452, -84.451414],
        ['YMCA - Clermont', 39.069546, -84.101948],
        ['YMCA - Clippard', 39.233637, -84.597211],
        ['YMCA - Powel Crosley', 39.241509, -84.510669],
        ['YMCA - Gamble-Nippert', 39.148318, -84.60516],
        ['YMCA - Richard E. Lindner', 39.160595, -84.459178],
        ['YMCA - M.E. Lyons', 39.09054, -84.328495],
        ['YMCA - R.C. Durr', 39.023374, -84.707311],
        ['Power Yoga Chicago - Lakeview', 41.931681, -87.6572359],
        ['yogaview - yogaview Elston', 41.922283, -87.672209],
        ['Bikram Yoga Chicago - Wicker Park', 41.906176, -87.671081],
        ['The Fulton Fit House', 41.886537, -87.648418],
        ['Core Evolution', 41.8943727, -87.6327797],
        ['OneBody', 41.9062643, -87.6486967],
        ['Shred 415', 41.9204505, -87.6630089],
        ['Total Results Training', 41.9137534, -87.6565672],
        ['Village Yoga Chicago', 41.897165, -87.667665],
        ['Training with Victoria D. Gray', 41.8827663, -87.636707],
        ['Healing Foundations', 41.9396318, -87.6813649],
        ['Eb & Flow Yoga Studio', 41.9106351, -87.6740337],
        ['Studio S', 39.1390598, -84.4417212],
        ['Samgha Yoga Shala', 41.9354565, -87.6627143],
        ['Bikram Yoga In the City', 41.894044, -87.627903],
        ['1 on 1 Health Fitness', 41.85319, -87.646838],
        ['The Sweat Box', 41.827151, -87.604763],
        ['Hustle Fitness Corp', 41.9298751, -87.6488118],
        ['Boleros Dance Club', 38.9788672, -84.654797],
        ['Pure Barre', 39.152442, -84.430756],
        ['Kenwood Hot Yoga - Yoga Alive', 39.128355, -84.5155873],
        ['YogahOMe', 39.1437246, -84.3652634],
        ['Pure Barre', 41.907153, -87.63477],
        ['Pure Barre', 41.8947, -87.627962],
        ['Pure Barre', 41.910264, -87.674025],
        ['Pure Barre', 41.940917, -87.668327],
        ['Pure Barre', 42.048466, -87.683909]
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
