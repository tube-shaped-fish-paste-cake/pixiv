module Pixiv
  class Ranking < Page
    module Mode 
      DAILY      = 'daily'
      WEEKLY     = 'weekly'
      MONTHLY    = 'monthly'
      ROOKIE     = 'rookie'
      ORIGINAL   = 'original'
      MALE       = 'male'
      FEMALE     = 'female'
      DAILY_R18  = 'daily_r18'
      WEEKLY_R18 = 'weekly_r18'
      R18G       = 'r18g'
      MALE_R18   = 'male_r18'
      FEMALE_R18 = 'female_r18'
    end

    attr_reader :mode
    attr_reader :date

    def initialize(doc_or_doc_creator, attrs = {})
      raise ArgumentError, "`attrs[:query]' must be present" unless attrs[:query]
      raise ArgumentError, "`attrs[:search_opts]' must be present" unless attrs[:search_opts]
      super
    end

    # Returns the ranking page URL for given +mode+ and +date+
    # @param [String] mode
    # @param [String] date
    # @return [String]
    def self.url(mode, date='')
      date == ''?
      "#{ROOT_URL}/ranking.php?mode=#{mode}"
      "#{ROOT_URL}/ranking.php?mode=#{mode}&date=#{date}"
    end

    def url()
      self.class.url(mode, date)
    end

  end

  module Ranking::WithClient
    include ::Pixiv::Page::WithClient
    def items()
      client.
    end
  end
end
