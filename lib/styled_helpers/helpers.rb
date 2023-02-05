class StyledHelpers::Helpers
  class NameError < StyledHelpers::Error
  end

  def initialize(view_context, &block)
    @view_context = view_context

    instance_exec(&block) if block
  end

  def styled(...)
    StyledHelpers::ViewContext.new(@view_context, ...)
  end
end
