module Blueprint::HTML
  private def plain(content : String) : Nil
    ::HTML.escape(content, @buffer)
  end

  private def doctype : Nil
    @buffer << "<!DOCTYPE html>"
  end

  private def comment(&) : Nil
    @buffer << "<!--"
    ::HTML.escape(yield, @buffer)
    @buffer << "-->"
  end

  private def whitespace : Nil
    @buffer << " "
  end
end
