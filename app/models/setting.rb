# Stores dashboard's initial, mandatory settings
class Setting
  include Mongoid::Document

  # API settings
  field :apiserver, type: String
  field :apiport, type: String

  # RDP settings
  field :defrdpuser, type: String
  field :defrdpsecret, type: String

  # Developer mode
  field :developermode, type: Boolean

end
