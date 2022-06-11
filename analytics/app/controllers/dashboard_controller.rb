class DashboardController < ApplicationController
  before_action :authenticate_user!, :authorize_admin!


  def index
    render locals: {
      current_balance: calculate_current_balance,
      popugs_with_negative_balance: collect_popugs_with_debt,
      most_expensive_tasks: {
        day: find_most_expencive_task(today_transactions),
        week: find_most_expencive_task(Transaction.week),
        month: find_most_expencive_task(Transaction.month),
      }
    }
  end

  private

  def calculate_current_balance
    calculate_balance(today_transactions)
  end

  def collect_popugs_with_debt
    popugs_with_balances = today_transactions.group_by(&:account).map do |account, transactions|
      transactions_scope = Transaction.where(id: transactions.map(&:id))
      [account, calculate_balance(transactions_scope)]
    end
    popugs_with_balances.select {|_, balance| balance.negative? }
  end

  def today_transactions
    @today_transactions ||= Transaction.today
  end

  def calculate_balance(transactions)
    income_amount_cents = transactions.debit.sum(:amount_cents).to_i
    outcome_amount_cents = transactions.credit.sum(:amount_cents).to_i
    Money.new(income_amount_cents - outcome_amount_cents, 'RUB')
  end

  def find_most_expencive_task(transactions)
    amount_cents = transactions.completed_tasks.maximum(:amount_cents).to_i
    Money.new(amount_cents, 'RUB')
  end
end
