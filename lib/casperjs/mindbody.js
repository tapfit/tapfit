var casper = require('casper').create(
  {
    pageSettings: 
              {
                loadImages: true,
                loadPlugins: true,
                userAgent: 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.2 Safari/537.36'
              }

  });

var url = "";
if (casper.cli.has("url")){
  url = casper.cli.get("url");
}
else
{
  console.log("need to enter url: --url=?");
}

if (casper.cli.has("date")) {
  var date = casper.cli.get("date");

  url = url + "&sDate=" + date;
}
else
{
  console.log("need to enter date: --date=?");
}

var returnHash = {};

casper.start(url);

casper.then(function() {

  this.page.switchToFrame("mainFrame");
  // this.test.assertVisible("#classSchedule-mainTable");
});

casper.then(function() {

  this.waitUntilVisible('table#classSchedule-mainTable', function() {
    var output = this.evaluate(function() {
      var table = __utils__.findOne('table#classSchedule-mainTable');
      var rows = table.getElementsByTagName("TR"); 
      
      var output = {};

      var date = "";

      try {

        for (var i = 0; i < rows.length; i++) {
          var tds = rows[i].getElementsByTagName("TD");

          if (tds.length == 1) {
            date = tds[0].textContent;

            output[date] = "";
          }
          else {
            output[date] = output[date] + "^^^^";
            for (var j = 0; j < tds.length; j++) {
              output[date] = output[date] + "&*^" + tds[j].outerHTML;
            }
          }
        }
      }
      catch(error)
      {
        __utils__.echo(error);
      }
      
      return output;

    });    

    var keys = Object.keys(output);     

    for (var j = 0; j < keys.length; j++) {
      key = keys[j];

      var curDate = key.trim().split(/\s/);
      curDate.splice(0, 1);

      var d = Date.parse(curDate.join(' '));

      var inputDate = Date.parse(date);

      if (d !== inputDate)
      {
        continue;
      }

      var value = output[key];

      var daysClasses = new Array();

      try 
      {

        var values = value.split("^^^^");
                
        for (var i = 1; i < values.length; i++) {
    
          var tds = values[i].split("&*^");

          var classInfo = {};
          var wrapper = document.createElement('div');
          wrapper.innerHTML = tds[3];
          var td = wrapper.firstChild;
          
          classInfo['name'] = td.textContent;

          wrapper = document.createElement('div');
          wrapper.innerHTML = tds[1];
          var startTime = wrapper.firstChild.textContent;
          classInfo['start_time'] = startTime;

          var signUpText = tds[2];
          signUpText = signUpText.replace('"', '\" ');
          classInfo['signup_button'] = signUpText;

          wrapper = document.createElement('div');
          wrapper.innerHTML = tds[4];
          var instructor = wrapper.firstChild.textContent;

          classInfo['instructor'] = instructor;

          var linkName = null;
          try  
          {
            linkName = td.getAttribute("name");
          }
          catch(error)
          {
            //console.log(error);
          }

          if (linkName == null) 
          {
            classInfo['description'] = td.textContent;
          }
          else
          {
            var thenFunction = function(signup_button, key, linkName) {
              return function() {
                var retrieveDescription = function(signup_button, key) {
                  return function() {
                    var description = this.evaluate(function() {
                      var el = __utils__.findOne('div.userHTML');
                      return el.textContent;
                    });
                    var index = compareHashValue(returnHash, key, signup_button);
                    if (index !== null) {
                      returnHash[key][index]['description'] = description;
                    }

                  };
                };

                var onTimeout = function(signup_button, key) {
                  return function() {
                    var index = compareHashValue(returnHash, key, signup_button);
                    if (index !== null) {
                      returnHash[key][index]['description'] = returnHash[key][index]['name'];
                    }
                  };
                };

                this.click('a[name="' + linkName + '"]');

                sleep(1);

                this.waitFor(check, retrieveDescription(signup_button, key), onTimeout(signup_button, key), 10000);
          
              };
            };

            this.then(thenFunction(classInfo['signup_button'], key, linkName));
          }

          daysClasses[i - 1] = classInfo;

        }
      }
      catch(error)
      {
        console.log(error);
      }

      if (daysClasses.length > 0) {
        returnHash[key] = daysClasses;
      }
    }

  },
  function() {
    console.log("failed to get the table");
    this.capture('failedTable.png');    
  }, 30000);
});

casper.then(function() {
  console.log(JSON.stringify(returnHash));
});

casper.run();

function check() 
{
  sleep(1);
  return casper.evaluate(function() {
    return document.querySelector('div.userHTML') !== null;
  });
}

function compareHashValue(hash, key, classInfo)
{

  try
  {
    if (hash[key] !== null){
      for (var i = 0; i < hash[key].length; i++) {
        var info = hash[key][i];
        if (info['signup_button'] == classInfo) {
          return i;
        }
      }
    }
    return null;
  }
  catch(error)
  {
    console.log("error: " + error);
    return null;
  }
}

function isValidDate(d) {
    if ( Object.prototype.toString.call(d) !== "[object Date]" )
          return false;
      return !isNaN(d.getTime());
}

function sleep(delay) {
  var start = new Date().getTime();
  while (new Date().getTime() < start + delay);
}
