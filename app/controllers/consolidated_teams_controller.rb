class ConsolidatedTeamsController < ActionController::Base
  def index
    @teams = DataStore.teams

    @orgchart_config = to_orgchart_config(@teams)
  end

  private

  def to_orgchart_config(teams)
    teams.select(&:is_consolidated_primary_team).map do |team|
      nodes = []
      tags = {}

      tags[team.node_safe_team_name] = {
        template: 'group',
      }

      nodes += team.members.reverse.map do |user|
        node = {
          id: user.id,
          name: user.real_name,
          tags: [
            team.node_safe_team_name,
          ],
        }

        if team.manager.id != user.id
          node[:pid] = team.manager.id
        end

        node
      end

      {
        html_node: team.node_safe_team_name,
        template: "belinda",
        enableSearch: false,
        mouseScrool: 1,
        nodeMouseClick: 5, #OrgChart.action.none
        tags: tags,
        nodeBinding: {
          field_0: "name",
        },
        nodes: nodes
      }
    end
  end
end
