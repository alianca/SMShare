require 'spec_helper'

describe PaymentRequest do
  describe 'Functionality' do
    before(:each) do
      @request = Factory.create :payment_request
    end

    it 'should correcly store the value' do
      @request.value.should == 10
    end

    it 'should correctly store the referred value' do
      @request.referred_value.should == 15.50
    end

    it 'should retrieve total value' do
      @request.total.should == 25.50
    end
  end
  
  describe 'Paypal Integration' do
    before(:each) do
      @u1 = Factory.create :user, :email => 'aaa_1345743386_per@gmail.com', :nickname => 'aaa_'
      @u2 = Factory.create :user, :email => 'bbb_1345743485_per@gmail.com', :nickname => 'abc_'
    end

    describe 'Simple Payments' do
      it 'should have succeeded' do
        @r1 = Factory.create :payment_request, :user => @u1
        @r2 = Factory.create :payment_request, :user => @u2
        @r3 = Factory.create :payment_request, :user => @u2
        @r4 = Factory.create :payment_request, :user => @u2
        PaymentRequest.send_payments([@r2, @r3])
        [@u1, @u2, @r1, @r2, @r3, @r4].each(&:reload)

        @r1.status.should == :pending
        @r2.status.should == :completed
        @r3.status.should == :completed
        @r4.status.should == :pending
        PaymentRequest.pending.to_a.should include(@r1, @r4)
        PaymentRequest.completed.to_a.should include(@r2, @r3)
      end
    end

    describe 'Mass Payments' do
      before(:each) do
        @users = [@u1, @u2]
        @requests = 1000.times.map { |i| Factory.create :payment_request, :user => @users[i%2] }
        PaymentRequest.send_payments(@requests)
        (@users + @requests).each(&:reload)
      end

      it 'should succeed' do
        @requests.map(&:status).uniq.should == [:complete]
      end
    end
  end
end
