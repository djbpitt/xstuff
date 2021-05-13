var prefix = "MT-JATS-";

function insertSearchBox()
{
    if (window.location.protocol === "file:") {
	return; /* AJAX does not work in this case */
    }

    var thePanel = document.getElementById("searchform");

    if (thePanel) {
      thePanel.innerHTML =
          "<input autocomplete='off' name='q' size='12' id='Searchbar' class='searchbox ui-autocomplete-input' type='text'>"
      ;

      /* now add help for it */
      $("#searchinfogoeshere").append(
              "<i class='searchhelp'>"
              + "<i><b>?</b></i>"
              + "<i>Use « to hide the navigation sidebar.</i>"
              + "<i>Search box instructions:</i>"
              + "<i>Use &lt; to search for an element.</i>"
              + "<i>Use @ to search for an attribute.</i>"
              + "<i>Use % to search for a parameter entity.</i>"
              + "<i>Or just type for a substring search.</i>"
              + "</i>"
      );
    }
}

function rememberStateofNavPanel()
{
    var thePanel = document.getElementById("nav");

    if (!thePanel) {
        return;
    }

    var thePanelScroll = thePanel.scrollTop;

    var items = thePanel.getElementsByTagName("input");
    var result = "";
    for (var i = 0; i < items.length; i++) {
        if (items[i].checked) {
            result = result + "1"
        } else {
            result = result + "0"
        }
    }
    /* result is now a string of 0 and 1 indicating open/closed state */
    setValue("navstate", result);
    setValue("navscroll", thePanelScroll);

    /* also save the state of the nav panel itself */
    var nav = document.getElementById("bchider").checked;
    setValue("bchider", nav ? "1" : 0);
}

// We use window.name if it is set by us, and local storage
// otherwise. The window.name property does not persist between
// sessions, but it does persist across different folders;
// browser local storage persists across sessions but not across
// different folders.
function getValue(name)
{
    var wn = window.name;

    if (window.name && window.name !== "" && window.name.indexOf(prefix) == 0){
	// We will use the format
	// prefix-name=value;
	// I have not implemented escaping, so there is no way
	// to include a ; in a value.
	var names = window.name.split(";");
	var start = prefix + name + "=";
	for (var i = 0; i < names.length; i++) {
	    if (names[i].indexOf(start) == 0) {
		var result = names[i];
		return result.substring(start.length);
		// use temporary var to get the substring method
	    }
	}
    }

    // console.log("getValue looked in window.name but did not find " + name);

    var result = localStorage.getItem(prefix + name);
    if (result) {
	setValue(name, result);
    }
    return result;
}

function setValue(name, value)
{
    // read the window.name values and replace the one we are setting

    if (name.indexOf(prefix) == 0) {
	name = name.subtring(prefix.length);
    }
    
    // console.log("setValue(" + name + ", " + value + ") - wn is " + window.name);

    var names = window.name.split(";");
    var which = -1;
    var start = prefix + name + "=";

    if (names && names.length) {
	which = names.length;
	for (var i = 0; i < names.length; i++) {
	    if (names[i].indexOf(start) == 0) {
		which = i;
	    }
	}
    }

    names[which] = start + value;

    var newname = "";
    for (var i = 0; i < names.length; i++) {
	if (i > 0) {
	    newname = newname + ";";
	}
	newname = newname + names[i];
    }

    if (newname && newname !== "") {
	// console.log("set " + name + " to " + value + ": " + newname);
	window.name = newname;
    }
    localStorage.setItem(prefix + name, value);
}

function restoreStateofNavPanel()
{
    var state = getValue("navstate");
    var thePanel = document.getElementById("nav");

    if (!state || !state.length || !thePanel) {
	// console.log("no saved panel state");
        return;
    }

    var items = thePanel.getElementsByTagName("input");

    // console.log("restore state length is " + state.length);

    for (var i = 0; i < state.length; i++) {
        // console.log("try " + i + " -- " + state.substring(i, i + 1));
        if (state.substring(i, i + 1) === "1") {
	    if (!items[i.checked]) {
		// console.log("expand item " + i);
	    }
            items[i].checked = true;
        } else {
	    if (items[i.checked]) {
		// console.log("close item " + i);
	    }
            items[i].checked = false;
        }
    }
    var thePanelScroll = getValue("navscroll");
    thePanel.scrollTop = 0 + thePanelScroll;
    // console.log("scroll: " + thePanelScroll);

    var navstate = getValue("bchider");
    var nav = document.getElementById("bchider");
    if (navstate === "1") {
        nav.checked = true;
    } else if (navstate === "0") {
        nav.checked = false;
    }
    // console.log("nav hider: " + navstate);
}

$(document).ready( function(){
   insertSearchBox();
   $("#searchform").each(function(){
     this.reset();
   });
   $("#Searchbar").each(function(){
   var $that = $(this); /* boxed */
      this.value = 'Search...';

      $that.css('color', $("#nav a").css("color"));
      $that.focus(function() {
        this.value = '';
        $that.css('color', 'black');
      });
      $that.blur(function(){
        this.value = 'Search...';
        $that.css('color', $("#nav a").css("color"));
      });

  });
  restoreStateofNavPanel();
  var where = $("body").attr("data-where");
  // console.log("where is " + where);
  $.ajax( { url: where + "autocomplete-items.json", dataType: "json"} )
  .done( function(xhr) {
    $('#Searchbar').autocomplete(
      {
        autoFocus: true, /* focus first item when shown */
        delay: 50, /* ms before we search */
        minLength: 1,
        source: xhr,
        select: function(event, ui) {
          /* ui.label - the shown thing
           * ui.value - the URL
           */
           $("#searchform").each(function(){
             this.reset();
           });
           var page = ui.item.value;
           if (where === "") {
             if (page.slice(0, 3) === "../") {
               page = page.slice(3);
             } else {
               page.replace("/\.\./", "/");
             }
           }
           window.location = page;
        }
      } /* end of options */
    ) /* autocomplete */
    })/* done */
    ;
  }
);

window.onunload = function(e) {
    if (!e) { e = window.event; } /* for IE */
    rememberStateofNavPanel();
    return e;
}

window.onload = function(e) {
    if (!e) { e = window.event; } /* for IE */
    restoreStateofNavPanel();
    return e;
}
