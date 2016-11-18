/**
 * Disconnects observer and invokes WebDriver's callback function
 * to show that DOM has started modifying.
 */
var exitOnStartedModifying = function() {
  clearTimeout(exitOnNotStartedModifying);
  observer.disconnect();
  callback(false);
}

/**
 * Disconnects observer and invokes WebDriver's callback function
 * to show that DOM has not started modifying.
 */
var exitOnNotStartedModifying = function() {
  return setTimeout(function() {
    observer.disconnect();
    callback(true);
  }, 1000);
}

// arguments from WebDriver
var element  = arguments[0];
var delay    = arguments[1] * 1000;
var callback = arguments[2];

// start observer
var observer = new MutationObserver(exitOnStartedModifying);
var config = { attributes: true, childList: true, characterData: true, subtree: true };
observer.observe(element, config);

// make sure we exit if DOM has not started modifying
var exitOnNotStartedModifying = exitOnNotStartedModifying();
