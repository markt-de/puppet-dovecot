require 'spec_helper_acceptance'

describe 'dovecot' do
  context 'with default parameters' do
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'dovecot':
        plugins => ['lmtp'],
        config => {
          hostname  => $fqdn,
          listen    => '*, ::',
          protocols => 'lmtp',
        },
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
