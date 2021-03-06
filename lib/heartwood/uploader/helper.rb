module Heartwood
  module Icons
    module Helper

      def heartwood_icons(options = {})
        form = Form.new(options)
        _hwupl_form(form) + _hwupl_tmpl_container(form) + _hwupl_tmpl_script(form)
      end

      def _hwupl_form(form)
        form_tag(form.url, form.form_options) do
          html = file_field_tag(:file, multiple: form.allow_multiple_files, id: form.upload_field_id)
          form.fields.each { |name, value| html += hidden_field_tag(name, value) }
          html.html_safe
        end
      end

      def _hwupl_tmpl_container(form)
        content_tag(:div, nil, id: form.template_container_id)
      end

      def _hwupl_tmpl_script(form)
        %{
          <script id="#{form.template_id}" type="text/x-tmpl">
            <div class="heartwood-icons-template">
              <span class="hwupl-filename">{%= o.name %}</span>
              <input type="hidden" class="#{form.url_field_class}" id="hw-{%= Heartwood.Icons.currentIndex() %}" name="#{form.url_field_name}" data-url-field>
              <div class="progress">
                <div class="progress-bar">
                  <span class="progress-value"></span>
                </div>
              </div>
              <p class="hwupl-error text-danger"></p>
              <p class="hwupl-success text-success"></p>
            </div>
          </script>
        }.html_safe
      end

    end
  end
end
