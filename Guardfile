guard 'minitest' do
  watch(%r|^lib/redstack\.rb|)      { "test" }
  watch(%r|^lib/redstack/(.*)\.rb|) { |m| "test/lib/redstack/#{m[1]}_test.rb" }
  watch(%r|^test/lib/.*_test\.rb|)
  watch(%r|^test/test_helper\.rb|)  { "test" }
end
