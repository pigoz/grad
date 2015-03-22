require 'rbconfig'

class Grad::Event < Struct.new(:type, :key)
  TYPES = %i(keydown keyup)

  TYPES.each do |x|
    define_singleton_method(x) do |key|
      new(x, key)
    end

    define_method("#{x}?") do
      type == x
    end
  end

  module Darwin
    extend FFI::Library
    ffi_lib '/System/Library/Frameworks/ApplicationServices.framework/ApplicationServices'

    enum :tap_location, [
      :hid_event_tap, 0,
      :session_event_tap,
      :annotated_session_event_tap
    ]

    attach_function :keyboard_event,
                    'CGEventCreateKeyboardEvent', [:pointer, :int, :bool],
                    :pointer
    attach_function :post_event,
                    'CGEventPost', [:tap_location, :pointer],
                    :void
    attach_function :release,
                    'CFRelease', [:pointer],
                    :void
  end

  def post_darwin
    event = Darwin.keyboard_event(nil, key, keydown?)
    Darwin.post_event(:annotated_session_event_tap, event)
    Darwin.release(event)
  end

  def post
    public_send("post_#{os}")
  end

  def os
    case RbConfig::CONFIG['host_os']
    # when /mswin|windows/i then :win32
    # when /linux|arch/i then :linux
    when /darwin/i then :darwin
    else raise "OS '#{CONFIG['host_os']}' not supported"
    end
  end
end
