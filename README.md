# watir-dom-wait [![Build Status](https://travis-ci.org/p0deje/watir-dom-wait.svg?branch=master)](https://travis-ci.org/p0deje/watir-dom-wait) [![Gem Version](https://badge.fury.io/rb/watir-dom-wait.svg)](http://badge.fury.io/rb/watir-dom-wait)

[Watir](https://github.com/watir/watir) extension which provides with method to check for DOM changes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'watir-dom-wait'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install watir-dom-wait
```

## Usage

Require to monkey patch `Watir::Element` instance:

```ruby
require 'watir-dom-wait'
```

There is only one method added:

```ruby
browser.div(class: 'test').dom_changed?
```

which returns `true` if DOM is changed inside element or `false`
if DOM is currently changing.

Default delay of waiting until DOM starts changing is `1.1` seconds, but
can be changed:

```ruby
browser.div(class: 'test').dom_changed?(delay: 2.5)
```

You probably don't want to use the method directly. Instead, you can combine
usage of the method with built-in Watir waiting mechanism:

```ruby
browser.div(class: 'test').wait_until(&:dom_changed?)
```

## How it works

Using [MutationObserver](https://developer.mozilla.org/en/docs/Web/API/MutationObserver).

## Contributors

* [Alex Rodionov](https://github.com/p0deje)
* [Sasha Koss](https://github.com/kossnocorp)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
