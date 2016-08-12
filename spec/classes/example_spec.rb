require 'spec_helper'

describe 'rancher_infra' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "rancher_infra class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('rancher_infra::params') }
          it { is_expected.to contain_class('rancher_infra::install').that_comes_before('rancher_infra::config') }
          it { is_expected.to contain_class('rancher_infra::config') }
          it { is_expected.to contain_class('rancher_infra::service').that_subscribes_to('rancher_infra::config') }

          it { is_expected.to contain_service('rancher_infra') }
          it { is_expected.to contain_package('rancher_infra').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'rancher_infra class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('rancher_infra') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
