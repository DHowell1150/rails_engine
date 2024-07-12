class ErrorSerializer
    def initialize(error)
        @error = error
    end

    def serialize_json
        {
            errors: [
                {
                    status: @error.status.to_s,
                    title: @error.message,
                }
            ]
        }
    end

    def invalid_params
        {
            data: {
                errors: [
                    {
                        status: @error.status.to_s,
                        title: @error.message,
                    }
                ]
            }
        }
    end
end