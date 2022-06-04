# frozen_string_literal: true

class TasksConsumer < ApplicationConsumer
  def consume
    payload = params.payload.deep_symbolize_keys
    case payload[:name]
    when "TaskAssigned" then process_task_assignment!(payload[:data])
    when "TaskCompleted" then process_task_completion!(payload[:data])
    else
      raise Error, "Undefined event received #{payload[:name]}"
    end
  end

  private

  def process_task_assignment!(task_params)
    process_task_event!(name: 'TaskAssignment', task_params: task_params)
  end

  def process_task_completion!(task_params)
     process_task_event!(name: 'TaskCompletion', task_params: task_params)
  end

  def process_task_event!(name:, task_params:)
    product = Product.find_or_create_by!(
      product_type: :task,
      name: name,
      product_public_id: task_params[:public_id]
    )
    account = Account.find_or_create_by!(public_id: task_params[:account_public_id])

    ApplicationBilling.new(product: product, account: account).process!
  end
end
