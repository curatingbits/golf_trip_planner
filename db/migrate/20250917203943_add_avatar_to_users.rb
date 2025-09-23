class AddAvatarToUsers < ActiveRecord::Migration[8.0]
  def change
    # Active Storage will handle the avatar attachment via has_one_attached
    # No migration changes needed - just need to add has_one_attached to User model
  end
end
