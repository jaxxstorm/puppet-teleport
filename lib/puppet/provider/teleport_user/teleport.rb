Puppet::Type.type(:teleport_user).provide(:ruby) do

  desc 'Manage teleport users.'

  # FIXME: Use the bindir param here?
  commands :tctl => 'tctl'

  def get_teleport_users
    begin
      output = tctl(['users', 'ls'])
    rescue Puppet::ExecutionFailure => e
      Puppet.debug("#get_teleport_users had an error -> #{e.inspect}")
      return []
    end
    output = output.split("\n")
    output.slice!(0, 2) # Strips out the headers from the array
    users = []
    output.each do |user|
      users.push user.split.shift
    end
    return users
  end

  #def return_allowed_logins
  #  resource[:allowed_logins].join(',') unless resource[:allowed_logins].nil?
  #end

  def allowed_logins
    resource[:allowed_logins].join(',') unless resource[:allowed_logins].nil?
  end

  # Returns true if user exists
  def exists?
    get_teleport_users.include?(resource[:name])
  end

  def create
    result = tctl(['users', 'add', resource[:name], allowed_logins])
    Puppet.info "Signup info: #{result}"
  end

  def destroy
    tctl(['users', 'del', resource[:name]])
  end



end
