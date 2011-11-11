require 'resque'
require 'action_mailer'

module Resque
  module MailQueue
       
    include Resque::Helpers 
    extend self

    def queue
      :mail
    end

    def perform(options = {})
      mailer = constantize(options['klass'])
      method = options['method']
      mailer.send(method, *options['args']).deliver
    end

    def enqueue()
      EnqueueProxy.new(self)
    end

    class EnqueueProxy

      def initialize(klass)
        @klass = klass
      end

      def method_missing(method, *args, &block)
        if @klass.respond_to? method
          self.class.send :define_method, method do |args|
            options = {'klass' => @klass.to_s, 'method' => method, 'args' => args}
            Resque.enqueue(@klass, options)
          end
          self.send(method, args)
        else
          super
        end
      end

    end

    VERSION = '0.2.0'
  end
end

class ActionMailer::Base
  extend Resque::MailQueue
end