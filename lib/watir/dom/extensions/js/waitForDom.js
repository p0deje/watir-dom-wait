/**
 * There is a number of required functions provided by Underscore.js,
 * but since we don't want to depend on it, we just copy-paste required
 * things.
 *
 * See http://underscorejs.org/docs/underscore.html for explanation of functions.
 */

var Underscore = {
  slice: Array.prototype.slice,

  nativeBind: Function.prototype.bind,

  once: function(func) {
    var ran = false, memo;
    return function() {
      if (ran) return memo;
      ran = true;
      memo = func.apply(this, arguments);
      func = null;
      return memo;
    };
  },

  delay: function(func, wait) {
    var args = this.slice.call(arguments, 2);
    return setTimeout(function(){ return func.apply(null, args); }, wait);
  },

  debounce: function(func, wait, immediate) {
    var timeout, result;
    return function() {
      var context = this, args = arguments;
      var later = function() {
        timeout = null;
        if (!immediate) result = func.apply(context, args);
      };
      var callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow) result = func.apply(context, args);
      return result;
    };
  },

  bind: function(func, context) {
    if (func.bind === this.nativeBind && this.nativeBind) return this.nativeBind.apply(func, this.slice.call(arguments, 1));
    var args = this.slice.call(arguments, 2);
    return function() {
      return func.apply(context, args.concat(this.slice.call(arguments)));
    };
  }
};

function Watir(options) {
  this.set(options);

  this.startedModifying = false;
  this.domReady = 1;
  this.observers = {
    forceReady:     null,
    startModifying: null
  }

  this.addObservers();
  this.exitOnTimeout();
};

Watir.prototype.set = function(options) {
  if (options == null) {
    options = {};
  }

  this.el       = options.el;
  this.interval = options.interval;
  this.delay    = options.delay;

  this.forceReady     = this.wrappedForceReady();
  this.startModifying = this.wrappedStartModifying();
}

Watir.prototype.exitOnTimeout = function() {
  var that = this;

  Underscore.delay(function() {
    if (!that.startedModifying) {
      that._forceReady();
    }
  }, this.delay);
};

Watir.prototype.addObservers = function() {
  this.observers.forceReady     = this.observe(this.el, this.forceReady);
  this.observers.startModifying = this.observe(this.el, this.startModifying);
}

Watir.prototype.removeObservers = function() {
  this.unobserve(this.observers.forceReady);
  this.unobserve(this.observers.startModifying);
}

Watir.prototype.observe = function(el, fn) {
  var observer = new MutationObserver(function(mutations) {
    fn();
  });
  var config = {
    attributes:    true,
    childList:     true,
    characterData: true,
    subtree:       true
  };
  observer.observe(el, config);
  return observer;
};

Watir.prototype.unobserve = function(observer) {
  observer.disconnect();
};

Watir.prototype.wrappedForceReady = function() {
  return Underscore.bind(Underscore.debounce(this._forceReady, this.interval), this);
};

Watir.prototype.wrappedStartModifying = function() {
  return Underscore.bind(Underscore.once(this._startModifying, this.interval), this);
}

Watir.prototype._forceReady = function(mutations) {
  var that = this;

  Underscore.once(function() {
    that.removeObservers();
    that.domReady -= 1;
  })();
}

Watir.prototype._startModifying = function() {
  this.startedModifying = true;
}

window.watir = new Watir({
  el:       arguments[0],
  interval: arguments[1] * 1000,
  delay:    arguments[2] * 1000,
});
