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
          logger.warn("Swaping Smzdm error:#{e.message}")
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


    #"惠惠网"
    class Huihui
      def self.perform
        begin
          site = "http://www.huihui.cn/"
          agent = Mechanize.new

          #首页
          home_page =  agent.get(site)
      

          #需要抓取的详情页超链接、图片地址
          #此网站只发现小图(260宽度),没有大图
          #该网站的图片地址是  http://oimagec6.ydstatic.com/image?id=-6685264236326101188&product=gouwu ,用agent.get(url)后可以获得Mechanize::Image对象,agent.get(url).content可以获得StringIO对象，此对象可以直接使用MiniMagick::Image.read读取
          show_page_links_img_srcs = []
          home_page.search("ul.hui-list li div.hlist-list-pic").each do |pic_div|
            link = pic_div.search("a")[0]
            next if link.blank?
            url = link["href"]
            next if url.blank?
            #转换相对地址为绝对地址
            unless url.include?("http")
              url = File.join(site,url)
            end
            records = Recommend.where(:swaping_site=>site,:swaping_url=>url)
            next if records.present?

            img = pic_div.search("a img")[0]
            img_src = img["data-src"] #发现img["src"]获取不到正确的图片地址
            
            hash={:url=>url,:img_src=>img_src}
            show_page_links_img_srcs << hash
          end



          #打开超链接
          show_page_links_img_srcs.each do |hash|
            url = hash[:url]

            logger.debug("..........url:#{url}")
            show_page=agent.get(url)

            #副标题
            search_sub_title = show_page.search("div.hui-list h4")[0]
            next if search_sub_title.blank?
            sub_title = search_sub_title.content.strip()

            #标题
            search_title = show_page.search("div.hui-list h1 a")[0]
            next if search_title.blank?
            title = search_title.content.strip()

            #描述(包含html)
            description = ""
            show_page.search("div.hui-content div.editer-main-content div.editor-mod").each_with_index do |detail,index|
              next if index>=2  #从第3个开始不抓取,因为发现是广告
              description += detail.to_s
            end

            #标签为空
            tags=nil

            #推荐人
            search_user_name = show_page.search("div.list-info span.hico-doc a")[0]
            if search_user_name.present?
              user_name = search_user_name.content
            else
              user_name = ""
            end
            user_name = user_name.strip()

            
            #商城链接
            original_store_link = show_page.search("div.hui-list h1 a")[0]
            if original_store_link.present?
              original_store_url = original_store_link["href"]
              #转换相对地址为绝对地址
              unless original_store_url.include?("http")
                original_store_url = File.join(site,original_store_url)
              end
              store_url = original_store_url.gsub(%r{\?id=\d*},'')
            else
              store_url = ""
            end
            #如果仍是自身的链接,则获取跳转后的真实链接
            if store_url.include?(site_key)
              true_url = get_redirect_url(store_url)
              store_url = true_url if true_url.present? && true_url.include?("http")
            end

            #商城名称
            store_name = ""

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
                if hash[:img_src].present?
                  string_io_url = agent.get(hash[:img_src])
                  if string_io_url.present?
                    #步骤能走通,但是没有保存图片数据,不知道为什么
                    img = ::MiniMagick::Image::read(string_io_url.content)
                    recommend.photos.create(:file=>img,:sort=>Photo::SORT[:recommend_main])
                  end
                end
              rescue=>e
                logger.warn("----------Image url bug:#{img_src_1}")
              ensure
                next
              end
            end

          end#show_page_links_img_srcs

        rescue=>e
          logger.warn("Swaping Huihui error:#{e.message}")
        end
      end

      def self.site_key
        "huihui.cn"
      end

      #获得redirect跳转后的链接
      def self.get_redirect_url(url)
        u = URI.parse(url)
        h = Net::HTTP.new u.host, u.port
        head = h.start do |ua|
          ua.head u.path
        end
        return "" if head['location'].blank?
        true_url = head['location']
        true_url = true_url.scan(%r{http%.*html})[0] if true_url.include?(site_key)
        return "" if true_url.blank?
        #转换编码
        CGI.unescape(true_url)
      end#get_redirect_url

    end#Huihui




    #"其他。。。"
    class Other
      def self.perform
        begin
          site = "http://..."
          

        rescue=>e
          logger.warn("Swaping ... error:#{e.message}")
        end
      end
    end#Other

  end#Scraping
end#Jobs
