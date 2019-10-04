class CreateSiteSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :site_settings do |t|
      t.string :name, :not_null
      t.string :value

      t.timestamps
    end
  end
end