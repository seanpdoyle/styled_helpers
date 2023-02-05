module ApplicationHelper
  class StyledHelpers < ::StyledHelpers::Helpers
    def input
      styled :input, variants: {
        type: {
          text: {class: "font-bold"},
          checkbox: {class: "accent-red-500"}
        }
      }
    end
  end

  def ui
    StyledHelpers.new(self)
  end
end
