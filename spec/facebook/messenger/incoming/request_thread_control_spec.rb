require 'spec_helper'

describe Facebook::Messenger::Incoming::RequestThreadControl do
  let(:requested_owner_app_id) { 123456789 }
  let(:metadata) { 'abcdefg::123455' }
  let(:payload) do
    {
      'id' => 2,
      'time' => 1_458_692_752_478,
      'request_thread_control' => {
        'requested_owner_app_id' => requested_owner_app_id,
        'metadata' => metadata
      }
    }
  end

  subject(:request_thread_control) { described_class.new(payload) }

  it 'parses the requested owner app id' do
    expect(request_thread_control.requested_owner_app_id).to eq(requested_owner_app_id)
  end

  it 'returns the metadata as a string' do
    expect(request_thread_control.metadata).to eq(metadata)
  end
end
