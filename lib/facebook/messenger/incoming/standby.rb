module Facebook
  module Messenger
    module Incoming
      #
      # The Standby class represents an incoming Facebook Messenger when the handover-protocol is enabled.
      # It's possible to receive:
      #  - message_reads
      #  - message_deliveries
      #  - messages
      #  - messaging_postbacks
      #
      # IMPORTANT: the postbak payload is received here only if CF has sent the original postback button
      #
      # @see https://developers.facebook.com/docs/messenger-platform/handover-protocol
      # @see https://developers.facebook.com/docs/messenger-platform/reference/webhook-events/standby
      #
      class Standby
        attr_reader :messaging, :events

        #
        # Assign message to instance variable and build events list
        #
        # @param [Object] messaging Object of message.
        #
        def initialize(messaging)
          @messaging = messaging
          @events = messaging['standby'].nil? ? [] : build_events
        end

        #
        # Function return Page ID from where we received the event.
        #
        # @return [String] Page ID
        #
        def id
          messaging['id']
        end

        #
        # Function return timestamp when message is sent.
        #
        # @return [Object] Message time sent.
        #
        def time
          Time.at(messaging['time'] / 1000)
        end

        private

        def build_events
          messaging['standby'].map do |event|
            key = (event.keys - %w[sender recipient timestamp]).first

            next unless Facebook::Messenger::Incoming::EVENTS.include?(key)

            Facebook::Messenger::Incoming::EVENTS[key].new(event[key])
          end.compact
        end
      end
    end
  end
end
