module ApplicationHelper

  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    errors = Array(instance.error_message).join(',')
    %(#{html_tag}<span class="validation-error"> #{errors}</span>).html_safe
  end
end
