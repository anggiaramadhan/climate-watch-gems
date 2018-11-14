class AddUserEmailToWorkerLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :worker_logs, :user_email, :string
  end
end
