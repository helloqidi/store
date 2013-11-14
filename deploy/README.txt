发布流程：
============================================
git fetch
git merge origin/master
bundle install  (如果发生错误,按照提示单独进行gem install xxx即可;可能需要先停掉服务 ./rainbows.sh stop)
padrino rake ar:migrate -e production
./rainbows.sh restart



生产环境部署须知：
============================================
1,如果需要重建索引
(1)删除
Tire.index('items'){delete}
(2)
Tire.index("items").import(Item.all)

2,



重启服务器后
============================================
1,启动nginx
sudo /opt/nginx/sbin/nginx

2,启动elasticsearch
sudo bin/elasticsearch

3,启动项目
./rainbows.sh start
