# watir-dom-wait [![Build Status](https://travis-ci.org/p0deje/watir-dom-wait.png?branch=master)](https://travis-ci.org/p0deje/watir-dom-wait) [![Gem Version](https://badge.fury.io/rb/watir-dom-wait.png)](http://badge.fury.io/rb/watir-dom-wait)

Watir extension which provides DOM-based waiting.

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

Simple DOM waiting:

```ruby
browser.div(class: 'test').wait_until_dom_changed
```

With element returned:

```ruby
browser.div(class: 'test').when_dom_changed.a(class: 'link').click
```

With passing block:

```ruby
browser.div(class: 'test').when_dom_changed do |div|
  div.a(class: 'link').click
end
```

With timeout of 10 seconds:

```ruby
browser.div(class: 'test').when_dom_changed(timeout: 10).a(class: 'link').click
```

With interval of checking for subtree modifications of 2 seconds:

```ruby
browser.div(class: 'test').when_dom_changed(interval: 2).a(class: 'link').click
```

With 5 seconds delay of how long to waiting for DOM to start modifying:

```ruby
browser.div(class: 'test').when_dom_changed(delay: 5).a(class: 'link').click
```

Timeouts can also be specified statically:

```ruby
Watir::Dom::Wait.timeout  = 1
Watir::Dom::Wait.delay    = 1
Watir::Dom::Wait.interval = 0.15
```

## How it works

By attaching `DOMSubtreeModified` event to element. It's supported in all major browsers (except Presto-powered Opera).

Note, that it also rescues `Selenium::WebDriver::Error::StaleElementReferenceError` when waits for DOM.

## Contributors

* [Alex Rodionov](https://github.com/p0deje)
* [Sasha Koss](https://github.com/kossnocorp)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
