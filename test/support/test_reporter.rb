# Do not require these gems when running in the CI
unless ENV['CI'] || ENV['TRAVIS']
  require "minitest/reporters"

  module MiniTest
  module Reporters

    # class RedStackReporter < SpecReporter
    # 
    #   private
    # 
    #   def pad_test(test)
    #     str = test.to_s.gsub(/(test_)/, '').gsub(/_/, ' ')
    #     pad("%-#{TEST_SIZE}s" % str, TEST_PADDING)[0..TEST_SIZE]
    #   end
    # 
    #   def print_info(e)
    #     print "       #{e.exception.class.to_s}:\n"
    #     e.message.each_line { |line| print_with_info_padding(line) }
    # 
    #     trace = filter_backtrace(e.backtrace)
    #     
    #     # TODO: Use the proper MiniTest way of customizing the filter
    #     trace.each { |line| print_with_info_padding(line) unless line =~ /\.rvm|gems|_run_anything/ }
    #   end
    # 
    # end

    class RedStackReporter < ProgressReporter; end

  end
  end

  MiniTest::Reporters.use! MiniTest::Reporters::RedStackReporter.new
end