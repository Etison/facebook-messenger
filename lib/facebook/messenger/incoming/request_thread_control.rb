module Facebook
  module Messenger
    module Incoming
      class RequestThreadControl
        include Facebook::Messenger::Incoming::Common

        attr_reader :messaging

        # @see https://developers.facebook.com/docs/messenger-platform/handover-protocol/request-thread-control/
        # {
        #   "sender":{
        #     "id":"<USER_ID>"
        #   },
        #   "recipient":{
        #     "id":"<PSID>"
        #   },
        #   "timestamp":1458692752478,
        #   "request_thread_control":{
        #     "requested_owner_app_id":123456789,
        #     "metadata":"additional content that the caller wants to set"
        #   }
        # }
        def initialize(messaging)
          @messaging = messaging
        end

        def requested_owner_app_id
          @messaging['request_thread_control']['requested_owner_app_id']
        end

        def metadata
          @messaging['request_thread_control']['metadata']
        end
      end
    end
  end
end
