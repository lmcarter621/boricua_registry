class MessageProcessor
  def self.process_message(message:, sender:)
    self.new(message: message, sender: sender).process_message
  end

  def initialize(message:, sender:)
    @message = message
    @sender = sender
  end

  def process_message
    return unknown_message_type unless reporting? || searching?
    return search_person if searching?
    return add_person if reporting?
  end

  private

  attr_reader :message, :sender

  def message_parts
    @message_parts ||= TextParser.parse_message(message)
  end

  def message_type
    @message_type ||= message_parts[:message_type]
  end

  def reporting?
    message_type == :report
  end

  def searching?
    message_type == :find
  end

  def add_person
    FoundPerson.create!(message_parts.merge(reported_by_number: sender).except!(:message_type))

    "Dios te bendiga."
  end

  def search_person
    #TODO  use where in place of findby to indicate the search must be narrowed
    person = FoundPerson.where(message_parts.except!(:message_type)).first

    if person.present?
      "#{person.first_name} #{person.last_name} en #{person.location} ha sido encontrado."
    else
      "No podemos encontrarle.  Intentaló otra vez y tener fé."
    end
  end

  def unknown_message_type
    " Usar: 'Busco [nombres] [apellidos] en [ciudad] nació[dd-mm-aaaa]' o" \
    " 'Descubrir [nombres] [apellidos] en [ciudad]'"
  end
end