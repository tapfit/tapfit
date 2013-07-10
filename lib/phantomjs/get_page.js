var args = require('system').args;
var url = '';

function strip(html)
{
  var tmp = document.createElement("DIV");
  tmp.innerHTML = html;
  return tmp.textContent||tmp.innerText;
}

args.forEach(function(arg, i) {
  console.log(i+'::'+arg);
});

if (args.length != 2) {
  console.log("need a url to open page: " + args[1]);
  phantom.exit(1);
} else {
  url = args[1];
  renderPage(url);
}

function renderPage(url) {
  var page = require('webpage').create();
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
        console.log(page.content);
        phantom.exit();
      });
                              
    } else {
      console.log("failed to open page");
      phantom.exit();
    }
  });
}
