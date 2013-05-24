guard 'minitest' do
  watch(%r|^lib/redstack\.rb|)         { "test" }
  watch(%r|^lib/(.*)/(.*)\.rb|)        { |m| "test/lib/#{m[1]}/#{m[2]}_test.rb" }
  watch(%r|^test/lib/.*/.*_test\.rb|)
  watch(%r|^test/test_helper\.rb|)     { "test" }
end
