require 'spec_helper'

describe Facebook::Messenger::Incoming do
  describe '.parse' do
    context 'when the payload is unknown' do
      let :payload do
        {
          'foo' => 'bar'
        }
      end

      it 'raises UnknownPayload' do
        expect { subject.parse(payload) }.to raise_error(
          Facebook::Messenger::Incoming::UnknownPayload, payload.to_s
        )
      end
    end

    context 'when the payload is a message' do
      let :payload do
        {
          'sender' => {
            'id' => '2'
          },
          'recipient' => {
            'id' => '3'
          },
          'timestamp' => 145_776_419_762_7,
          'message' => {
            'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
            'seq' => 73,
            'text' => 'Hello, bot!'
          }
        }
      end

      it 'returns an Incoming::Message' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::Message
        )
      end
    end

    context 'when the payload is a message echo' do
      let :payload do
        {
          'sender' => {
            'id' => '2'
          },
          'recipient' => {
            'id' => '3'
          },
          'timestamp' => 145_776_419_762_7,
          'message' => {
            'is_echo' => true,
            'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
            'seq' => 73,
            'text' => 'Hello, bot!'
          }
        }
      end

      it 'returns an Incoming::MessageEcho' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::MessageEcho
        )
      end
    end

    context 'when the payload is a delivery' do
      let :payload do
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

      it 'returns an Incoming::Delivery' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::Delivery
        )
      end
    end

    context 'when the payload is a postback' do
      let :payload do
        {
          'sender' => {
            'id' => '3'
          },
          'recipient' => {
            'id' => '3'
          },
          'timestamp' => 145_776_419_762_7,
          'postback' => {
            'payload' => 'USER_DEFINED_PAYLOAD'
          }
        }
      end

      it 'returns an Incoming::Postback' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::Postback
        )
      end
    end

    context 'when the payload is an optin' do
      let :payload do
        {
          'sender' => {
            'id' => '3'
          },
          'recipient' => {
            'id' => '3'
          },
          'timestamp' => 145_776_419_762_7,
          'optin' => {
            'ref' => 'PASS_THROUGH_PARAM'
          }
        }
      end

      it 'returns an Incoming::Optin' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::Optin
        )
      end
    end

    context 'when the payload is a read' do
      let :payload do
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

      it 'returns an Incoming::Read' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::Read
        )
      end
    end

    context 'when the payload is a standby' do
      let :payload do
        {
          'id' => '2',
          'time' => 1_458_692_752_478,
          'standby' => [
            {
              'sender' => {
                'id' => '3'
              },
              'recipient' => {
                'id' => '3'
              },
              'read' => {
                'watermark' => 145_866_885_625_3,
                'seq' => 38
              }
            }
          ]
        }
      end

      it 'returns an Incoming::Standby' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::Standby
        )
      end
    end

    context 'when the payload is a request_thread_control' do
      let(:payload) do
        {
          'id' => 2,
          'time' => 1_458_692_752_478,
          'request_thread_control' => {
            'requested_owner_app_id' => 123456789,
            'metadata' => 'abcdefg::123455'
          }
        }
      end

      it 'returns an Incoming::RequestThreadControl' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::RequestThreadControl
        )
      end
    end

    context 'when the payload is a game_play' do
      let :payload do
        {
          'sender' => {
            'id' => '3'
          },
          'recipient' => {
            'id' => '3'
          },
          'timestamp' => 145_776_419_762_7,
          'game_play' => {
            'game_id' => '<GAME-APP-ID>',
            'player_id' => '<PLAYER-ID>',
            'context_type' => '<CONTEXT-TYPE:SOLO|THREAD>',
            'context_id' => '<CONTEXT-ID>', # If a Messenger Thread context
            'score' => 100, # If a classic score based game
            'payload' => '<PAYLOAD>' # If a rich game
          }
        }
      end

      it 'returns an Incoming::GamePlay' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::GamePlay
        )
      end
    end
  end
end
