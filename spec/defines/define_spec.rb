require 'spec_helper'

describe 'hosts::define', :type => :define do
  ['Debian'].each do |osfamily|
    let(:facts) {{
      :osfamily          => osfamily,
      :ipaddress_primary => '10.0.2.15',
      :ipaddress6        => 'fe80::a00:27ff:feb7:c757'
    }}
    let(:pre_condition) { 'include hosts' }
    let(:title) { 'hosts' }

    context "on #{osfamily}" do
      context 'when source file' do
        let(:params) {{
          :config_file_path   => '/etc/hosts.2nd',
          :config_file_source => 'puppet:///modules/hosts/wheezy/etc/hosts',
        }}

        it do
          is_expected.to contain_file('define_hosts').with({
            'ensure'  => 'present',
            'source'  => 'puppet:///modules/hosts/wheezy/etc/hosts',
            'require' => nil,
          })
        end
      end

      context 'when content string' do
        let(:params) {{
          :config_file_path   => '/etc/hosts.3rd',
          :config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
        }}

        it do
          is_expected.to contain_file('define_hosts').with({
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'require' => nil,
          })
        end
      end

      context 'when content template' do
        let(:params) {{
          :config_file_path     => '/etc/hosts.4th',
          :config_file_template => 'hosts/wheezy/etc/hosts.erb',
        }}

        it do
          is_expected.to contain_file('define_hosts').with({
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'require' => nil,
          })
        end
      end

      context 'when content template (custom)' do
        let(:params) {{
          :config_file_path         => '/etc/hosts.5th',
          :config_file_template     => 'hosts/wheezy/etc/hosts.erb',
          :config_file_options_hash => {
            'key' => 'value',
          },
        }}

        it do
          is_expected.to contain_file('define_hosts').with({
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'require' => nil,
          })
        end
      end
    end
  end
end
