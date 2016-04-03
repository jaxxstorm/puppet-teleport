Puppet::Type.newtype(:teleport_user) do

  @doc = "Manage a teleport user. The includes management of user roles"

  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the user."
  end

  newproperty(:allowed_logins, :array_matching => :all) do
    desc "Which users the teleport user can login as."
    # We don't need to check insync yet
    # As teleport doesn't yet support it
    def insync?(is)
      Puppet.debug "insync labels are #{is}"
      # Always return true
      return true
    end
  end

end
