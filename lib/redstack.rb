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
    require 'redstack/session'
    require 'redstack/identity'
  end
  
  def self.load_config(path)
    YAML.load(ERB.new(File.read(path)).result) || {}
  end
  
  def self.find_config(dir=nil)
    dir ||= Dir.pwd
    filepath = '/redstack.yml'

    if File.exists?(dir + filepath)
      load_config(dir + filepath)
    elsif dir == '/'
      {}
    else
      find_config File.expand_path(dir + '/..')
    end
  end
end