module ApplicationHelper
#Helper method to pass a user's name to a haml page. Usage Ex: "= user" (no quotes)
def user
  current_user.name
end
end
