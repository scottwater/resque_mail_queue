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

      def method_missing(m, *args, &block)
        if @klass.respond_to? m
          options = {'klass' => @klass.to_s, 'method' => m, 'args' => args}
          Resque.enqueue(@klass, options)
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