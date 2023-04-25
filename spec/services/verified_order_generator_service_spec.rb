# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VerifiedOrderGeneratorService do
  let!(:user_one) do
    User.create!(email: 'buyer@users.it',
                 password: 'buyeruser',
                 password_confirmation: 'buyeruser',
                 wallet_money: 10_00)
  end
  let(:user_two) do
    User.create!(email: 'buyer2@users.it',
                 password: 'buyeruser2',
                 password_confirmation: 'buyeruser2',
                 wallet_money: 10_00)
  end
  let!(:example_shirt) do
    TShirt.create!(name: 'example',
                   price: 10_00,
                   quantity: 1)
  end

  describe 'submitting an order' do
    it 'should correctly create order and update user, user_cart and tshirts' do
      user_cart_t_shirt = UserCartTShirt.create!(user_id: user_one.id,
                                                 t_shirt_id: example_shirt.id,
                                                 quantity: 1)

      service = VerifiedOrderGeneratorService.new(current_user: user_one)
      result = service.run

      remaining_user_cart_t_shirts = UserCartTShirt.where(id: user_cart_t_shirt).count

      example_shirt.reload

      expect(user_one.wallet_money).to eq 0
      expect(example_shirt.quantity).to eq 0
      expect(remaining_user_cart_t_shirts).to eq 0
      expect(result[:success]).to eq true
      expect(result[:order]).to_not be_nil
      expect(result[:order].total_quantity).to be 1
      expect(result[:order].total_price).to be 1000
      expect(result[:order].completed?).to be false
    end

    it 'should fail due to missing money on user wallet_money' do
      # set available user money to 0
      user_one.update!(wallet_money: 0)

      user_cart_t_shirt = UserCartTShirt.create!(user_id: user_one.id,
                                                 t_shirt_id: example_shirt.id,
                                                 quantity: 1)

      service = VerifiedOrderGeneratorService.new(current_user: user_one)
      result = service.run

      remaining_user_cart_t_shirts = UserCartTShirt.where(id: user_cart_t_shirt).count

      example_shirt.reload

      expect(user_one.wallet_money).to eq 0
      expect(example_shirt.quantity).to eq 1
      expect(remaining_user_cart_t_shirts).to eq 1
      expect(result[:success]).to eq false
      expect(result[:message]).to eq 'you do not have enough money'
      expect(result[:order]).to be_nil
    end

    it 'should fail due to missing quantity ofthe requested shirt' do
      # set available shirt quantity to 0
      example_shirt.update!(quantity: 0)

      user_cart_t_shirt = UserCartTShirt.create!(user_id: user_one.id,
                                                 t_shirt_id: example_shirt.id,
                                                 quantity: 1)

      service = VerifiedOrderGeneratorService.new(current_user: user_one)
      result = service.run

      remaining_user_cart_t_shirts = UserCartTShirt.where(id: user_cart_t_shirt).count

      example_shirt.reload

      expect(user_one.wallet_money).to eq 1000
      expect(example_shirt.quantity).to eq 0
      expect(remaining_user_cart_t_shirts).to eq 1
      expect(result[:success]).to eq false
      expect(result[:message]).to eq 'the requested quantities are not available'
      expect(result[:order]).to be_nil
    end

    it 'must stop an user if two last item orders arrive almost simultaneously' do
      # both users add all the shirt quantity
      user_one_cart_t_shirt = UserCartTShirt.create!(user_id: user_one.id,
                                                     t_shirt_id: example_shirt.id,
                                                     quantity: 1)

      user_two_cart_t_shirt = UserCartTShirt.create!(user_id: user_two.id,
                                                     t_shirt_id: example_shirt.id,
                                                     quantity: 1)

      # user one is faster on buying
      service_one = VerifiedOrderGeneratorService.new(current_user: user_one)
      result_one = service_one.run

      # user two press 'buy' later
      service_two = VerifiedOrderGeneratorService.new(current_user: user_two)
      result_two = service_two.run

      remaining_user_one_cart_t_shirts = UserCartTShirt.where(id: user_one_cart_t_shirt).count
      remaining_user_two_cart_t_shirts = UserCartTShirt.where(id: user_two_cart_t_shirt).count

      example_shirt.reload

      expect(result_one[:success]).to eq true
      expect(result_two[:success]).to eq false
      expect(result_one[:message]).to be_nil
      expect(result_two[:message]).to eq 'the requested quantities are not available'
      expect(user_one.wallet_money).to eq 0
      expect(user_two.wallet_money).to eq 1000
      expect(example_shirt.quantity).to eq 0
      expect(remaining_user_one_cart_t_shirts).to eq 0
      expect(remaining_user_two_cart_t_shirts).to eq 1
    end
  end
end
