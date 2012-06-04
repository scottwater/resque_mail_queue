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

    def enqueue
      EnqueueProxy.new(self)
    end

    def enqueue_to(queue)
      EnqueueProxy.new(self, queue)
    end

    class EnqueueProxy

      def initialize(klass, queue = nil)
        @klass = klass
        @queue = queue
      end

      def method_missing(method, *args, &block)
        if @klass.respond_to? method
          options = {'klass' => @klass.to_s, 'method' => method, 'args' => args}

          if @queue
            Resque.enqueue_to(@queue, @klass, options)
          else
            Resque.enqueue(@klass, options)
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
