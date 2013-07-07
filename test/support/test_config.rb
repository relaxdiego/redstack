require 'active_support/hash_with_indifferent_access'

module RedStack
  TestConfig =
    HashWithIndifferentAccess.new(
      YAML.load(
        ERB.new(
          File.read(
            Pathname.new(__FILE__).join('..', 'test_config.yml')
          )
        ).result
      )
    )
end
