module Pixiv
  class RankingList < IllustList
    ILLUSTS_PER_PAGE = 200

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
      raise ArgumentError, "`attrs[:mode]' must be present" unless attrs[ :mode ]
      raise ArgumentError, "`attrs[:date]' must be present" unless attrs[ :date ]
      super
    end

    lazy_attr_reader(:page) { 1 }

    lazy_attr_reader(:total_count) {
      search!('section.ranking-item').length
    }

    lazy_attr_reader(:page_hashes) {
      search!('section.ranking-item').map { |node|
        hash = hash_from_list_item(node)
      }
    }

    def max_size
      ILLUSTS_PER_PAGE
    end

    def hash_from_list_item(node)
      user_node = node.at('.user-container') 
      illust_node = node.at('.work')
      illust_id = illust_node['href'][/illust_id=(\d+)/, 1].to_i
      {
        url: Illust.url(illust_id),
        small_image_url: illust_node.at('img')['src'],
        illust_id: illust_id,
        title: node['data-title'],
        member_id: user_node['data-user_id'],
        member_name: user_node['data-user_name'],
        rank: node['data-rank'].to_i
      }
    end


    # @yieldparam [Illust] illust
    def each
      illust_hashes.each do |attrs|
        url = attrs.delete(:url)
        yield Illust.lazy_new(attrs) { client.agent.get(url) }
      end
    end


    # Returns the ranking page URL for given +mode+ and +date+
    # @param [String] mode
    # @param [String] date
    # @return [String]
    def self.url(mode, date = nil)
      if date == nil then
        "#{ROOT_URL}/ranking.php?mode=#{mode}"
      else
        "#{ROOT_URL}/ranking.php?mode=#{mode}&date=#{date.strftime('%Y%m%d')}"
      end
    end

    def url()
      self.class.url(mode, date)
    end
  end
end
