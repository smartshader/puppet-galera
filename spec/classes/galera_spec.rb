require "spec_helper"

describe 'galera' do   
  let(:facts) {{:osfamily => 'Debian', :root_home => '/root'}}

  it { should contain_file('/etc/mysql/conf.d/wsrep.cnf') }

end