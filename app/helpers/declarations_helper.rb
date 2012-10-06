module DeclarationsHelper
  def status_label(status)
    case status
    when 'new' then 'lable-info'
    when 'error' then 'label-important'
    when 'imported' then 'label-success'
    end
  end
end
