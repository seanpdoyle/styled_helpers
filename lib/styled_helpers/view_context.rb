class StyledHelpers::ViewContext
  delegate :to_h, :to_hash, :to_s, to: :@attributes

  def initialize(view_context, tag_name = :div, variants: {}, **defaults)
    @view_context = view_context
    @tag_name = tag_name.to_sym
    @variants = variants
    @attributes = view_context.tag.attributes(@variants.delete(:defaults), defaults)

    variants.each_key do |key|
      if respond_to?(key) || key.in?(StyledHelpers::Helpers.public_instance_methods(false))
        raise_collision!(key)
      end
    end
  end

  def merge!(...)
    tap { @attributes.merge!(...) }
  end
  alias_method :deep_merge!, :merge!

  def merge(...)
    dup.merge!(...)
  end
  alias_method :deep_merge, :merge
  alias_method :call, :merge

  ruby2_keywords def tag(*arguments, &block)
    if arguments.none? && block.nil?
      StyledHelpers::TagBuilder.new(@view_context.tag, @tag_name, @attributes)
    else
      @view_context.tag.with_options(@attributes).public_send(@tag_name, *arguments, &block)
    end
  end

  def with(*names, **choices, &block)
    sliced = variants_at(*names) + choices.filter_map { |name, variant| dig_variant(name, variant) }

    sliced.reduce(self, :merge).then { block.nil? ? _1 : _1.yield_self(&block) }
  end

  def dup
    StyledHelpers::ViewContext.new(
      @view_context,
      @tag_name,
      variants: @variants,
      **@attributes.dup
    )
  end

  def method_missing(name, ...)
    receiver =
      if (variant = find_variant_by_name!(name))
        define_singleton_method(name) do
          merge(variant).tap do |builder|
            if variant.is_a?(StyledHelpers::ViewContext)
              builder.instance_variable_set(:@tag_name, variant.instance_variable_get(:@tag_name))
            end
          end
        end

        self
      elsif @view_context.respond_to?(name)
        @view_context.with_options(@attributes)
      else
        super
      end

    receiver.public_send(name, ...)
  end

  def respond_to_missing?(name, include_private = false)
    @view_context.respond_to?(name, include_private)
  end

  private

  def variants_at(*names)
    names.flatten.map { |name| find_variant_by_name!(name) }.compact
  end

  def find_variant_by_name!(name)
    if (variants = select_variants_by_name(name))
      if variants.many?
        raise StyledHelpers::Helpers::NameError, "#{name.inspect} matches several variants"
      else
        variants.first
      end
    end
  end

  def select_variants_by_name(name)
    [
      dig_variant(name),
      *@variants.filter_map { |_, variant| variant[name] }
    ].compact.presence
  end

  def dig_variant(name, value = true)
    # rubocop:disable Lint/BooleanSymbol
    @variants.dig(name, value) || @variants.dig(name, true) || @variants.dig(name, :true)
    # rubocop:enable Lint/BooleanSymbol
  end

  def raise_collision!(key)
    raise StyledHelpers::Helpers::NameError, "Cannot define #{key.inspect}, it collides with a method name"
  end
end
