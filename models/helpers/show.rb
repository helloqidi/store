# encoding: utf-8
module HelpersShow
  def self.included(base) 
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods

    #拼接绝对地址
    def domain_path(string)
      return Settings[:domain] if string.blank?
      URI.join(Settings[:domain],string).to_s
    end

    ##
    # 全局views的目录
    #
    def commonviews
      {:views=>commonviews_dir,:layout=>false}
    end

    def commonviews_with_layout
      {:views=>commonviews_dir}
    end

    def commonviews_dir
      "#{PADRINO_ROOT}/app/views/common"
    end

    def css_active?(css)
      "active" if css.present?  
    end

    #去掉html
    def remove_html_tag(in_html)
      in_html.gsub(/<\/?[^>]*>/, "")
    end

    def format_time(time)
      time.strftime("%Y-%m-%d %H:%M:%S")
    end

    def format_time_with_hour(time)
      time.strftime("%Y-%m-%d %H:%M")
    end

    def format_time_with_day(time)
      time.strftime("%Y-%m-%d")
    end

    #拆分标签
    def tag_array_from_string(string)
      string.split(/[,，]*[,，]/).uniq
    end

  end
end
