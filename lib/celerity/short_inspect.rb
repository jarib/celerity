module Celerity
  module ShortInspect

    def short_inspect(opts)
      if excluded_ivars = opts[:exclude]
        if is_ruby19
          excluded_ivars.map! { |ivar| ivar.to_sym }
        end
        ivars = (instance_variables - excluded_ivars)
      elsif included_ivars = opts[:include]
        if is_ruby19
          included_ivars.map! { |ivar| ivar.to_sym }
        end
        ivars = included_ivars
      else
        raise ArgumentError, "unknown arg: #{opts.inspect}"
      end

      ivars.map! { |ivar| "#{ivar}=#{instance_variable_get(ivar).inspect}" }
      '#<%s:0x%s %s>' % [self.class.name, self.hash.to_s(16), ivars.join(" ")]
    end

    private
    def is_ruby19
      RUBY_VERSION >= "1.9"
    end

  end
end
