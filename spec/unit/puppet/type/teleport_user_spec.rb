require 'puppet/type/teleport_user'

describe Puppet::Type.type(:teleport_user) do

	it 'should require a name' do
		expect {
			Puppet::Type.type(:teleport_user).new({})
		}.to raise_error(Puppet::Error, 'Title or name must be provided')
	end

  context 'when creating a user' do
    before :each do
    	@user = Puppet::Type.type(:teleport_user).new(:name => 'testing') 
    end

		it 'should accept a user name' do
      expect(@user[:name]).to eq('testing')
    end

    it 'should accept an array of allowed logins' do
      @user[:allowed_logins] = ['testing','root']
      expect(@user[:allowed_logins]).to eq(['testing','root'])
    end

  end
end
