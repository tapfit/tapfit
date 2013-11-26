var casper = require('casper').create(
  {
    verbose: true,
    logLevel: 'debug',
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

    console.log(output);

    var keys = Object.keys(output);
     
    var returnHash = {};

    for (var j = 0; j < keys.length; j++) {
      var key = keys[j];

      var curDate = key.trim().split(/\s/);
      curDate.splice(0, 1);

      var d = Date.parse(curDate.join(' '));

      var inputDate = Date.parse(date);

      console.log(curDate.join(' '));
      if (d !== inputDate)
      {
        continue;
      }

      console.log(key);

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
            this.click('a[name="' + linkName + '"]');
            
            wait('div.userHTML');

            var description = this.evaluate(function() {

              var text = __utils__.findOne('div.userHTML').textContent;

              return text;
            });

            classInfo['description'] = description;
          }

          console.log('description: ' + classInfo['description']);

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

    console.log(JSON.stringify(returnHash));

  },
  function() {
    console.log("failed to get the table");
    this.capture('failedTable.png');    
  });
});

casper.run();


function wait(div)
{
  sleep(0.5);
  var num = 0;
  while (!casper.exists(div)) {
    num = num + 1;
    sleep(0.5);

    if (num > 20)
    {
      casper.evaluate(function() {
        var el = document.querySelector('div.userHTML');
        __utils__.echo("element: " + el);

        el = document.querySelector('tr.evenRow');

        __utils__.echo("row element: " + el);
      });
      
      console.log("div exists?: " + casper.exists('div.userHTML') + ", div passed in: " + div);

      break;
    }
  }
}

function sleep(seconds) 
{
    var e = new Date().getTime() + (seconds * 1000);
      while (new Date().getTime() <= e) {}
}

function isValidDate(d) {
    if ( Object.prototype.toString.call(d) !== "[object Date]" )
          return false;
      return !isNaN(d.getTime());
}
