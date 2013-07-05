guard 'minitest' do
  watch(%r|^lib/redstack\.rb|)            { "test" }
  watch(%r|^test/test_helper\.rb|)        { "test" }
  watch(%r|^lib/redstack/(.*)\.rb|)       { |m| "test/redstack/#{m[1]}_test.rb" }
  watch(%r|^test/redstack/.*_test\.rb|)   # Run the matched file
end