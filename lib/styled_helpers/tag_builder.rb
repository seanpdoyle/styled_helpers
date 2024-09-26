class StyledHelpers::TagBuilder
  def initialize(tag, tag_name, attributes)
    @tag = tag
    @tag_name = tag_name
    @attributes = attributes
    @tag_with_options = tag.with_options(attributes)
  end

  def to_s
    @tag.public_send(@tag_name, nil, **@attributes)
  end

  def method_missing(name, ...)
    @tag_with_options.public_send(name, ...)
  end

  def respond_to_missing?(name, ...)
    @tag_with_options.respond_to?(name)
  end
end
