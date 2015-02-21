class AddProvidersToLinks < ActiveRecord::Migration
  def change
    add_column :links, :provider_url, :string
    add_column :links, :provider_name, :string
  end
end
