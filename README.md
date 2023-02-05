# StyledHelpers

Pre-configure Action View Helpers with
[ActionView::Attributes](https://github.com/seanpdoyle/action_view-attributes)
instances with support for mixing variant styles.

---

Define your variants:

```ruby
# app/helpers/my_styled_helpers.rb
class MyStyledHelpers < StyledHelpers::Helpers
  def link
    styled :a, class: "ring-inset ring-current focus:outline-none focus:ring"
  end

  def button
    styled :button, variants: {
      defaults: {class: "inline-flex items-center justify-center disabled:cursor-none ring-current focus:outline-none focus:ring"},
      color: {
        primary: {class: "bg-purple-900 text-white ring-purple-900 focus:ring-offset-2"},
        secondary: {class: "bg-purple-900/5 text-purple-900/95"},
        tertiary: {class: "bg-white text-purple-900 border border-current/20 hover:bg-opacity-20 aria-expanded:bg-opacity-30"}
      },
      size: {
        small: "text-sm p-1",
        medium: "text-md p-2"
        large: "text-lg p-4"
      }
    }
  end

  def label
    styled :label, variants: {
      defaults: {class: "text-sm"},
      interactive: {
        true: {class: "cursor-pointer peer-focus:ring ring-current focus:outline-none focus:ring"}
      }
    }
  end

  def input
    placeholder = "placeholder:text-current placeholder:text-opacity-95 before:text-opacity-95"

    styled :input, variants: {
      defaults: {class: "ring-current focus:outline-none focus:ring"},
      text: {
        class: ["border-black/20 text-sm", placeholder]
      },
      textarea: styled(:textarea, {
        class: ["min-h-fit border-0 text-sm bg-white", placeholder]
      }),
    }
  end
end

# app/helpers/application_helper.rb
module ApplicationHelper
  def ui
    MyStyledHelpers.new(self)
  end
end
```

From your view templates, invoke [Action View helper methods](https://guides.rubyonrails.org/action_view_helpers.html):

```ruby
ui.link.link_to "A page", "/page"
# => <a class="ring-inset ring-current focus:outline-none focus:ring" href="/page">A page</a>

ui.button.with(color: :primary, size: :large).button_tag "Click Me!", type: :button
# => <button type="button"
# =>         class="ring-current focus:outline-none focus:ring
# =>                inline-flex items-center justify-center disabled:cursor-none bg-purple-900 text-white ring-purple-900 focus:ring-offset-2 text-lg p-4">
# =>   Click Me!
# => </button>
```

You can also invoke the
[tag](https://edgeapi.rubyonrails.org/classes/ActionView/Helpers/TagHelper.html#method-i-tag)
helper. Passing content, keyword arguments, or a block will construct an
element with the pre-configured tag name (defaults to `<div>`):

```ruby
ui.button.with(size: :large).tag "Click Me!", type: :button
# => <button type="button" class="inline-flex items-center justify-center disabled:cursor-none ring-current focus:outline-none focus:ring text-lg p-4">
# =>   Click Me!
# => </button>
```

You can also chain another tag name off the `tag` to override the default:

```ruby
ui.button.with(size: :large).tag.a "Click Me!", href: "/",
# => <a href="/" class="inline-flex items-center justify-center disabled:cursor-none ring-current focus:outline-none focus:ring text-lg p-4">
# =>   Click Me!
# => </a>
```

If variant names are unique across keys, you can pass them directly to `#with`:

```ruby
ui.button.with(:primary, :large).button_tag "Click Me!", type: :button
# => <button type="button"
# =>         class="ring-current focus:outline-none focus:ring
# =>                inline-flex items-center justify-center disabled:cursor-none bg-purple-900 text-white ring-purple-900 focus:ring-offset-2 text-lg p-4">
# =>   Click Me!
# => </button>
```

You can mix-and-match variant arguments:

```ruby
ui.button.with(:primary, size: :large).link_to "Click Me!", "/"
# => <a href="/"
# =>    class="ring-current focus:outline-none focus:ring
# =>           inline-flex items-center justify-center disabled:cursor-none bg-purple-900 text-white ring-purple-900 focus:ring-offset-2 text-lg p-4">
# =>   Click Me!
# => </a>
```

When invoking a single variant, you can forego calls to `#with` and invoke the name of the variant directly:

```ruby
ui.button.primary.button_tag "Click Me!"
# => <button class="ring-current focus:outline-none focus:ring
# =>                inline-flex items-center justify-center disabled:cursor-none bg-purple-900 text-white ring-purple-900 focus:ring-offset-2">
# =>   Click Me!
# => </button>
```

When rendering their default tag, invoke #tag:

```ruby
ui.button.primary.tag "Click Me!"
# => <button class="ring-current focus:outline-none focus:ring
# =>                inline-flex items-center justify-center disabled:cursor-none bg-purple-900 text-white ring-purple-900 focus:ring-offset-2">
# =>   Click Me!
# => </button>
```

Coerce `StyledHelpers::Helpers` instances with `Hash#to_h`, and can be double-splatted with `**`.

They're also valid `Object#with_options` arguments:

```ruby
form.with_options(ui.input.text).text_field :name
# => <input id="article_name" name="article[name]" type="text"
# =>       class="placeholder:text-current placeholder:text-opacity-95 before:text-opacity-95
# =>              ring-current focus:outline-none focus:ring
# =>              border-black/20 text-sm">
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "action_view-attributes", github: "seanpdoyle/action_view-attributes", tag: "v0.1.0"
gem "styled_helpers", github: "seanpdoyle/styled_helpers", tag: "v0.1.0"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install styled_helpers
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Acknowledgements

This project was originally forked from
[seanpdoyle/attributes_and_token_lists](https://github.com/seanpdoyle/attributes_and_token_lists).
It draws inspiration from the [@stitches/react](https://stitches.dev) package,
namely its support for [variants](https://stitches.dev/docs/variants). Its
development was encouraged by a comment from [Dom Christie](https://github.com/seanpdoyle/attributes_and_token_lists/issues/21#issuecomment-1284223461).
