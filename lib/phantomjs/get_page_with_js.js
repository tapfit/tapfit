var page = require('webpage').create();
var args = require('system').args;
var url = '';

function waitFor(testFx, onReady, timeOutMillis) {
  var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 10000, //< Default Max Timout is 5s
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
    }, 500);
};

if (args.length != 3) {
  for (var i = 0; i < args.length; i++) {
    console.log('arg: ' + i + ': ' + args[i]);
  }
  console.log('invalid call, length: ' + args.length);
  phantom.exit(1);
} else {
  url = args[1];
  div = args[2];
  page.open(url, function (status) {
    if (status !== 'success') {
      console.log('Unable to load the address!');
      phantom.exit();
    } else {
      waitFor(
        function () {
          return page.evaluate(function () {
            return $(div).is(':visible');
          });
        },
        function () {
          console.log(page.content);
          phantom.exit();
        }, 5000);
    }
  });
}
