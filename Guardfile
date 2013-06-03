guard 'minitest' do
  watch(%r|^lib/redstack\.rb|)      { "test" }
  watch(%r|^lib/redstack/(.*)\.rb|)       { |m| "test/lib/redstack/#{m[1]}_test.rb" }
  watch(%r|^lib/redstack/base/model\.rb|) { find_model_tests(Dir.pwd + '/test/lib/redstack') }
  watch(%r|^test/lib/.*_test\.rb|)
  watch(%r|^test/test_helper\.rb|)  { "test" }
  watch(%r|^test/redstack\.yml|)    { "test" }
end


def find_model_tests(path)
  tests  = []
  dir    = Dir.new(path)
  ignore_list = ['.', '..', '.DS_Store']
  
  dir.reject{ |e| ignore_list.include? e }.each do |entry|
    entry_path = path + "/#{ entry }"

    if entry == 'models'
      tests += map_model_tests(entry_path)
    elsif Dir.exists?(entry_path)
      tests += find_model_tests(entry_path)
    end
  end

  tests.map { |e| e.gsub Dir.pwd + '/', '' }
end

def map_model_tests(dir_path)
  Dir.entries(dir_path)
    .select { |entry| File.file?("#{ dir_path }/#{ entry }") }
    .map    { |entry| "#{ dir_path }/#{ entry }" }
end