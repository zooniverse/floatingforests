User = require "zooniverse/models/user"

userSplit = ->
  return false if User.current?.project?.splits?.user_goals_split isnt 'a'
  User.current?.project?.splits?.user_goals

module?.exports = userSplit
