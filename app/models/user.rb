class User
  attr_accessor(
    :id,
    :real_name,
    :managed_teams_ids,
    :teams_ids,
    :secondary_managed_teams_ids,
  )

  def initialize(id)
    @id = id
  end

  def managed_teams
    managed_teams_ids.map do |team_id|
      DataStore.find_team(team_id)
    end
  end

  def secondary_managed_teams
    secondary_managed_teams_ids.map do |team_id|
      DataStore.find_team(team_id)
    end
  end

  def directs
    managed_teams.each do |team|
      team.members 
    end
  end

  def teams
    return [] if teams_ids.blank?

    teams_ids.map do |team_id|
      DataStore.find_team(team_id)
    end
  end

  def to_s
    "User #{real_name}"
  end

  def add_team_id(id)
    if @team_ids.blank?
      @team_ids = [id]
    else
      @team_ids << id
    end
  end
end
