module SessionsHelper

  # SessionsHelper - module facility for packaging functions together and including them in multiple places
  # signin functions themselves will end up crossing the traditional Model-View-Controller lines:
  # several signin functions will need to be available in both controllers and views
  # to make SessionsHelper functions accessible in controllers
  # we have included the module in the Application controller (app/controllers/application_controller.rb)
  
  # Use cookies utility supplied by Rails to maintain persistent sessions (20 year expiration)
  # whereby signin status that lasts even after browser close;
  # we prevent a malicious user signing in as user with a remember_token equal to the user's id
  # by generating a unique, secure remember token for each user based on the user's salt and id;
  # moreover, a permanent remember token would also represent a security hole —
  # by inspecting the browser cookies, a malicious user could find the token and then use it to sign in
  # so we add a timestamp to the token, and reset the token every time the user signs into the application

  # Could use traditional Rails session (via the special session function) instead of cookies
  # so that users are automatically signed out when they close their browsers

  def sign_in(user)
    # use cookies utility supplied by Rails which can be used as if it were a hash
    # each element in the cookie is itself a hash of two elements, a value and an optional expires date
    # using permanent causes Rails to set the expiration to 20.years.from_now,
    # and signed makes the cookie secure, so that the user's id is never exposed in the browser
    # setting rememeber_token using an array consisting of a unique identifier (ie. the user's id)
    # and a secure value used to create a digital signature
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    # create current_user, accessible in both controllers and views
    current_user = user
  end

  # sets an instance variable @current_user, effectively storing the user for later use
  def current_user=(user)
    @current_user = user
  end

  # return session user corresponding to the cookie created by the code
  # simply returning instance variable @current_user would result in
  # user's signin status being forgotten as soon as the user went to another page
  def current_user
    # uses ||= ('or equals') assignment operator
    # which sets the instance variable only if @current_user is undefined
    @current_user ||= user_from_remember_token
  end

  # return boolean denoting whether user is signed in
  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  # store the path of the request, put a message in flash[:notice] and then redirect to the signin page
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

    def user_from_remember_token
      # uses * operator which allows use of two-element array
      # as an argument to a method expecting two variables
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      # uses || operator to return an array of nil values if cookies.signed[:remember_me] itself is nil
      cookies.signed[:remember_token] || [nil, nil]
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

end
