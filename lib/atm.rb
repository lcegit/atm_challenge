require 'date'

class Atm
  attr_accessor :funds, :status, :message, :account, :balance, :active, :deactivated

  def initialize
    @funds = 1000
#    @status = true || false
  end

  def withdraw(pin_code, amount, account)
    case
    when insufficient_funds_in_account?(amount, account)
      { status: false, message: 'insufficient funds', date: Date.today, account_status: :deactivated }
    when insufficient_funds_in_atm?(amount)
      { status: false, message: 'insufficient funds in ATM', date: Date.today, account_status: :deactivated }
    when incorrect_pin?(pin_code, account.pin_code)
      { status: false, message: 'wrong pin', date: Date.today, account_status: :deactivated }
    when card_expired?(account.exp_date)
      { status: false, message: 'card expired', date: Date.today, account_status: :deactivated }
    when account_is_deactivated?(account)
      { status: false, message: 'the account is deactivated', date: Date.today, account_status: :deactivated }
    else
      perform_transaction(amount, account)
    end
  end

private

  def insufficient_funds_in_account?(amount, account)
    amount > account.balance
  end

  def insufficient_funds_in_atm?(amount)
    @funds < amount
  end

  def incorrect_pin?(pin_code, actual_pin)
    pin_code != actual_pin
  end

  def perform_transaction(amount, account)
    @funds -= amount
    account.balance = account.balance - amount
    { status: true, message: 'success', date: Date.today, amount: amount, bills: add_bills(amount) }
  end

  def add_bills(amount)
    denominations = [20, 10, 5]
    bills = []
    denominations.each do |bill|
      while amount - bill >= 0
        amount -= bill
        bills << bill
      end
    end
    bills
  end


  def card_expired?(exp_date)
    Date.strptime(exp_date, '%m/%y') < Date.today
  end

  def account_is_deactivated?(account)
    account.account_status == :deactivated
  end

end
