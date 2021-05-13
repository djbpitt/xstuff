/* CAUTION: if you edit this file, use a text editor that shows
 * matching parens () and braces {} automatically and saves as
 * plain text in the UTF-8 character encoding.
 */
/* Revisions:
** 2020-07-16 : CMSMcQ : Commented out the variable 
**                       headingsThatResetExpansion.
**                       Commented out the debugging messages. 
**                       Add unconditional call to function 
**                       expandNavToCurrentPage() in
**                       restoreStateofNavPanel(); see comments
**                       for rationale.
** 2020-06-26 : CMSMcQ : added a lot of console log entries, all
**                       marked with comments reading // debug ...
**                       to simplify turning them on and off.
**                       They are helpful in learning what function
**                       is called when.  (At least, they helped me.)
** 2020-06-24 : CMSMcQ : begin attempt at documenting what these
**                       functions do; resequence functions.
** 2020-03-23 : CMSMcQ : fixing interaction of search function with
**                       layout at top of nav bar.  Inject dummy sup,
**                       add class="left" to some i, suppress
**                       injection of padding-left on parent.
** 2020-03-17 : CMSMcQ : in function InsertSearchBox, change
**                       guillemet to U+25C2 left pointing triangle
** 2020-03-13 : CMSMcQ : restore some console.log calls, debug,
**                       make assignment of onclick routine to
**                       accordion fold controls more cautious,
**                       comment the console logging back out.
** 2019-12-13 : CMSMcQ : comment out some console.log calls,
**                       add comment about making definitions
**                       of onload and onunload unconditional.
** 2019-12-06 : CMSMcQ : make navbar unexpand work (I think)
** 2019-03-29 : lee : v 1.6
*/

/****************************************************************
** 1. Preliminary and setup
****************************************************************/

'use strict'; /* see the browser console for error messages */

/* If autoExpandNav is true, the Javascript here will do its best
 * to remember the state of the navigation bar (which things are
 * expanded or collapsed) between pages, so the user has the
 * sense that the nav bar is stable.  If false, then not.
 *
 * But n.b. the 'headingsThatResetExpansion' variable below can
 * change this behavior for some headings.  Headings that match
 * the selector given in that variable have a different behavior:
 * when they are clicked, the nav bar reverts to its default
 * state (which varies from page to page).
 */

var autoExpandNav = true;

/* If autoExpandNav is true, you can give a CSS selector as the
 * value of headingsThatResetExpansion after this comment; elements
 * it matches will reset the expansion to the default when you click
 * them - e.g. so clicking the Elements header in the nav bar takes
 * you to a page with only Elements expanded (the default), and not
 * whatever the user had selected, but clicking elsewhere doesn't
 * change the user's selection.
 * 
 * In JavaScript we can use :has() in a selector, which helps a lot:
 * div#nav li:has(ol) label a
 * will match a link (a) in a label element that is itself in
 * an li that also contains an ol; in XPath this might be,
 *   //div[@id = 'nav']//li[ol]//label/a
 * 
 * To disable this behavior, comment out the declaration.
 * To make all expandable headings have the described behavior,
 * set it to "div#nav li:has(ol)>label>a".
 */

// var headingsThatResetExpansion = "div#nav li:has(ol)>label>a";

var prefix = "MT-JATS-";

// debug ...
// console.log("................................................................");
// console.log(". Loading taglib.js ...");
// console.log("................................................................");
// console.log("In taglib.js, autoExpandNav is " + autoExpandNav);
// ... gubed

/****************************************************************
** 2. Common infrastructure:  setValue(), getValue()
****************************************************************/

/* These functions manage more-or-less persistent local storage,
   to allow the nav panel to retain the same look even when the
   user follows a hyperlink to another document.
   
   Notable values remembered here are:

     bchider (1 if bchider checked, else 0)
     navstate (array of 0 or 1); shows which headings are expanded
        by recording the values of the invisible input elements.
     navscroll (value of nav bar's scrollTop property)

     expandsection (yes or no); used in restoreStateofNavPanel() 
        as guard on expandNavtoCurrentPage().  Set by clicking on a 
        heading that resets expansion (see variable above; see
        $document.ready() for the code that sets the function).
        Cleared by restoreStateofNavPanel().
*/

// We use window.name if it is set by us, and local storage
// otherwise. The window.name property does not persist between
// sessions, but it does persist across different folders;
// browser local storage persists across sessions but not across
// different folders.
function getValue(name)
{
    var wn = window.name;

    // debug ...
    // console.log("Getting value of " + name);
    // ... gubed

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

    // debug ...
    // console.log("Setting value of " + name + " to " + value);
    // ... gubed
    

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

/****************************************************************
** 3. Managing the nav bar:  rememberStateofNavPanel(),
** restoreStateofNavPanel(), resetStateofNavPanel(),
** expandNavtoCurrentPage(), and insertSearchBox()
****************************************************************/

/****************************************************************
** rememberStateofNavPanel():  set values for bchider, navstate,
** and navscroll in persistent memory.
*/

function rememberStateofNavPanel()
{
    /* save the state of the nav panel itself */
    var nav = document.getElementById("bchider").checked;
    setValue("bchider", nav ? "1" : 0);

    /* if we are not doing auto-expanding we have finished: */
    if (!autoExpandNav) {
        // debug ...
        // console.log("rememberStateofNavPanel - nothing to record");
        // ... gubed
        return;
    }
    // debug ...
    // console.log("rememberStateofNavPanel - recording ...");
    // ... gubed

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
    /* result is now a string of 0 and 1 indicating state:
       1 for expanded, 0 for unexpanded */
    setValue("navstate", result);
    setValue("navscroll", thePanelScroll);
    
    // debug ...
    // console.log("rememberStateofNavPanel - state is " + result);
    // console.log("rememberStateofNavPanel - navscroll is " + thePanelScroll);
    // ... gubed
    
}

/****************************************************************
** restoreStateofNavPanel(): get values for bchider, navstate,
** and navscroll from persistent memory, use them to adjust the 
** nav bar.
*/

function restoreStateofNavPanel()
{
    // always remember hidden/unhidden state of navbar:
    var navstate = getValue("bchider");
    var nav = document.getElementById("bchider");
    
    // debug ...
    // console.log("restoreStateofNavPanel() has been called.");
    // ... gubed
    
    if (navstate === "1") {
        nav.checked = true;
    } else if (navstate === "0") {
        nav.checked = false;
    }

    var thePanel = document.getElementById("nav");
    if (!thePanel) { // no panel found, so can't do much!
        return;
    }

    if (getValue("expandsection") == "yespleaselicklickwagwag") {
        /* Turn off the flag we set to mean "expand the nav section
         * to the current page on loading" because we just loading it
         * and are about to obey the command!
         */
        setValue("expandsection", "nononannette");

        // debug ...
        // console.log("restoreStateofNavPanel() found expandsection set, calling expandnavToCurrentPage().");
        // ... gubed    

        /* now do it */
        expandnavToCurrentPage();
        return;
    }

    if (!autoExpandNav) {
        // debug ...
        // console.log("restoreStateofNavPanel() found autoExpandNav false, returning.");
        // ... gubed    
        return;
    }

    // debug ...
    // console.log("restoreStateofNavPanel() found autoExpandNav true, setting state of navbar controls.");
    // ... gubed        
    
    var state = getValue("navstate");
    if (state && state.length) {
        var items = thePanel.getElementsByTagName("input");

        // console.log("restore state length is " + state.length);

        for (var i = 0; i < state.length; i++) {
            // console.log("try " + i + " -- " + state.substring(i, i + 1));
            if (state.substring(i, i + 1) === "1") {
                if (!items[i.checked]) {
                    // This item was not already checked, so we must expand it.
                    // debug ...
                    // console.log("restoreStateofNavPanel() expanding item " + i);
                    // ... gubed
                }
                items[i].checked = true;
            } else {
                if (items[i.checked]) {
                    // This item was checked by default, so we must unexpand it.
                    // debug ...
                    // console.log("restoreStateofNavPanel() unexpanding item " + i);
                    // ... gubed
                }
                items[i].checked = false;
            }
        }
    }

    /* fix the scroll position after expanding stuff */
    var thePanelScroll = getValue("navscroll");
    thePanel.scrollTop = 0 + thePanelScroll;
    // debug ...
    // console.log("restoreStateofNavPanel() setting scrollTop: " + thePanelScroll);
    // ... gubed

    /* If the nav bar is preserved across calls (i.e. if autoExpandNav
    ** is true), and the user clicked on an unexpanded heading that is 
    ** not in the set of headingsThatResetExpansion (e.g. because that
    ** variable does not exist), then as things stand the heading 
    ** won't be expanded in the new page.  But that violates the 
    ** principle that when the user is looking at a page with an
    ** expandable heading (e.g. the element section intro), that heading
    ** should be expanded in the nav bar.
    **
    ** So now we unconditionally expand that heading.  If the heading
    ** was already expanded, this will have no effect.  If the heading
    ** resets the nav bar, we won't ever reach this point (but the
    ** heading will be expanded by default in any case).
    */
    expandnavToCurrentPage();
}

/****************************************************************
** resetStateofNavPanel():  set navstate and navscroll to "".
** (Does nothing about bchider.  Possibly intentional.)
** Called when user clicks on a heading selected by the variable
** headingsThatResetExpansion.
*/

function resetStateofNavPanel()
{
    // debug ...
    // console.log("resetStateofNavPanel() has been called.");
    // ... gubed

    /* Set expansion to the default */
    setValue("navstate", "");

    /* arrange to scroll the panel back to the top */
    setValue("navscroll", "");
}


/****************************************************************
** expandNavtoCurrentPage():  called by restoreStateofNavPanel()
** (if the page being loaded was reached by clicking on a heading
** that resets the nav panel).
*/

function expandnavToCurrentPage()
{
    var thePanel = document.getElementById("nav");
    var Here = document.location;

    // debug ...
    // console.log("expandnavToCurrentPage() has been called.");
    // ... gubed
    
    /* We need to find the link in the nav panel to the current page.
     * if there is one, we need to expand its section, and also any
     * ancestors (so the expanded part can be seen).
     *
     * To do this we'll use jQuery, so we get a list of all a elements
     * in the nav panel with "div#nav a" and then we filter that (just
     * like an XPath [predicate]) to keep only ones whose href property
     * is equal to the current document location.
     *
     * The actual @href attributes are relative, so we can't compare them
     * to the document location, which is absolute. Instead, we need to use
     * the href property on the 'a' element node in the DOM tree, so we use
     * get(0) to get the first DOM node -- like XPath, the filter expression
     * only operates on one node at a time, so there's actually always
     * exactly one node! -- and use its .href property. This is always
     * an absolute URL, mantained by the browser. (is that true in IE6?
     * not sure).
     *
     * The index argument to the filter function is just the position in the
     * input sequence, since jQuery folks don't know about position() :)
     *
     * Reminder: we have the following structure:
     * ol
     *   . . .
     *   li (the element in pointToMe)
     *     checkbox
     *     label
     *       a
     *      ol ... 
     *   The level is expanded by CSS whenever the checkbox is selected.
     */

    $("div#nav a").filter(
         (index, aElem) => $(aElem).get(0).href.localeCompare(document.location) == 0)
    /* now get all the ancestors that are li elements... */
        .parents("li")
    /* now get all _their_ checkbox descendents... */
        .children("input[type=checkbox]")
    /* and turn them on: */
        .prop("checked", true);
    /* whew! */

    // debug ...
    // console.log("expandnavToCurrentPage() has done its work.");
    // ... gubed
    
}

/****************************************************************
** insertSearchBox():  when the document is being read from 
** the file system, does nothing; otherwise (the document is
** probably being read over HTTP(S) and Javascript may work)
** inserts a search box to allow simple searching.
*/

function insertSearchBox()
{
    // debug ...
    // console.log("insertSearchBox() has been called.");
    // ... gubed
    
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
              "<sup>&#xA0;</sup>"
              + "<i class='searchhelp'>"
              + "<i><b>?</b></i>"
              + "<i class='left'>Use &#x25C2; to hide the navigation sidebar.</i>"
              + "<i class='left'>Use &#x21DC; to unexpand headings in the sidebar.</i>"
              + "<i class='left'>Search box instructions:</i>"
              + "<i>Use &lt; to search for an element.</i>"
              + "<i>Use @ to search for an attribute.</i>"
              + "<i>Use % to search for a parameter entity.</i>"
              + "<i>Or just type for a substring search.</i>"
              + "</i>"
      );
      // $("label[for=bchider]").css("padding-left", "calc(23% - 3.6rem - 5px)");       
    }
}

/****************************************************************
** 4. Opening and closing all details elements
****************************************************************/

function opendetailelements()
{
    var myNodeList = document.querySelectorAll('details');
    for (var i = 0; i < myNodeList.length; i++) {
        myNodeList[i].setAttribute("open", "open");
    }
}

function closedetailelements()
{
    var myNodeList = document.querySelectorAll('details');
    for (var i = 0; i < myNodeList.length; i++) {
        myNodeList[i].removeAttribute("open");
    }
}


/****************************************************************
** 5. $document.ready() function
****************************************************************/

$(document).ready( function(){
    
    // debug ...
    // console.log("$(document).ready() has been called.");
    // ... gubed
    
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
    
    // debug ...
    // console.log("$(document).ready() is calling restoreStateofNavPanel().");
    // ... gubed
    
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

    /* if we are going to treat headings specially in the nav pane,
     * we have to do it after they have loaded, i.e. here...
     */
    if (autoExpandNav && headingsThatResetExpansion) {
        
        // debug ...
        // console.log("$(document).ready() has found autoExpandNav true and heading mode: " + headingsThatResetExpansion);
        // $( headingsThatResetExpansion ).css("color", "red");
        // ... gubed
        
        $( headingsThatResetExpansion ).click(function(){
            // debug ...
            // alert("Clicked on a heading that resets expansion ");
            // ... gubed
            resetStateofNavPanel();
            autoExpandNav = false; // so we don't save it on exit

            /* Arrange to expand the target section in the next 
               page opened */
            setValue("expandsection", "yespleaselicklickwagwag");
            // For debugging, use an alert here so you can see
            // any errors in the browser console before the
            // log is cleared to move to th next page...
            // alert("clack on a heading");
        });
    }
});


/****************************************************************
** 6. window.onload() and window.onunload()
****************************************************************/

/* 2019-12 MSM removed the conditional around the definitions of
** window.onunload() and window.onload(), because the unexpand-all
** button in the nav bar was hiding the nav bar instead of 
** unexpanding things.  Perhaps there needs to be a conditional 
** around 'rememberStateofNavPanel', but I don't know because I
** don't understand what suppressing it was intended to accomplish.
**
** 2020-06 MSM wrapped calls to rememberStateofNavPanel and
** restoreStateofNavPanel in conditionals.  If autoExpandNav is 
** false, we do not want to remember or restore the state of the
** nav panel.
*/
/* if (autoExpandNav) { */
    /* document.ready is not always called, e.g. if
     * the network is slow and a secondary resource did not
     * load, most likely the search index.
     */

window.onunload = function(e) {
    // debug ...
    // console.log("window.onunload() has been called.");
    // ... gubed

    if (!e) { e = window.event; } /* for IE */
    if (autoExpandNav) {
        rememberStateofNavPanel();
    }
    return e;
}

window.onload = function(e) {
    if (!e) { e = window.event; } /* for IE */
    
    // debug ...
    // console.log("window.onload() has been called.");
    // ... gubed

    if (autoExpandNav) {
        // debug ...
        // console.log("window.onload() is calling restoreStateofNavPanel().");
        // ... gubed
        restoreStateofNavPanel();
    }
    
    /* Enable the accordion controls */
    var OpenButton = document.querySelector("div.openclose span.opendetailelements");
    var CloseButton = document.querySelector("div.openclose span.closedetailelements");
    if (OpenButton) { OpenButton.onclick = opendetailelements; }
    // console.log("Hi, window.onload here.  onclick for opening details has been set.  Or not.");
    if (CloseButton) { CloseButton.onclick = closedetailelements; }
    // console.log("Hi, window.onload here.  onclick for closing details has been set.  If it exists.");
    /*
    document.querySelector("div.openclose span.closedetailelements").onclick = closedetailelements;
    document.querySelector("div.openclose span.opendetailelements").onclick = opendetailelements;
    */
    
    /* Enable the 'unexpand nav bar' functionality */
    $("#phew").click(function() {
        // console.log("Hi, #phew click here.  navstate = " + getValue("navstate"));
        setValue("navstate",
                 getValue("navstate").replace(/1/g,'0'));
        // console.log("phew: Now navstate = " + getValue("navstate")); 
        restoreStateofNavPanel();
        return false; /* don't bubble the click event upwards to hide nav */
    }); 
    return e;
}


/*
 * $Id: taglib.js,v 1.6 2019/03/29 05:13:30 lee Exp $
 *
 */
