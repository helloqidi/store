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

  end
end
