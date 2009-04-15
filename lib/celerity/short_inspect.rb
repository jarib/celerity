module Celerity
  module ShortInspect

    def short_inspect(opts)
      if excluded_ivars = opts[:exclude]
        ivars = (instance_variables - excluded_ivars)
      elsif included_ivars = opts[:include]
        ivars = included_ivars
      else
        raise ArgumentError, "unknown arg: #{opts.inspect}"
      end

      ivars.map! { |ivar| "#{ivar}=#{instance_variable_get(ivar).inspect}" }
      '#<%s:0x%s %s>' % [self.class.name, self.hash.to_s(16), ivars.join(" ")]
    end



  end
end