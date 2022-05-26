class TasksController < ApplicationController
  before_action :authenticate_user!

  before_action :set_task, only: %i[ edit update destroy complete ]

  def index
    render locals: { tasks: tasks }
  end

  def reshuffle
    employees = Account.employee
    Task.in_progress.each { |task| task.assign!(employees.sample) }

    redirect_to tasks_url, notice: "Перемешали задачки"
  end

  def complete
    current_user.tasks.find(task_id).complete!
    redirect_to tasks_url, notice: "Задача закрыта"
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_url, notice: "Задача создана"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_url(@task), notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    redirect_to tasks_url, notice: "Task was successfully destroyed."
  end

  private

  def tasks
    if current_user.admin?
      Task.all
    else
      current_user.tasks
    end
  end

  def set_task
    @task = Task.find(task_id)
  end

  def task_id
    params[:id]
  end

  def task_params
    params.require(:task).permit(:title, :account_id)
  end
end
