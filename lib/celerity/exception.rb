module Celerity
  module Exception

    #
    # Superclass for all Celerity exceptions.
    #

    class CelerityException < StandardError; end

    #
    # This exception is thrown if an attempt is made to access an object that doesn't exist
    #

    class UnknownObjectException < CelerityException; end

    #
    # This exception is thrown if an attempt is made to access an object that is in a disabled state
    #

    class ObjectDisabledException < CelerityException; end

    #
    # This exception is thrown if an attempt is made to access a frame that cannot be found
    #

    class UnknownFrameException < CelerityException; end

    #
    # This exception is thrown if an attempt is made to access a form that cannot be found
    #

    class UnknownFormException < CelerityException; end

    #
    # This exception is thrown if an attempt is made to access an object that is in a read-only state
    #

    class ObjectReadOnlyException < CelerityException; end

    #
    # This exception is thrown if an attempt is made to access an object when the specified value cannot be found
    #

    class NoValueFoundException < CelerityException; end

    #
    # This exception gets raised if the how argument is wrong.
    #

    class MissingWayOfFindingObjectException < CelerityException; end

    #
    # This exception is raised if an attempt is made to access a table row that doesn't exist
    #

    class UnknownRowException < CelerityException; end

    #
    # This exception is raised if an attempt is made to access a table cell that doesn't exist
    #

    class UnknownCellException < CelerityException; end

    #
    # This exception is thrown if an http error, such as a 404, 500 etc is encountered while navigating
    #

    class NavigationException < CelerityException; end

    #
    # This exception is thrown if an unexpected content type is returned by the server.
    #

    class UnexpectedPageException < CelerityException; end

    #
    # This exception is thrown if an unexpected content type is returned by the server.
    #

    class CookieNotFoundError < CelerityException; end

  end # Exception
end # Celerity