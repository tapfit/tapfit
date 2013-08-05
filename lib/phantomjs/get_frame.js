var args = require('system').args;
var url = '';
var div = '';

function strip(html)
{
  var tmp = document.createElement("DIV");
  tmp.innerHTML = html;
  return tmp.textContent||tmp.innerText;
}

if (args.length != 3) {
  console.log("need a url to open page: " + args[1]);
  phantom.exit(1);
} else {
  url = args[1];
  div = args[2];
  renderPage(url);
}

function waitFor(testFx, onReady, timeOutMillis) {
  var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 20000, //< Default Max Timout is 5s
    start = new Date().getTime(),
    condition = false,
    interval = setInterval(function () {
      if ((new Date().getTime() - start < maxtimeOutMillis) && !condition) {
        // If not time-out yet and condition not yet fulfilled
        condition = (typeof (testFx) === "string" ? eval(testFx) : testFx()); //< defensive code
      } else {
        if (!condition) {
          // If condition still not fulfilled (timeout but condition is 'false')
          // console.log("'waitFor()' timeout");
          typeof (onReady) === "string" ? eval(onReady) : onReady();
          clearInterval(interval);
          phantom.exit(1);
        } else {
          console.log("'waitFor()' finished in " + (new Date().getTime() - start) + "ms.");
          typeof (onReady) === "string" ? eval(onReady) : onReady(); //< Do what it's supposed to do once the condition is fulfilled
          clearInterval(interval); //< Stop this interval
        }
      }
    }, 20000);
};

function renderPage(url) {
  var page = require('webpage').create();
  page.settings.userAgent = 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.36 Safari/537.36';
  var redirectURL = null;
      
  
  page.onResourceReceived = function(resource) {
    if (url == resource.url && resource.redirectURL) { 
      redirectURL = resource.redirectURL;
    }
  };

  page.open(url, function(status) {
    if (redirectURL) {
      renderPage(redirectURL);
    } else if (status == 'success') {
      
      page.open(url, function (status) {
        waitFor(
          function () {
            return page.evaluate(function () {
              return $(div).is(':visible');
            });
          },
          function () {
            var title = page.evaluate(function() {
          
              return document.getElementsByTagName('frame')[0].contentWindow.document.documentElement.innerHTML;
        
            });
         
            console.log(title);
            phantom.exit();

          }, 5000);
        });
                              
    } else {
      console.log("failed to open page");
      phantom.exit();
    }
  });

}
