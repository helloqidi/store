# encoding: utf-8
namespace :scraping_smzdm do


  desc 'scraping home items'
  task :home_items => :environment do
    begin
      site = "http://www.smzdm.com/"
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
        show_page=agent.get(url)
  
        #副标题
        original_sub_title = show_page.search("h1.con_title span.red")[0].content
        sub_title = original_sub_title.strip()
        
        #标题
        title = show_page.search("h1.con_title")[0].content
        title.slice!(original_sub_title).strip()
        
        #描述(包含html)
        desc = show_page.search("p.p_excerpt")[0].to_s
        show_page.search("p.p_detail").each do |detail|
          desc += detail.to_s
        end
        
        #标签
        tags_array=[]
        show_page.search("div.single_tag a").each do |i|
          tags_array << i.content
        end
        tags=tags_array.join(",")
        
        #图片
        img_src_4 = show_page.search("div.conRightPic img")[0]["src"]
        img_src_1 = img_src_4.gsub(%r{_n4\.},"_n1.")
        
        #商城链接
        original_store_url = show_page.search("div.bugBlock a")[0]["href"]
        store_url = original_store_url.gsub(%r{\?id=\d*},'')
        
        #商城名称
        original_store_name = show_page.search("div.conRightBlock div.mall")[0].content
        store_name = original_store_name.gsub(%r{商城：},'')
        
        #用户名
        user_name=""

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
          recommend.photos.create(:file=>::MiniMagick::Image::open(img_src_1),:sort=>Photo::SORT[:recommend_main])
        end


      end#show_page_links
    rescue=>e
      logger.debug("Swaping error:#{e.message}")
    end
  end

end
