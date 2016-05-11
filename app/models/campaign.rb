class Campaign < ActiveRecord::Base
  validates :name, presence: true
  validates :user_id, presence: true
  validates :description, presence: true

  belongs_to :dungeon_master, class_name: "User"
  has_many :characters

  private

  def campaign_params
    params.require(:campaign).permit(:name, :user_id, :description)
  end
end
