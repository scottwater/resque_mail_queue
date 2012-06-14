# Resque Mail Queue

This gem makes it very easy to send emails asynchronously with [Resque](http://github.com/defunkt/resque).

## Usage

Add the gem to your gemfile:

	gem 'resque_mail_queue'

Then anytime you want to push an email asynchronously add _enqueue_ before the mailer method.

	UserMailer.enqueue.welcome_email(1)

## Notes

1. As with most things Resque, your parameters should be simple objects (ids, strings, etc). Or put another way, do not pass your models directly.
1. You do not have to call deliver
1. By default, all messages will be placed on a queue called "mail". You can change this by adding a class method called queue on any mailer.

	class MyMailer < ActionMailer::Base

		def self.queue
			:high_priority
		end

	end


## Why use this instead of ResqueMailer

I initially started using [ResqueMailer](https://github.com/zapnap/resque_mailer) and it worked well. However, I preferred being more explicit (and simple) on when emails were sent asynchronously (by calling enqueue).

More clearly, if ResqueMailer works for you and you like it, stick with it.


## License

Provided under the Do Whatever You Want With This Code License.

