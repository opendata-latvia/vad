ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::NATIVE_DATABASE_TYPES.merge!(
  :timestamp => { :name => "timestamp" }
)
