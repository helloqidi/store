# encoding: utf-8
namespace :init_data do

  desc 'init category data'
  task :category_data => :environment do
    category_hash = {"电脑数码"=>["手机","电脑整机","电脑配件","存储设备","外设产品","数码配件","摄影摄像","影音播放","网络设备"],"家用电器"=>["大家电","生活电器","厨房电器","个护健康"],"运动户外"=>["户外服饰","户外鞋袜","运动服饰","户外装备","运动鞋袜"],"服饰鞋包"=>["女装","男装","童装","家居内衣","女鞋","男鞋","配饰","女包","男包","箱包"],"个护彩妆"=>["面部护理","彩妆产品","美发护发","口腔护理","眼睛护理"],"母婴用品"=>["奶粉","营养辅食","尿裤湿巾","喂养用品","洗护用品","婴儿服饰","孕产妇用品","婴儿玩具"],"日用百货"=>["家居清洁","宠物用品","厨房用具","生活用品","成人用品"],"食品保健"=>["休闲食品","节日食品","生鲜食品","粮油调味","奶类制品","酒水饮料","保健品"],"图书音像"=>["电子书刊","图书杂志","软件游戏","音像制品"],"礼品钟表"=>["礼品","钟表","珠宝首饰"],"办公设备"=>["办公仪器","学生用品","办公用品"],"家居家装"=>["家装主材","家居饰品","五金电工","住宅家具","灯具灯饰","家纺布艺","园艺"],"汽车用品"=>["车载电器","车用美容","车用装饰","汽车配件","安全自驾","摩托相关","汽车整车"],"其他分类"=>["保险产品","金融产品","票务","旅游","充值产品"]}

    category_hash.each do |key,value|
      root = Category.create(:name=>key,:parent_id=>0,:level=>1)
      value.each do |i|
        Category.create(:name=>i,:parent_id=>root.id,:level=>2)
      end
    end

  end


  desc "add linklab record for old recommend"
  task :create_linklab_for_recommend => :environment do
    Recommend.all.each do |recommend|
      next if recommend.linklab.present?
      puts recommend.id
      linklab = recommend.build_linklab(:click_cnt=>0)
      linklab.save
    end
  end

end
