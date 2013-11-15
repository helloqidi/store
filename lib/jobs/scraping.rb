# encoding: utf-8
module Jobs
  module Scraping

    #"什么值得买"网站数据
    class Smzdm

      def self.perform
        begin
          site = "http://www.smzdm.com/"
          site_key = "smzdm.com"
          agent = Mechanize.new

          #首页
          home_page=agent.get(site)

          #需要抓取的详情页超链接
          show_page_links = []
          home_page.search("div.perContentBox h2.con_title a").each do |link|
            records = Recommend.where(:swaping_site=>site,:swaping_url=>link["href"])
            next if records.present?
            show_page_links << link["href"]
          end

          #打开超链接
          show_page_links.each do |url|
            logger.debug("..........url:#{url}")
            show_page=agent.get(url)

            #副标题
            search_sub_title = show_page.search("h1.con_title span.red")[0]
            next if search_sub_title.blank?
            original_sub_title = search_sub_title.content
            sub_title = original_sub_title.strip()

            #标题
            search_title = show_page.search("h1.con_title")[0]
            next if search_title.blank?
            title = search_title.content
            title.slice!(original_sub_title).strip()

            #描述(包含html)
            description = show_page.search("p.p_excerpt")[0].to_s
            show_page.search("p.p_detail").each do |detail|
              description += detail.to_s
            end

            #标签
            tags_array=[]
            show_page.search("div.single_tag a").each do |i|
              next if i.blank?
              tags_array << i.content
            end
            tags=tags_array.join(",")

            #推荐人
            search_user_name = show_page.search("div.conPosition div.lfloat")[0]
            if search_user_name.present?
              user_name = search_user_name.content.gsub(%r{推荐人：},'')
            else
              user_name = ""
            end
            user_name = user_name.strip()

            #图片
            #注：发现原网址的图片有的不规则，比如：
            #http://pn.zdmimg.com/201311/12/2128822e.jpg_n4.jpg
            #造成MiniMagick::Image读取时报错,此时需要手动处理
            img_4 = show_page.search("div.conRightPic img")[0]
            if img_4.present?
              img_src_4 = img_4["src"]
              img_src_1 = img_src_4.gsub(%r{_n4\.},"_n1.")
            else
              img_src_1 = ""
            end

            #商城链接
            original_store_link = show_page.search("div.bugBlock a")[0]
            if original_store_link.present?
              original_store_url = original_store_link["href"]
              store_url = original_store_url.gsub(%r{\?id=\d*},'')
            else
              store_url = ""
            end
            #如果仍是自身的链接,则获取跳转后的真实链接
            if store_url.include?(site_key)
              true_url = get_javascript_redirect_url(store_url)
              store_url = true_url if true_url.present? && true_url.include?("http")
            end

            #商城名称
            search_store_name = show_page.search("div.conRightBlock div.mall")[0]
            if search_store_name.present?
              original_store_name = search_store_name.content
            else
              original_store_name = ""
            end
            store_name = original_store_name.gsub(%r{商城：},'')

            #创建记录
            recommend = Recommend.new(:title=>title,
                                      :sub_title=>sub_title,
                                      :description=>description,
                                      :tags=>tags,
                                      :store_url=>store_url,
                                      :store_name=>store_name,
                                      :swaping_site=>site,
                                      :swaping_url=>url,
                                      :user_name=>user_name,
                                      :category_id=>Settings[:category_other_id],
                                      :user_id=>Settings[:default_user_id])
            #存储图片
            if recommend.save
              begin
                if img_src_1.present?
                  img = ::MiniMagick::Image::open(img_src_1)
                  recommend.photos.create(:file=>img,:sort=>Photo::SORT[:recommend_main])
                end
              rescue=>e
                logger.warn("----------Image url bug:#{img_src_1}")
              ensure
                next
              end
            end

          end#show_page_links
        rescue=>e
          logger.warn("Swaping error:#{e.message}")
        end
      end#perform

      #获得javascript跳转后的链接
      def self.get_javascript_redirect_url(url)
        text = %x[curl -L -i #{url}]
        return "" if text.blank?
        step_1 = text.scan(%r{http%.*html})[0]
        return "" if step_1.blank?
        #转换编码
        CGI.unescape(step_1)
      end#get_javascript_redirect_url


    end#Smzdm

  end#Scraping
end#Jobs
