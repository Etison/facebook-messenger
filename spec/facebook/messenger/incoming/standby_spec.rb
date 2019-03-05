require 'spec_helper'

describe Facebook::Messenger::Incoming::Standby do
  let :payload do
    {
      'id' => '3',
      'time' => 145_776_419_762_7,
      'standby' => standby_events
    }
  end
  let :read_payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'read' => {
        'watermark' => 145_866_885_625_3,
        'seq' => 38
      }
    }
  end
  let :delivery_payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'delivery' => {
        'mids' => [
          'mid.1457764197618:41d102a3e1ae206a38',
          'mid.1458668856218:ed81099e15d3f4f233'
        ],
        'watermark' => 145_866_885_625_3,
        'seq' => 37
      }
    }
  end
  let :postback_payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'postback' => {
        'payload' => 'USER_DEFINED_PAYLOAD',
        'referral' => {
          'ref' => 'my-ref-value',
          'source' => 'SHORTLINK',
          'type' => 'OPEN_THREAD'
        }
      }
    }
  end
  let :message_payload do
    {
      'sender' => {
        'id' => '6'
      },
      'recipient' => {
        'id' => '9'
      },
      'timestamp' => 145_776_429_762_4,
      'message' => {
        'is_echo' => false,
        'app_id' => 184_719_329_222_930_001,
        'mid' => 'mid.1457764197618:41d102a3e1ae206a38'
      }
    }
  end
  let(:random_payload) { { 'random' => 'payload' } }
  let(:standby_events) do
    [
      read_payload, delivery_payload,
      postback_payload, message_payload,
      random_payload
    ]
  end

  subject(:standby) { described_class.new(payload) }

  it 'returns lists of supported events' do
    expect(subject.id).to eq '3'
    expect(subject.time).to be_present
    expect(subject.events.size).to eq 4

    expect(subject.events[0]).to be_a Facebook::Messenger::Incoming::Read
    expect(subject.events[1]).to be_a Facebook::Messenger::Incoming::Delivery
    expect(subject.events[2]).to be_a Facebook::Messenger::Incoming::Postback
    expect(subject.events[3]).to be_a Facebook::Messenger::Incoming::Message
  end
end
