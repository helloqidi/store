# encoding: utf-8
Store::IosApi.helpers do
  #page,per的判空与赋值
  #使用:
  #  page,per=page_per(params[:page],params[:per])
  def page_per(page,per)
    page=page.to_i
    per=per.to_i
    page=1 if page==0
    per=2 if per==0   

    [page,per]
  end
end
