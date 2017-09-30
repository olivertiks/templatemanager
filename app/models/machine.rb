# Model to manipulate with VMs via i-tee-virtualbox API
class Machine

  require "date"
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic #support for dynamic (API) fields

  has_many :activities
  
  field :identifier, type: String
  field :name, type: String
  field :purpose, type: String

  field :status, type: String
  field :vrdeport, type: String

  field :last_query, type: DateTime


  @apiserver = Setting.first.apiserver

  # Changes the state for specific VM
  # @param [String] state requested (new) state
  def set_state(state)
    # Sets state of a VM
    request = Http.put("http://localhost:1337/machine/#{self.identifier}", { "state" => state })
    logger.info "#{Time.now}: Setting state of VM #{self.identifier} to #{state}"

  end

  # Updates the data about specific machine
  def requery

    unless Setting.first.developermode?

    logger.info "#{self.identifier}: requering machine data"
    data_json = Http.get("http://localhost:1337/machine/#{self.identifier}", {})
    machines = JSON.parse(data_json.body, object_class: OpenStruct)

    if machines.machine.state == "running"

      self.status = "running"
      self.vrdeport = machines.machine["rdp-port"]
      self.last_query = Time.now

      self.save

    else
      self.status = machines.machine.state
      self.vrdeport = "-1"
      self.last_query = Time.now

    end
    self.save

  end

  end

  # Discovers all deployed VMs from API
  def self.discover

    unless Setting.first.developermode?

    data_json = Http.get(@apiserver + "/machine/?detailed", {})
    machines = JSON.parse(data_json.body, object_class: OpenStruct)

    machines.each do |machine|


    if Machine.where(identifier: machine.id).exists?
      puts "#{Time.now} #{machine.id} already in database. Updating data."
      vm = Machine.find_by(identifier: machine.id)
      vm.status = machine.state

      # Updating last ping time
      vm.last_query = Time.now
      if machine["rdp-port"].nil?
        vm.vrdeport = ""
      else
        vm.vrdeport = machine["rdp-port"]
      end
      vm.save!
      
    else
      puts "#{Time.now} #{machine.id} not in a database. Adding to database."
      
      vm = Machine.new
      vm.identifier = machine.id
      vm.name = machine.name
      vm.last_query = Time.now


      if machine.id.include? "template"
        vm.purpose = "template"
      else
        vm.purpose = "basic"
      end

      vm.status = machine.state

      if machine["rdp-port"].nil?
      else
        vm.vrdeport = machine["rdp-port"]
      end

      vm.save!
    end
  end
  end

  end
end
