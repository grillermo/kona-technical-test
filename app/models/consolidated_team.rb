class ConsolidatedTeam
  DATA_SOURCE = 'https://s3.us-west-2.amazonaws.com/secure.notion-static.com/19d513b2-dc95-4064-98ba-272b0353c2ef/teams.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20211209%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20211209T002614Z&X-Amz-Expires=86400&X-Amz-Signature=e8e9f036531c31d0a82f9cf6f2003f6b86dde4bf9f77b651e6d45f9f413e6a43&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22teams.json%22&x-id=GetObject'

  def users
    @users = []
  end

  def directs
    @directs = []
  end

  def managers

  end

  def secondary_managers

  end

  def slack_channel

  end

  def self.all
    JsonLoader.new(data_source)
  end

  def self.data
    @@data ||= open(data)
  end

  def self.parsed_data
    @@parsed_data ||= JSON.parse(data || '')
  end
end
