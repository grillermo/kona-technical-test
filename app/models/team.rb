class Team
  attr_accessor(
    :name,
    :id,
    :directs_ids,
    :is_consolidated_primary_team,
    :consolidated_teams_ids,
    :secondary_managers_ids, 
    :manager_id,
  )

  def initialize(id)
    @id = id
  end

  def secondary_managers
    secondary_managers_ids.map do |user_id|
      DataStore.find_user(user_id)
    end
  end

  def members
    directs_ids.map do |user_id|
      DataStore.find_user(user_id)
    end.compact
  end

  def manager
    DataStore.find_user(manager_id)
  end

  def consolidated_teams
    consolidated_teams_ids.map do |team_id|
      DataStore.find_team(team_id)
    end.compact
  end

  def to_s
    "Team #{name}"
  end

  def node_safe_team_name 
    name.gsub("'",'').gsub(' ','').gsub('/', '')
  end
end
