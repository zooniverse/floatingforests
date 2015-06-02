class SessionGenerator
  def initialize (splitSize)
    @splitSize = splitSize
    @users = {}
    @user_sessions = {}
  end

  def stats
    ave_session_info
  end

  def session_classification_dist

  end

  def session_duration_dist

  end

  def session_no_dist

  end


  def ave_session_info
    total_classification_count = 0
    total_duration             = 0
    total                      = 0

    avg_no_sessions = @user_sessions.to_a.inject(0) {|total,sessions| total += sessions[1].count; total}/@user_sessions.to_a.count

    @user_sessions.each_pair do |user_id, sessions|
      sessions.each do |session|
        total+=1.0
        total_classification_count += session[:classification_count]
        total_duration             += session[:duration]
      end
    end

    {classification: total_classification_count/total, duration: total_duration/total, no: avg_no_sessions}

  end

  def add(user, classification)
    @users[user] ||= []
    if @users[user].count ==0
      last_classification = classification["created_at"]
    else
      last_classification = @users[user].last[:time_stamp]
    end
    gap = (classification["created_at"] - last_classification)
    @users[user].push({time_stamp: classification["created_at"], gap: gap, annotation_count: (classification["annotations"] || []).count, annotations: classification["annotations"]})
  end

  def calc_session_stats(session, index)
    duration = session[-1][:time_stamp] - session[0][:time_stamp]
    mean_gap = session.inject(0){|total,classification| total+= classification[:gap]; total} / session.length
    {classifications: session, classification_count: session.count, duration: duration, mean_gap: mean_gap, session_no:index }
  end

  def calc_splits
    @users.each_pair do |user_id, classifications|
      sessions = []
      current_session = []
      classifications.each do |classification|

        if classification[:gap] > @splitSize
          sessions.push calc_session_stats(current_session, sessions.count)
          current_session = []
        end
          current_session.push classification
      end
      sessions.push calc_session_stats(current_session,sessions.count)
      @user_sessions[user_id] = sessions
    end
    @user_sessions
  end

end
