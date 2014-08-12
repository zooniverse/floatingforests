project = require "zooniverse-readymade/current-project"
{ User } = project.classifyPages[0]

userSplit = ->
  return false if User.current?.project?.splits?.user_goals_split isnt 'a'
  User.current?.project?.splits?.user_goals

module?.exports = userSplit
