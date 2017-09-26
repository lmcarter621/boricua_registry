module TextParserCommands
  # Lazy basic language support
  def find(language)
    case language
    when :en
      'find'
    when :es
      'busco'
    end
  end

  def report(language)
    case language
    when :en
      'register'
    when :es
      'registrar'
    end
  end
  
  
  def in_location(language)
    case language
    when :en
      'in'
    when :es
      'en'
    end
  end
  
  
  def born(language)
    case language
    when :en
      'born'
    when :es
      'nació'
    end
  end
  
  
  def status(language)
    case language
    when :en
      'status'
    when :es
      'status'
    end
  end
  
  
  def contact(language)
    case language
    when :en
      'contact'
    when :es
      'contacto'
    end
  end
end