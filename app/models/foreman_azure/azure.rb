module ForemanAzure
  class Azure < ComputeResource
    validates :url, :user, :password, :presence => true

    before_create :update_public_key

    def azure_pem
      attrs[:azure_pem]
    end

    def azure_pem=(pem)
      attrs[:azure_pem] = pem
    end

    def self.model_name
      ComputeResource.model_name
    end

    def test_connection(opts = {})
      #TODO
      true
    end

    def hyprevisor
      #TODO
      #client.servers.first
      true
    end

    protected

    def client
      @client ||= Fog::Compute.new(
        :provider => 'Azure',
        :azure_sub_id => user,
        :azure_pem => ca_cert_store(azure_pem),
        :azure_api_url => url
      )
    end

    def ca_cert_store(cert)
      return if cert.blank?
      OpenSSL::X509::Store.new.add_cert(OpenSSL::X509::Certificate.new(cert))
    rescue => e
      raise _("Failed to create X509 certificate, error: %s" % e.message)
    end

    private

    def update_public_key(options = {})
      return unless azure_pem.blank? || options[:force]
      client
    rescue Foreman::FingerprintException => e
      raise "Fingerprint invalid"
      # self.public_key = e.fingerprint if self.public_key.blank?
    end

  end
end