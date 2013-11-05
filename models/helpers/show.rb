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

  end
end
