# frozen_string_literal: true

require 'spec_helper'
describe 'dotnet', type: :define do
  before do
    @hklm = 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall'

    @three_url = 'http://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe'
    @three_prog = 'dotNetFx35setup.exe'
    @three_reg = '{CE2CDD62-0124-36CA-84D3-9F4DCF5C5BD9}'
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}, server feature" do
      let(:title) { 'dotnet35' }
      let(:params) do
        {
          ensure: 'present',
          version: '3.5'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_exec('install-feature-3.5').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => 'Import-Module ServerManager; Add-WindowsFeature as-net-framework',
          'unless'    => 'Test-Path C:\\Windows\\Microsoft.NET\\Framework\\v3.5'
        )
      end
    end
  end

  ['unknown', 'Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}, server feature" do
      let(:title) { 'dotnet35' }
      let(:params) do
        {
          ensure: 'present',
          version: '3.5'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it { is_expected.not_to contain_exec('install-feature-3.5') }
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012'].each do |os|
    context "with ensure => absent, version => 3.5, os => #{os}, server feature" do
      let(:title) { 'dotnet35' }
      let(:params) do
        {
          ensure: 'absent',
          version: '3.5'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_exec('uninstall-feature-3.5').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => 'Import-Module ServerManager; Remove-WindowsFeature as-net-framework',
          'onlyif'    => 'Test-Path C:\\Windows\\Microsoft.NET\\Framework\\v3.5'
        )
      end
    end
  end

  ['Windows XP', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}, network package" do
      let(:title) { 'dotnet35' }
      let(:params) do
        {
          ensure: 'present',
          version: '3.5',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_exec('install-dotnet-3.5').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@three_prog} /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@three_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
        )
      end
    end
  end

  ['Windows XP', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}, download package" do
      let(:title) { 'dotnet35' }
      let(:params) do
        {
          ensure: 'present',
          version: '3.5'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_download_file('download-dotnet-3.5').with(
          'url'                   => @three_url,
          'destination_directory' => 'C:\\Windows\\Temp'
        )
      end

      it do
        is_expected.to contain_exec('install-dotnet-3.5').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@three_prog} /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@three_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
        )
      end
    end
  end

  ['unknown'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}" do
      let(:title) { 'dotnet35' }
      let(:params) do
        {
          ensure: 'present',
          version: '3.5',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it { is_expected.not_to contain_exec('install-dotnet-35') }
    end
  end

  ['Windows XP', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context "with ensure => absent, version => 3.5, os => #{os}" do
      let(:title) { 'dotnet35' }
      let(:params) do
        {
          ensure: 'absent',
          version: '3.5',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_exec('uninstall-dotnet-3.5').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@three_prog} /x /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@three_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
        )
      end
    end
  end

  ['Windows XP', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context "with ensure => absent, version => 3.5, os => #{os}, download package" do
      let(:title) { 'dotnet35' }
      let(:params) do
        {
          ensure: 'absent',
          version: '3.5'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_file("C:/Windows/Temp/#{@three_prog}").with(
          'ensure' => 'absent'
        )
      end

      it do
        is_expected.to contain_exec('uninstall-dotnet-3.5').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@three_prog} /x /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@three_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
        )
      end
    end
  end

  ['unknown'].each do |os|
    context "with ensure => absent, version => 3.5, os => #{os}" do
      let(:title) { 'dotnet35' }
      let(:params) do
        {
          ensure: 'absent',
          version: '3.5',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it { is_expected.not_to contain_exec('uninstall-dotnet-3.5') }
    end
  end
end
