require 'java'

module JDI
  java_import com.sun.jdi.ThreadReference
  module ThreadReference
    Statuses = {}
    constants.each do |const|
      next unless const =~ /^THREAD_STATUS/
      Statuses[const_get(const)] = const["THREAD_STATUS_".length..-1].downcase
    end
  end
end