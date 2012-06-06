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

    def enqueue(options = {})
      enqueue_to(nil, options)
    end

    def enqueue_to(queue, options = {})
      EnqueueProxy.new(self, queue, options)
    end

    class EnqueueProxy

      def initialize(klass, queue, options = {})
        @klass = klass
        @queue = queue
        @options = options
      end

      def method_missing(method, *args, &block)
        if @klass.respond_to? method
          @options.merge!({'klass' => @klass.to_s, 'method' => method, 'args' => args})

          if @queue
            Resque.enqueue_to(@queue, @klass, @options)
          else
            Resque.enqueue(@klass, @options)
          end
        else
          super
        end
      end

    end

    VERSION = '0.3.0'
  end
end

class ActionMailer::Base
  extend Resque::MailQueue
end
