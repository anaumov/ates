class TasksController < ApplicationController
  before_action :authenticate_account!

  def new
    task = Task.new
    render locals: { task: task }
  end

  def create
    Task.create!(task_params)
    rendirect_to tasks_path, notice: "Добавили новую задачу"
  rescue ActiveRecord::RecordInvalid => e
    render :new, locals: { task: e.record }
  end

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
