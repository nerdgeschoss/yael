# Yael

Yael is **Y**et **A**nother **E**vent **L**ibrary based on top of ActiveJob. It helps you dispatching events asynchronously in your code base and react to them just like routing in Rails.

## Usage
Define your routes in `config/events.rb` like this:

```ruby
Yael::Bus.shared.routing do
  dispatch :order_confirmed, to: "order_mailer#confirm", delay: 5.minutes, queue: :low_priority
  dispatch :order_confirmed, to: "slack"
end
```

Now include the publisher in your class and dispatch events:

```ruby
class Order < ApplicationRecord
  include Yael::Publisher

  def confirm_order
    publish :order_confirmed, ip: some_id, some_other_data: data
  end
end

class Slack
  def self.on_order_confirmed(ip:)
    # send a notification to slack
  end
end
```

Calling `confirm_order` now will invoke `OrderMailer.confirm` and `Slack.notify_order`.

You can also request historical events of an object: `Yael::Event.for(Order.find(id))` will return all events recorded.

### Some Things to Keep in Mind
- the subscriber signature does not have to exactly match the published payload - yael will return all matching parameters
- everything is executed asynchronously inside of a job, even dispatching events
- you can not only publish from `ActiveRecord` models, but from any class by providing a stream name: `Yael::Bus.shared.dispatch(:event_name, stream: "my_stream", payload: {})`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yael'
```

And then execute:
```bash
bundle install
```

Generate a migration for your database:

```ruby
rails generate yael:install
rails db:migrate
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yael. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/yael/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Yael project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/yael/blob/master/CODE_OF_CONDUCT.md).
