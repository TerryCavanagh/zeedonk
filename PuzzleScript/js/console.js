function jumpToLine(i) {

    var code = parent.form1.code;

    var editor = code.editorreference;

    // editor.getLineHandle does not help as it does not return the reference of line.    
    editor.scrollIntoView(Math.max(i - 1 - 10,0));
    editor.scrollIntoView(i - 1 + 10);
    editor.scrollIntoView(Math.max(i - 1,0));
    editor.setCursor(Math.max(i - 1,0), 0);
}

var consolecache = [];
function consolePrint(text,urgent) {
	if (urgent===undefined) {
		urgent=false;
	}
	if (cache_console_messages&&urgent==false) {		
		consolecache.push(text);
	} else {
		addToConsole(text);
	}
}


var cache_n = 0;

function addToConsole(text) {
	cache = document.createElement("div");
	cache.id = "cache" + cache_n;
	cache.innerHTML = text;
	cache_n++;
	
	var code = document.getElementById('consoletextarea');
	code.appendChild(cache);
	consolecache=[];
	var objDiv = document.getElementById('lowerarea');
	objDiv.scrollTop = objDiv.scrollHeight;
}

function consoleCacheDump() {
	if (cache_console_messages===false) {
		return;
	}
	
	var lastline = "";
	var times_repeated = 0;
	var summarised_message = "<br>";
	for (var i = 0; i < consolecache.length; i++) {
		if (consolecache[i] == lastline) {
			times_repeated++;
		} else {
			lastline = consolecache[i];
			if (times_repeated > 0) {
				summarised_message = summarised_message + " (x" + (times_repeated + 1) + ")";
			}
			summarised_message += "<br>"
			summarised_message += lastline;
			times_repeated = 0;
		}
	}
	

	addToConsole(summarised_message);
}

function consoleError(text) {	
        var errorString = '<span class="errorText">' + text + '</span>';
        consolePrint(errorString,true);
}
function clearConsole() {
	var code = document.getElementById('consoletextarea');
	code.innerHTML = '';
	var objDiv = document.getElementById('lowerarea');
	objDiv.scrollTop = objDiv.scrollHeight;
}

function logError(str, lineNumber,urgent) {
    if (typeof linenum==="undefined"){
        return logErrorNoLine(str,true);
    }
    if (compiling||urgent) {
        if (lineNumber === undefined) {
            return logErrorNoLine(str);
        }
        var errorString = '<a onclick="jumpToLine(' + lineNumber.toString() + ');"  href="javascript:void(0);"><span class="errorTextLineNumber"> line ' + lineNumber.toString() + '</span></a> : ' + '<span class="errorText">' + str + '</span>';
         if (errorStrings.indexOf(errorString) >= 0 && !urgent) {
            //do nothing, duplicate error
         } else {
            consolePrint(errorString,true);
            errorStrings.push(errorString);
            errorCount++;
        }
    }
}

function logWarning(str, lineNumber,urgent) {
    if (compiling||urgent) {
        if (lineNumber === undefined) {
            return logErrorNoLine(str);
        }
        var errorString = '<a onclick="jumpToLine(' + lineNumber.toString() + ');"  href="javascript:void(0);"><span class="errorTextLineNumber"> line ' + lineNumber.toString() + '</span></a> : ' + '<span class="warningText">' + str + '</span>';
         if (errorStrings.indexOf(errorString) >= 0 && !urgent) {
            //do nothing, duplicate error
         } else {
            consolePrint(errorString,true);
            errorStrings.push(errorString);
        }
    }
}


function logWarningNoLine(str,urgent) {
    if (compiling||urgent) {
        var errorString = '<a onclick="jumpToLine(' + lineNumber.toString() + ');"  href="javascript:void(0);"><span class="errorTextLineNumber"> line ' + lineNumber.toString() + '</span></a> : ' + '<span class="warningText">' + str + '</span>';
         if (errorStrings.indexOf(errorString) >= 0 && !urgent) {
            //do nothing, duplicate error
         } else {
            consolePrint(errorString,true);
            errorStrings.push(errorString);
        }
    }
}

function logErrorNoLine(str,urgent) {
    if (compiling||urgent) {
        var errorString = '<span class="errorText">' + str + '</span>';
         if (errorStrings.indexOf(errorString) >= 0 && !urgent) {
            //do nothing, duplicate error
         } else {
            consolePrint(errorString,true);
            errorStrings.push(errorString);
        }
        errorCount++;
    }
}


var clearConsoleClick = document.getElementById("clearConsoleClick");
clearConsoleClick.addEventListener("click", clearConsole, false);