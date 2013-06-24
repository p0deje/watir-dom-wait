# watir-dom-wait

Watir extension which provides DOM-based waiting.

## Installation

Add this line to your application's Gemfile:

    gem 'watir-dom-wait'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install watir-dom-wait

## Usage

```ruby
browser = Watir::Browser.new
browser.a(text: "This link modifies DOM subtree")
browser.div(id: "dom_modify").when_dom_changed.button(text: "Added via JS").click
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
