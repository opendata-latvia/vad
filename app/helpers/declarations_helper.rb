module DeclarationsHelper
  def status_label(status)
    case status
    when 'new' then 'lable-info'
    when 'error' then 'label-important'
    when 'skip' then 'label-warning'
    when 'imported' then 'label-success'
    end
  end
end
