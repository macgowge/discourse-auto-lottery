AutoLottery::Engine.routes.draw do
  post "/entries" => "entries#create"
  post "/admin/draw/:id" => "admin#draw", as: :admin_draw
  get "/admin/lotteries" => "admin#index"
  delete "/admin/delete/:id" => "admin#destroy"
end
