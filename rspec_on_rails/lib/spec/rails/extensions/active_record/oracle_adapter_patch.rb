if defined?(OCI8AutoRecover)
  module OracleAdapterPatch
    def describe(name)
      @connection.describe(name)
    end
  end
  OCI8AutoRecover.send(:include, OracleAdapterPatch)
end
