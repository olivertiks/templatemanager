class Activity
  include Mongoid::Document
  belongs_to :machine, optional: true

  field :action, type: String
  field :initiated_by, type: String
  field :date, type: Date

end