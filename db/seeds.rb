# frozen_string_literal: true

# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# sample user with lot of loaded money
User.create!(email: 'buyer@users.it', password: 'buyeruser', password_confirmation: 'buyeruser', wallet_money: 900_000)
# sample user with little loaded money
User.create!(email: 'poorbuyer@users.it', password: 'poorbuyeruser', password_confirmation: 'poorbuyeruser',
             wallet_money: 1000)
# sample seller user with the ability to edit t_shirts and to confirm/cancel orders
User.create!(email: 'seller@users.it', password: 'selleruser', password_confirmation: 'selleruser', seller: true)

# sample t_shirts
TShirt.create!(name: 'abbondante', brand: 'abbundantis', color: 'blu', price: 100, quantity: 999)
TShirt.create!(name: 'scarsa', color: 'giallo', price: 500, quantity: 10)
TShirt.create!(name: 'costosa', brand: 'lusso', color: 'rosso', price: 1_000_000, quantity: 1)
