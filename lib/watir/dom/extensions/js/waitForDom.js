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


function Watir() {
  this.domReady = 0;
  this.event = 'DOMSubtreeModified';
  this.startedModifying = false;
};

// Binds DOM event to element.
Watir.prototype.bindDomEvent = function() {
  var el = this.element;
  var event = this.event;

  var bind = function(func) {
    if (el.addEventListener) {
      el.addEventListener(event, func, false);
    } else {
      el.attachEvent('on' + event, func);
    }
  }

  this.bindedForceReady = Underscore.bind(Underscore.debounce(this.forceReady, this.interval), this);
  this.bindedStartModifying = Underscore.bind(Underscore.once(this.startModifying, this.interval), this);

  bind(this.bindedForceReady);
  bind(this.bindedStartModifying);
}

// Unbinds DOM event from element.
Watir.prototype.unbindDomEvent = function() {
  var el = this.element;
  var event = this.event;

  var unbind = function(func) {
    if (el.removeEventListener) {
      el.removeEventListener(event, func, false);
    } else {
      el.detachEvent('on' + event, func);
    }
  }

  unbind(this.bindedForceReady);
  unbind(this.bindedStartModifying);
}

// Forces DOM readiness.
Watir.prototype.forceReady = function() {
  var that = this;

  Underscore.once(function() {
    that.unbindDomEvent();
    that.domReady -= 1;
  })();
}

// TODO add comment
Watir.prototype.startModifying = function() {
  this.startedModifying = true;
}

window.watir = new Watir();

// enable DOM ready flag stating that DOM is changing
watir.domReady += 1;

// assign element passed by Watir
watir.element = arguments[0];

// set timeouts in ms
watir.interval = arguments[1] * 1000;
watir.delay    = arguments[2] * 1000;

// bind event
watir.bindDomEvent();

// exit if DOM is not being modified
Underscore.delay(function() {
  if (!watir.startedModifying) {
    watir.forceReady();
  }
}, watir.delay);
