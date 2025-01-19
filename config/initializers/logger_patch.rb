require 'logger'

module ActiveSupport
    module LoggerThreadSafeLevel
        Logger::Severity.constants.each do |severity|
        const_set(severity, Logger::Severity.const_get(severity))
        end
    end
end