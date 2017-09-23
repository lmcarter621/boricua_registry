class TextParser
  
  # parse text message and return hash of found values
  def self.parse_message(text_message)
    if text_message =~/report/i
      parse_report(text_message)
    elsif text_message =~/find/i
      parse_find(text_message)
    else
      # error so return empty hash
      {}
    end
  end

  private

  #  found X in X born X (status X) (contact X)  
  def self.parse_report(text_message)
    response = {message_type: :report}

    # split off names
    names, text_message = text_message&.scan(/report (.*) in (.*)/i)&.flatten
    # see if born follows location
    location, remaining_message = text_message&.scan(/(.*) (born .*)/i)&.flatten
    if location.present?
      # see if status follow born
      birthday_string, status = remaining_message&.scan(/(.*) status (.*)/i).flatten
      birthday_string = remaining_message.scan(/born (.*)/i)&.flatten&.first unless birthday_string
    else
      # see if status follows location
      location, status = text_message&.scan(/(.*) status (.*)/i)&.flatten
    end
    # none of it so location is just the rest of the message
    location = text_message unless location.present?
        
    return {} if names.blank? || location.blank?
    response.merge!(split_name(names)) if names.present?

    response[:location] = location if location.present?
    response[:status] = status if status.present?

    birthday = parse_birthday(birthday_string)
    response[:birthday] = birthday if birthday.present?

    response
  end
  
  #  find X in X (born X) (contact X)
  #  find contact X
  def self.parse_find(text_message)
    response = {message_type: :find}
    # TODO: All this
  end
  
  # Split Fullname string to a hash w/ first_name and last_name
  def self.split_name(name_string)
    # 3 spaces -> 2 firstname 2 lastname
    # 2 spaces -> 1 firstname 2 lastname
    # 1 space  -> 1 firstname 1 lastname
    # 0 spaces -> return empty
    response = {}
    names = name_string.split(" ")

    # Only one 1 name... return empty hash
    return {} if names.count <= 1
    
    middle = (names.count / 2)
    if (names.count % 2) == 0
      # even #, split down the middle
      response[:first_name] = names[0..(middle - 1)].join(" ")
      response[:last_name] = names[middle..-1].join(" ")
    else
      # odd # and > 1, put the extra name on the last name
      first_name_ending = middle -1
      response[:first_name] = names[0..first_name_ending].join(" ")
      response[:last_name] = names[middle..-1].join(" ")
    end
    response
  end
  
  # Simple american date parsing just give it over to rails
  def self.parse_birthday(date_string)
    date = Date.strptime(date_string.tr('-.','/'), "%m/%d/%Y") rescue nil
    date ||= Date.parse(date_string) rescue nil
    date
  end
end