require "rails_helper"

describe MessageProcessor do
  context "registering person found" do
    it "should process and return a supportive message" do
      expect(FoundPerson).to receive(:create!)

      result = MessageProcessor.process_message(
        message: "register Jane Doe in Uptown born 01-01-1990",
        sender: "7875557777",
      )

      expect(result).to eq("Dios te bendiga.")
    end
  end

  context "searching for a person" do
    it "should return a found person information if registered" do
      person = FoundPerson.create(person_hash.merge(reported_by_number: "7878887777"))
      allow(FoundPerson).to receive(:where).and_return([person])

      result = MessageProcessor.process_message(
        message: "Find Jane Doe in Uptown",
        sender: "7875557777",
      )

      expect(result).to eq("Jane Doe en Uptown ha sido encontrado.")
    end

    it "should return a not found message if not registered" do
      allow(FoundPerson).to receive(:where).and_return([])

      result = MessageProcessor.process_message(
        message: "Find Jane Doe in Uptown",
        sender: "7875557777",
      )

      expect(result).to eq("No podemos encontrarle.  Intentaló otra vez y tener fé.")
    end
  end
  context "invalid text" do
    it "should not process and return a message with directions" do
      result = MessageProcessor.process_message(
        message: "Help me.",
        sender: "7875557777",
      )

      expect(result).to eq( 
        "Use (Busco o Registrar) [nombres] [apellidos] en [ciudad] nació [dd-mm-aaaa]." \
        " Vea el registro en http://www.boricuaregistry.info/found_people")
    end
  end
end

def person_hash
  {
    first_name: "Jane",
    last_name: "Doe",
    location: "Uptown",
    birthday: "01-01-1990",
  }
end