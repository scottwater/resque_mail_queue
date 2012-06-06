$:.push File.expand_path('../lib', __FILE__)
require 'resque_mail_queue'
require 'resque_spec'

class DumbMailer
  extend Resque::MailQueue
  def self.send_mail(user_id)
  end
end

class DumbMailer2  < DumbMailer
  def self.queue
    :not_default
  end
end


describe Resque::MailQueue do

  before(:each) do
    ResqueSpec.reset!
  end

  it 'should find a dummy mail in the default queue' do
    DumbMailer.enqueue.send_mail(3)
    DumbMailer.should have_queued('klass' => 'DumbMailer', 'method' => :send_mail, 'args' => [3]).in(:mail)
  end

  it 'should pass on any job arguments' do
    DumbMailer.enqueue(:test => 'test argument').send_mail(3)
    DumbMailer.should have_queued('klass' => 'DumbMailer', 'method'=> :send_mail, 'args' => [3], :test => 'test argument')
  end

  it 'should be able to override the queue from the mailer class (not default)' do
    DumbMailer2.enqueue.send_mail(3)
    DumbMailer2.should have_queued('klass' => 'DumbMailer2', 'method'=> :send_mail, 'args' => [3]).in(:not_default)
  end

  it 'should be able to override the queue when enqueueing (also not default)' do
    DumbMailer2.enqueue_to(:also_not_default).send_mail(3)
    DumbMailer2.should have_queued('klass' => 'DumbMailer2', 'method'=> :send_mail, 'args' => [3]).in(:also_not_default)
  end

  it 'should call deliver when pulling an item from the queue' do
    mail_message = double('mail_message')
    DumbMailer.stub(:send_mail).and_return(mail_message)
    mail_message.should_receive(:deliver)
    Resque::MailQueue.perform('klass' => 'DumbMailer', 'method' => :send_mail, 'args' => [3])
  end
end
