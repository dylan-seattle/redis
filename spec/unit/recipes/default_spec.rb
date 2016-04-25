#
# Cookbook Name:: redis
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'redis::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'updates the package repository' do 
    	expect(chef_run).to run_execute('apt-get update')
    end 
    it 'install the necessary packages' do 
    	expect(chef_run).to install_package('build-essential')
    	expect(chef_run).to install_package('tcl8.5')
    end 
    it 'retrieves the source code' do 
    	expect(chef_run).to create_remote_file('/tmp/redis-2.8.9.tar.gz') 
    end 
    it 'unzips the source code' do
    	
    	resource = chef_run.remote_file('/tmp/redis-2.8.9.tar.gz')
    	expect(resource).to notify('execute[tar xzf /tmp/redis-2.8.9.tar.gz]').to(:run).immediately
    	end
    	
    it 'builds the application' do
    	
    	resource = chef_run.execute('tar xzf /tmp/redis-2.8.9.tar.gz')
    	expect(resource).to notify('execute[make && make install]').to(:run).immediately
    	end
    it 'install redis server'  do
    	
    	resource = chef_run.execute('make && make install')
    	expect(resource).to notify('execute[echo -n | ./install_server.sh]').to(:run).immediately
    	end
    it 'runs the service'do
    	
    	expect(chef_run).to start_service('redis_6379')
    end 
  end
end
