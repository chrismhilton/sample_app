class SessionsController < ApplicationController

  # include SSL requirement plugin/gem
  # which adds a declarative way of specifying that certain actions should only be allowed to run under SSL
  #include SslRequirement if Rails.env.development?

  # secure the Sessions controller new and create actions
  #ssl_required :new, :create if Rails.env.development?

  def new
    @title = "Sign in"
  end

  def create
    # extract the submitted email address and password from the params hash
    # then pass them to the User.authenticate method
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      # user is not authenticated so set the title and re-render the signin form
      # since the session isn't an Active Record model can't use model error messages
      # so instead we've put a message in the flash shown via flash message display in the site layout
      # flash :- use before a redirect; flash.now :- use before a render
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      # redirect using friendly forwarding method
      redirect_back_or user
    end

  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
