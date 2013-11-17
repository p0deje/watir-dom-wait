// arguments from WebDriver
var element  = arguments[0];
var interval = arguments[1] * 1000;
var delay    = arguments[2] * 1000;
var timeout  = arguments[3] * 1000;
var exit     = arguments[4];

// flag that DOM has started modifying
var startedModifying = false;

// exits codes
var exits = {
  modified: 0, // DOM modifications have started and successfully finished
  timeout:  1, // DOM modifications have started but exceeded timeout
  noop:     2, // DOM modifications have not started
}

/**
 * Copy-paste of Underscore.js debounce function.
 * @see http://underscorejs.org/docs/underscore.html#section-67
 */
var _debounce = function(func, wait, immediate) {
  var timeout, args, context, timestamp, result;
  return function() {
    context = this;
    args = arguments;
    timestamp = new Date();
    var later = function() {
      var last = (new Date()) - timestamp;
      if (last < wait) {
        timeout = setTimeout(later, wait - last);
      } else {
        timeout = null;
        if (!immediate) result = func.apply(context, args);
      }
    };
    var callNow = immediate && !timeout;
    if (!timeout) {
      timeout = setTimeout(later, wait);
    }
    if (callNow) result = func.apply(context, args);
    return result;
  };
};

/**
 * Disconnects observer and
 * invokes WebDriver's callback function
 * to show that DOM has finished modifying.
 */
var exitOnModified = _debounce(function() {
  observer.disconnect();
  exit(exits.modified);
}, interval);

/**
 * Disconnects observer and
 * invokes WebDriver's callback function
 * to show that DOM has started modifying
 * but exceeded timeout.
 */
var exitOnTimeout = function() {
  setTimeout(function() {
    observer.disconnect();
    exit(exits.timeout);
  }, timeout);
}

/**
 * Disconnects observer and
 * invokes WebDriver's callback function
 * to show that DOM has not started modifying.
 */
var exitNoop = function() {
  setTimeout(function() {
    if (!startedModifying) {
      observer.disconnect();
      exit(exits.noop);
    }
  }, delay);
}

var observer = new MutationObserver(function() {
  if (!startedModifying) startedModifying = true;
  exitOnModified();
});
var config = { attributes: true, childList: true, characterData: true, subtree: true };
observer.observe(element, config);
exitOnTimeout();
exitNoop();
