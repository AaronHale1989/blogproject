require "sinatra"
require "sinatra/activerecord"
require "./models"

set :database, 'sqlite3:whatever.sqlite3'
set :sessions, true

def current_user
  if(session[:user_id])
    @current_user = User.find(session[:user_id])
  end
end

get "/" do
  @users = User.all
  erb:"users/index"
end

#signup actions

get "/signup" do
  erb :"users/new"
end

post "/signup" do
  User.create(username: params[:username],password: params[:password])
  redirect "/"
end

# Login functionality

get "/login" do

  erb :"users/login"
end

post "/login" do
  user = User.where(username:params[:username]).first
  if user.password == params[:password]
    session[:user_id] = user.id
    redirect "/"
  else
    redirect "/login"
  end
end

#Logout functionality

post "/logout" do
  session[:user_id] = nil
  redirect "/login"
end

#Blogs

get "/blogs" do
  @blogs = Blog.all
  erb :"blogs/index"
end

#create blogs

get "/blogs/new" do
  erb :"blogs/new"
end

post "/create_blog" do
  if !session[:user_id]
    redirect "/login"
  else
  user = User.find(session[:user_id])
  Blog.create(title: params[:title],content: params[:content],user_id: user.id)
  redirect "/blogs"
  end
end

get "/users/edit" do
  if !session[:user_id]
    redirect "/login"
  else
  @user = User.find(session[:user_id])
  erb :"users/edit"
  end
end

post "/edit_user" do
  @user = User.find(session[:user_id])
  @user.update(username: params[:username],password: params[:password])
  redirect "/"
end

post "/destroy_user" do
  @user = User.find(session[:user_id])
  @user.destroy
  redirect "/signup"
end

get "/blogs/recent" do
  @blogs = Blog.all
  erb :"blogs/recent"
end
