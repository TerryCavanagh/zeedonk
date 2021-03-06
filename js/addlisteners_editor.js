
for (var i=0;i<10;i++) {
	var idname = "newsound"+i;
	var el = document.getElementById(idname);
    el.addEventListener("click", (function(n){return function(){return newSound(n);};})(i), false);
}

//var soundButtonPress = document.getElementById("soundButtonPress");
//soundButtonPress.addEventListener("click", buttonPress, false);

var runClickLink = document.getElementById("runClickLink");
runClickLink.addEventListener("click", runClick, false);

var runClickLink = document.getElementById("stopClickLink");
runClickLink.addEventListener("click", stopClick, false);

//var referenceClickLink = document.getElementById("referenceClickLink");
//referenceClickLink.addEventListener("click", referenceClick, false);

var saveClickLink = document.getElementById("saveClickLink");
saveClickLink.addEventListener("click", saveClick, false);

var newClickLink = document.getElementById("newClickLink");
newClickLink.addEventListener("click", newClick, false);

var shareClickLink = document.getElementById("shareClickLink");
shareClickLink.addEventListener("click", shareClick, false);

var exampleDropdown = document.getElementById("exampleDropdown");
exampleDropdown.addEventListener("change", dropdownChange, false);

var loadDropDown = document.getElementById("loadDropDown");
loadDropDown.addEventListener("change", loadDropDownChange, false);

var horizontalDragbar = document.getElementById("horizontaldragbar");
horizontalDragbar.addEventListener("mousedown", horizontalDragbarMouseDown, false);

var verticalDragbar = document.getElementById("verticaldragbar");
verticalDragbar.addEventListener("mousedown", verticalDragbarMouseDown, false);

window.addEventListener("resize", resize_all, false);
window.addEventListener("load", reset_panels, false);

window.onbeforeunload = function (e) {
  var e = e || window.event;
  var msg = 'You have unsaved changes!';

  if(_editorDirty) {      

    // For IE and Firefox prior to version 4
    if (e) {
      e.returnValue = msg;
    }

    // For Safari
    return msg;
  }
};

