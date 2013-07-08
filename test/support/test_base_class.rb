module RedStack

  class TestBase < MiniTest::Spec

    def vcr_cassette_name
      __name__.gsub(/test_\d+_/, '')
    end

    before do
      VCR.insert_cassette vcr_cassette_name
    end

    after do
      VCR.eject_cassette
    end

  end

end