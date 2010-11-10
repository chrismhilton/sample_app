module UsersHelper

  # A helper, which is a function/method designed for use in views

  # Return gravatar image tag
  # based on user email and some default options using the gravatar_image_tag helper
  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
end
