module RedStack
  def self.configure(options={})    
    config = find_config.merge(options)
    
    require 'net/http'
    require 'json'
    require 'faraday'
    require 'vcr'
    
    if config['openstack_stub_dir']
      VCR.configure do |c|
        c.cassette_library_dir = config['openstack_stub_dir']
        c.hook_into :faraday
      end
    end
    
    require 'redstack/version'
    require 'redstack/errors'
    require 'redstack/session'
    require 'redstack/base'
    require 'redstack/identity'
  end
  
  def self.load_config(config_dir, config_file)
    owd = Dir.pwd

    # Change pwd to location of the config so that any ERB tags
    # in the config file are evaluated relative to that file's location
    Dir.chdir config_dir
    
    config = YAML.load(ERB.new(File.read(config_dir + config_file)).result) || {}
    
    # Change back to original working directory
    Dir.chdir owd
        
    config
  end
  
  def self.find_config(dir=nil)
    dir ||= Dir.pwd
    filepath = '/redstack.yml'

    if File.exists?(dir + filepath)
      load_config(dir, filepath)
    elsif dir == '/'
      {}
    else
      find_config File.expand_path(dir + '/..')
    end
  end
end