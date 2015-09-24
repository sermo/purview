module RawConnectionHelper
  def postgresql_connection_config
    {
      :database => ENV['PURVIEW_POSTGRESQL_DBNAME'],
      :host => ENV['PURVIEW_POSTGRESQL_HOST'],
      :password => ENV['PURVIEW_POSTGRESQL_PASSWORD'],
      :port => ENV['PURVIEW_POSTGRESQL_PORT'],
      :username => ENV['PURVIEW_POSTGRESQL_USERNAME'],
    }
  end

  def mysql_connection_config
    {
      :database => ENV['PURVIEW_MYSQL_DBNAME'],
      :host => ENV['PURVIEW_MYSQL_HOST'],
      :password => ENV['PURVIEW_MYSQL_PASSWORD'],
      :port => ENV['PURVIEW_MYSQL_PORT'],
      :username => ENV['PURVIEW_MYSQL_USERNAME'],
    }
  end
end
