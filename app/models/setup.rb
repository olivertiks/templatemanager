# Model to initialize setup process
class Setup
  include Mongoid::Document

  field :locked, type: Boolean

end