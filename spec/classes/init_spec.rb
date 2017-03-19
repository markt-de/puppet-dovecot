require 'spec_helper'
describe 'dovecot' do
  context 'with default values for all parameters' do
    it { should contain_class('dovecot') }
  end
end
