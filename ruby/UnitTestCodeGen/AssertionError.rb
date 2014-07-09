################################################################
# Class that provides API for throwing a runtime assertion error
################################################################
class AssertionError < RuntimeError
end

def assert &block
    raise AssertionError unless yield
end