require "test_helper"

class StyledHelpers::ActionViewHelpersTest < ActionDispatch::IntegrationTest
  test "extends FormBuilder#with_options accepts tag.attributes (block)" do
    post examples_path, params: {template: <<~ERB}
      <%= fields do |form| %>
      <% form.with_options ui.input.text do |special_form| %>
          <%= special_form.text_field :text, class: "text" %>
        <% end %>
      <% end %>
    ERB

    assert_html_equal <<~HTML, response.body
      <input class="font-bold text" type="text" name="text" id="text" />
    HTML
  end

  test "extends FormBuilder#with_options accepts tag.attributes (instance)" do
    post examples_path, params: {template: <<~ERB}
      <%= fields do |form| %>
        <%= form.with_options(ui.input.text).text_field :text, class: "text" %>
      <% end %>
    ERB

    assert_html_equal <<~HTML, response.body
      <input class="font-bold text" type="text" name="text" id="text" />
    HTML
  end

  test "extends collection Builder#with_options accepts tag.attributes (block)" do
    post examples_path, params: {template: <<~ERB}
      <%= collection_check_boxes :record, :choice, ["a"], :to_s, :to_s, {include_hidden: false} do |builder| %>
        <% builder.with_options ui.input.checkbox do |special_builder| %>
          <%= special_builder.check_box class: "override" %>
        <% end %>
      <% end %>
    ERB

    assert_html_equal <<~HTML, response.body
      <input class="accent-red-500 override" type="checkbox" value="a" name="record[choice][]" id="record_choice_a" />
    HTML
  end

  test "extends collection Builder#with_options accepts tag.attributes (instance)" do
    post examples_path, params: {template: <<~ERB}
      <%= collection_check_boxes :record, :choice, ["a"], :to_s, :to_s, {include_hidden: false} do |builder| %>
        <%= builder.with_options(ui.input.checkbox).check_box class: "override" %>
      <% end %>
    ERB

    assert_html_equal <<~HTML, response.body
      <input class="accent-red-500 override" type="checkbox" value="a" name="record[choice][]" id="record_choice_a" />
    HTML
  end

  def assert_html_equal(expected, actual, *rest)
    assert_equal expected.squish, actual.squish, *rest
  end
end
