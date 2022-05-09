class ChangeProgrammingLanguageColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :programming_lenguage, :programming_language
  end
end
