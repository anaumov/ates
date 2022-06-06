class DashboardController < ApplicationController

  def index
    render locals: {
      current_balance: rand(0..1000),
      popugs_with_negative_balance: [],
      most_expensive_tasks: {
        day: rand(0..100),
        week: rand(0..100),
        month: rand(0..100),
      }
    }
  end
end
