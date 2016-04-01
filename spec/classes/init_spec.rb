require 'spec_helper'

describe 'teleport' do

  RSpec.configure do |c|
    c.default_facts = {
      :architecture           => 'x86_64',
      :operatingsystem        => 'CentOS',
      :osfamily               => 'RedHat',
      :operatingsystemrelease => '7.1.1503',
      :kernel                 => 'Linux',
      :fqdn                   => 'test',
      :ipaddress              => '192.168.5.10',
    }
  end
 
  #### Installation ####

  context "When installing via URL by default" do
    it { should contain_archive('/tmp/teleport.tar.gz').with(:source => 'https://github.com/gravitational/teleport/releases/download/v0.1.0-alpha.7/teleport-v0.1.0-alpha.7-linux-amd64-bin.tar.gz') }
    it { should contain_file('/usr/local/bin/tctl').with(:ensure => 'link', :target => '/opt/teleport/build/tctl') }
    it { should contain_file('/usr/local/share/teleport').with(:ensure => 'link', :target => '/opt/teleport/src/github.com/gravitational/teleport/web/dist') }
  end

  context "When installing a special version" do
    let (:params) {{
      :version => 'v.0.2.0-beta.8'
    }}
    it { should contain_archive('/tmp/teleport.tar.gz').with(:source => 'https://github.com/gravitational/teleport/releases/download/v.0.2.0-beta.8/teleport-v.0.2.0-beta.8-linux-amd64-bin.tar.gz') }
  end

  context "When specifying a different archive path" do
    let (:params) {{
      :archive_path => "/opt/teleport.tar.gz"
    }}
    it { should contain_archive('/opt/teleport.tar.gz').with(:source => 'https://github.com/gravitational/teleport/releases/download/v0.1.0-alpha.7/teleport-v0.1.0-alpha.7-linux-amd64-bin.tar.gz') }
  end

  context "When specifying a different bin_dir" do
    let (:params) {{
      :bin_dir => "/usr/sbin"
    }}
    it { should contain_file('/usr/sbin/tctl').with(:ensure => 'link', :target => '/opt/teleport/build/tctl') }
  end

  context "When specifying a different extract_path" do
    let (:params) {{
      :extract_path => "/var/tmp"
    }}
    it { should contain_file('/var/tmp').with(:ensure => 'directory') }
    it { should contain_file('/usr/local/bin/tctl').with(:ensure => 'link', :target => '/var/tmp/teleport/build/tctl') }
    it { should contain_file('/usr/local/share/teleport').with(:ensure => 'link', :target => '/var/tmp/teleport/src/github.com/gravitational/teleport/web/dist') }
  end

  #### Config ####

  context "Setting up config file by default" do
    it { should contain_file('/etc/teleport.yaml').with(
      :ensure => 'present', 
      :owner => 'root', 
      :group => 'root', 
      :mode => '0555'
    )}
    it { should contain_file('/etc/teleport.yaml').with_content(/nodename: test/) }
  end

  context "when configuring auth service" do
    let (:params) {{
      :auth_enable => true,
      :auth_listen_addr => '0.0.0.0',
      :auth_listen_port => '8888',

    }}
    it { should contain_file('/etc/teleport.yaml').with_content(/auth_service:\n  enabled: true\n  listen_addr: 0.0.0.0:8888\n/) }
  end

  context "when configuring ssh service" do
		let (:params) {{
      :ssh_enable => false,
      :ssh_listen_addr => '0.0.0.0',
      :ssh_listen_port => '8888',

    }}
    it { should contain_file('/etc/teleport.yaml').with_content(/ssh_service:\n  enabled: false\n  listen_addr: 0.0.0.0:8888\n/) }  
  end

  context "when enabling SSL for proxy" do
    let (:params) {{
      :proxy_ssl => true,
      :proxy_ssl_key => '/var/ssl/teleport.key',
      :proxy_ssl_cert => '/var/ssl/teleport.crt',
    }}

    it { should contain_file('/etc/teleport.yaml').with_content(/https_key_file: \/var\/ssl\/teleport.key\n  https_cert_file: \/var\/ssl\/teleport.crt\n/) }
  end

  context "when configuring proxy service" do
    let (:params) {{
      :proxy_enable => true,
      :proxy_listen_addr => '0.0.0.0',
      :proxy_listen_port => '8888',

    }}
    it { should contain_file('/etc/teleport.yaml').with_content(/proxy_service:\n  enabled: true\n  listen_addr: 0.0.0.0:8888\n/) }
  end

  context "when configuring labels" do
    let (:params) {{
      :labels => { 'role' => 'test_role', 'data' => 'test_data' }
    }}
    it { should contain_file('/etc/teleport.yaml').with_content(/labels:\n    data: test_data\n    role: test_role/) }
  end

  context "when listing auth servers" do
    let (:params) {{
      :auth_servers => [ '127.0.0.1:3030', '0.0.0.0:3030' ]
    }}
    it { should contain_file('/etc/teleport.yaml').with_content(/auth_servers:\n    - 127.0.0.1:3030\n    - 0.0.0.0:3030\n/) }
  end

  ##### Service setup ####
  context "on unsupported operating system" do
    let (:facts) {{
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '8'
    }}
    it { expect { should compile }.to raise_error(/OS is currently/) }
  end

  context "on RHEL 7 system" do
    let (:facts) {{
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '7.1'
    }}
  	it { should contain_class('teleport').with_init_style('systemd') }
    it { should contain_file('/lib/systemd/system/teleport.service').with_content(/teleport start --config/) }
  end

  context "on RHEL 6 system" do
    let (:facts) {{
      :operatingsystem => "CentOS",
      :operatingsystemrelease => '6.7'
    }}
    it { should contain_class('teleport').with_init_style('init') }
    it { should contain_file('/etc/init.d/teleport').with_content(/start --config/) }
  end

  ### Service management ###

  context "by default service should be started" do
    it { should contain_service('teleport').with(:ensure => 'running', :enable => true) }
  end

  context "if not managing service" do
  	let(:params) {{ :manage_service => false }}
    it { should_not contain_service('teleport') } 
  end

  context "config file notifies service" do
    it { should contain_file('/etc/teleport.yaml').that_notifies('Service[teleport]') }
  end



end
