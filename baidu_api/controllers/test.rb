# encoding: utf-8
Store::BaiduApi.controllers :test do

  get :hello do
    @return_string = RestClient.post 'http://open.smzdm.com/api/26464203/baidu_gouwu_api_1.php', :k=>'9039437CB19C057F926AA38BB22803DF'

    p @return_string.encoding

    @return_string.force_encoding('UTF-8')
    @return_json = JSON.parse @return_string

    render "test/hello"
  end

end
