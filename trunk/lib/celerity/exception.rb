module Celerity
  module Exception

    # Root class for all Celerity Exceptions
    class CelerityException < RuntimeError  
        def initialize(message="")
            super(message)
        end
    end
    
    # This exception is thrown if an attempt is made to access an object that doesn't exist
    class UnknownObjectException < CelerityException; end
      
    # This exception is thrown if an attempt is made to access an object that is in a disabled state
    class ObjectDisabledException < CelerityException; end
      
    # This exception is thrown if an attempt is made to access a frame that cannot be found 
    class UnknownFrameException < CelerityException; end
      
    # This exception is thrown if an attempt is made to access a form that cannot be found 
    class UnknownFormException < CelerityException; end
      
    # This exception is thrown if an attempt is made to access an object that is in a read only state
    class ObjectReadOnlyException < CelerityException; end
      
    # This exception is thrown if an attempt is made to access an object when the specified value cannot be found
    class NoValueFoundException < CelerityException; end
      
    # This exception gets raised if part of finding an object is missing
    class MissingWayOfFindingObjectException < CelerityException; end
      
    # this exception is raised if an attempt is made to access a table cell that doesnt exist
    class UnknownCellException < CelerityException; end
      
    # This exception is thrown if an http error, such as a 404, 500 etc is encountered while navigating
    class NavigationException < CelerityException; end
      
    # This exception is raised if a timeout is exceeded
    class TimeOutException < CelerityException
      def initialize(duration, timeout)
        @duration, @timeout = duration, timeout
        super
      end 
      attr_reader :duration, :timeout
    end
    
  end
end