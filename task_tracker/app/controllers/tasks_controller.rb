class TasksController < ApplicationController
  before_action :authenticate_account!

  def index
    render locals: { tasks: tasks }
  end

  private

  def tasks
    if current_account.admin?
      Task.in_progress
    else
      current_account.tasks.in_progress
    end
  end
end
