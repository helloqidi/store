发布流程：
============================================
git fetch
git merge origin/master
bundle install
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
