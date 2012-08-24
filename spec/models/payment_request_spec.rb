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

  describe 'Search' do
    it 'should be able to filter requests by month' do
      @user = Factory.create :user
      @r1 = Factory.create :payment_request, :user => @user, :requested_at => Date.parse('01/06/2012')
      @r2 = Factory.create :payment_request, :user => @user, :requested_at => Date.parse('02/05/2012')
      @r3 = Factory.create :payment_request, :user => @user, :requested_at => Date.parse('02/06/2012')

      PaymentRequest.requests_for_month(1).to_a.should == [@r1, @r2]
      PaymentRequest.requests_for_month(2).to_a.should == [@r3]
    end

    it 'should consider years correctly' do
      @user = Factory.create :user
      @r1 = Factory.create :payment_request, :user => @user, :requested_at => Date.parse('01/05/2012')
      @r2 = Factory.create :payment_request, :user => @user, :requested_at => Date.parse('01/06/2012')

      PaymentRequest.requests_for_month(1).to_a.should == [@r2]
      PaymentRequest.requests_for_month(12).to_a.should_not == [@r1]
    end
  end

  describe 'Paypal Integration' do
    before(:each) do
      @u1 = Factory.create :user, :email => 'aaa_1345743386_per@gmail.com', :nickname => 'aaa_'
      @u2 = Factory.create :user, :email => 'bbb_1345743485_per@gmail.com', :nickname => 'abc_'

      @r1 = Factory.create :payment_request, :user => @u1, :requested_at => Date.parse('01/09/2012')
      @r2 = Factory.create :payment_request, :user => @u2, :requested_at => Date.parse('02/07/2012')
      @r3 = Factory.create :payment_request, :user => @u2, :requested_at => Date.parse('03/05/2012')
      @r4 = Factory.create :payment_request, :user => @u2, :requested_at => Date.parse('03/06/2012')

      @err = PaymentRequest.send_payments_for_month(2)

      [@u1, @u2, @r1, @r2, @r3, @r4].each(&:reload)
    end

    it 'should have succeeded' do
      @err.should == []
      @r1.status.should == :pending
      @r2.status.should == :complete
      @r3.status.should == :complete
      @r4.status.should == :pending
    end

    it 'should find the right requests' do
      PaymentRequest.pending.to_a.should == [@r1, @r4]
      PaymentRequest.completed.to_a.should == [@r2, @r3]
    end

    it 'should not pay many times' do
      PaymentRequest.requests_for_month(2).to_a.should == []
    end

    it 'should update user statistics' do
      @u1.statistics.payments_received.should == 0.0
      @u2.statistics.payments_received.should == 20.0
      @u1.statistics.referred_payments_received.should == 0.0
      @u2.statistics.referred_payments_received.should == 31.0
    end
  end

end
