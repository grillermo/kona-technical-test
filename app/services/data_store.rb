class DataStore
  def initialize(json)
    @json = json
  end

  def self.users
    initialize_models

    @@users.values
  end

  def self.teams
    initialize_models

    @@teams.values
  end

  def self.raw_data
    db = Rails.root.join('data/db.json')

    @@raw_data ||= open(db).read
  end

  def self.parsed_data
    @@parsed_data ||= JSON.parse(raw_data || '')
  end

  def self.build_user(user_id, user_attrs)
    user                             = User.new(user_id)
    user.real_name                   = user_attrs['realName']
    user.managed_teams_ids           = user_attrs['manager']
    user.secondary_managed_teams_ids = user_attrs['s_manager']

    user
  end

  def self.build_team(team_id, team_attrs)
    team = Team.new(team_id)
    team.name                         = team_attrs['name']
    team.directs_ids                  = team_attrs['directs']
    team.is_consolidated_primary_team = team_attrs['settings']['consolidatedPrimaryTeam'] == team_id
    team.consolidated_teams_ids       = team_attrs['settings']['consolidatedTeams']
    team.secondary_managers_ids       = team_attrs['s_manager']

    team
  end

  def self.initialize_models
    return if @initialized

    @@users ||= {}
    @@teams ||= {}

    parsed_data.each do |user_id, user_attrs|
      user = build_user(user_id, user_attrs)

      @@users[user_id] = user

      next if user_attrs['teams'].blank?

      user_attrs['teams'].map do |team_number, team_attrs|
        team_id = user_id+'&'+team_number

        next if @@teams[team_id]

        user.add_team_id(team_id)

        team = build_team(team_id, team_attrs)

        @@teams[team_id] = team
      end
    end

    # Assign the managers to their teams
    @@users.each do |user_id, user|
      user.managed_teams_ids.each do |team_id|
        team = @@teams[team_id]
        team.manager_id = user_id
      end
    end

    @initialized = true
  end

  def self.find_user(user_id)
    @@users[user_id]
  end

  def self.find_team(team_id)
    @@teams[team_id]
  end
end
