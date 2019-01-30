module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Hometown 40k"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def link_to_if(*args,&block)
    args.insert 1, capture(&block) if block_given?

    super *args
  end

end
