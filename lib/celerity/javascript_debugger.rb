module Celerity
  class JavascriptDebugger
    include Java::net.sourceforge.htmlunit.corejs.javascript.debug.Debugger

    def handleCompilationDone(ctx, script, source)
      p debug_info_for(script).merge(:source_code => source)
    end

    def getFrame(ctx, script)
      p debug_info_for(script)
    end

    private

    def string_for_context(ctx)
      ctx.toString
    end

    def string_for_script(script)
      script.toString
    end

    def debug_info_for(script)
      {
        :source        => "#{script.getSourceName}:#{script.getLineNumbers.to_a.join(",")}",
        :function_name => script.getFunctionName,
        :params        => (0...script.getParamAndVarCount).map { |idx| script.getParamOrVarName(idx) },
        :function?     => script.isFunction,
      }
    end
  end
end