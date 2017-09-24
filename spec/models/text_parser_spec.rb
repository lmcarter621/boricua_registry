require 'rails_helper'

describe TextParser do
  context 'public methods' do
    describe '.parse_message(text_message)' do
      let(:fake_hash) {{:something => :here}}
      context 'for reporting' do
        let(:message) { "report this is just test data"}
        it 'should call parse_report' do
          allow(TextParser).to receive(:parse_report).and_return(fake_hash)
          expect(TextParser).to receive(:parse_report).once
          TextParser.parse_message(message)
        end
      end
      context 'for searching' do
        let(:message) { "find this is just test data"}
        it 'should call parse_find' do
          allow(TextParser).to receive(:parse_find).and_return(fake_hash)
          expect(TextParser).to receive(:parse_find).once
          TextParser.parse_message(message)
        end
      end
      context 'for other' do
        let(:message) { "🦑 not matching anything"}
        it 'should return {}' do
          result = TextParser.parse_message(message)
          expect(result).to eq({})
        end
      end
    end
  end

  context 'private methods' do
    describe '.parse_report' do
      let(:date_string) {"01/01/1998"}
      context 'with valid text' do
        context 'with everything' do
          let(:text_message) {"report Billy Bob Joe in City Name, Place born #{date_string} status Pretty Good 👍"}
          it "should return expected hash" do
            result = TextParser.parse_report(text_message, :en)
            expect(result[:first_name]).to eq("Billy")
            expect(result[:last_name]).to eq("Bob Joe")
            expect(result[:location]).to eq("City Name, Place")
            expect(result[:birthday]).to eq(Date.parse(date_string))
            expect(result[:status]).to eq("Pretty Good 👍")
          end
        end
        context 'without a birthday' do
          let(:text_message) {"report Billy Bob Joe in City Name, Place status Pretty Good 👍"}
          it "should return expected hash" do
            result = TextParser.parse_report(text_message, :en)
            expect(result[:first_name]).to eq("Billy")
            expect(result[:last_name]).to eq("Bob Joe")
            expect(result[:location]).to eq("City Name, Place")
            expect(result[:birthday]).to be_blank
            expect(result[:status]).to eq("Pretty Good 👍")
          end
        end
        context 'without a status' do
          let(:text_message) {"report Billy Bob Joe in City Name, Place born #{date_string}"}
          it "should return expected hash" do
            result = TextParser.parse_report(text_message, :en)
            expect(result[:first_name]).to eq("Billy")
            expect(result[:last_name]).to eq("Bob Joe")
            expect(result[:location]).to eq("City Name, Place")
            expect(result[:birthday]).to eq(Date.parse(date_string))
            expect(result[:status]).to be_blank
          end
        end
        context 'without birthday or status' do
          let(:text_message) {"report Billy Bob Joe in City Name, Place"}
          it "should return expected hash" do
            result = TextParser.parse_report(text_message, :en)
            expect(result[:first_name]).to eq("Billy")
            expect(result[:last_name]).to eq("Bob Joe")
            expect(result[:location]).to eq("City Name, Place")
            expect(result[:birthday]).to be_blank
            expect(result[:status]).to be_blank
          end
        end
      end
      context 'with invalid text' do
        context 'with blank name' do
          let(:text_message) {"report in City Name, Place born #{date_string} status Pretty Good 👍"}
          it "first_name and last_name should be_blank" do
            result = TextParser.parse_report(text_message, :en)
            expect(result[:first_name]).to be_blank
            expect(result[:last_name]).to be_blank
          end
        end
        context 'with no location' do
          let(:text_message) {"report Billy Bob Joe born #{date_string} status Pretty Good 👍"}
          it "location should be_blank" do
            result = TextParser.parse_report(text_message, :en)
            expect(result[:location]).to be_blank
          end
        end
      end
    end
    describe '.parse_find' do
      context 'by build_search_params_for_contact' do
        let(:message) { "find contact 123-456-7890"}
        it 'should call :build_search_params_for_contact' do
          allow(TextParser).to receive(:build_search_params_for_contact).and_return(true)
          expect(TextParser).to receive(:build_search_params_for_contact).once
          TextParser.parse_find(message, :en)
        end
      end
      context 'by build_search_parameters' do
        let(:message) { "find not-contact and data and things"}
        it 'should call :build_search_parameters' do
          allow(TextParser).to receive(:build_search_parameters).and_return(true)
          expect(TextParser).to receive(:build_search_parameters).once
          TextParser.parse_find(message, :en)
        end        
      end
    end
    describe '.build_search_params_for_contact' do
      let(:text_message) {"find contact #{contact_string}"}
      context 'with valid message' do
        let(:contact_string) {'123-456-7890'}
        it 'should return contact number without formatting' do
          result = TextParser.build_search_params_for_contact(text_message, :en)
          expect(result).to eq({message_type: :find, contact: contact_string.tr('-','')})
        end
      end
      context 'with missing contact' do
        let(:contact_string) {''}
        it 'should return {}' do
          result = TextParser.build_search_params_for_contact(text_message, :en)
          expect(result).to eq({})
        end
      end
      context 'with non-numeric contact' do
        let(:contact_string) {'aunt jane'}
        it 'should return {}' do
          result = TextParser.build_search_params_for_contact(text_message, :en)
          expect(result).to eq({})
        end
      end
    end
    describe '.build_search_parameters' do
      let(:date_string) {"01/01/1998"}
      let(:contact_string) {"123-456-7890"}

      context 'with valid text' do
        context 'with everything' do
          let(:text_message) {"find Billy Bob Joe in City Name, Place born #{date_string} contact #{contact_string}"}
          it "should return expected hash" do
            result = TextParser.send(:build_search_parameters, text_message, :en)
            expect(result[:first_name]).to eq("Billy")
            expect(result[:last_name]).to eq("Bob Joe")
            expect(result[:location]).to eq("City Name, Place")
            expect(result[:birthday]).to eq(Date.parse(date_string))
            expect(result[:contact]).to eq(contact_string.tr('-',''))
          end
        end
        context 'without birthday' do
          let(:text_message) {"find Billy Bob Joe in City Name, Place contact #{contact_string}"}
          it "should return expected hash" do
            result = TextParser.send(:build_search_parameters, text_message, :en)
            expect(result[:first_name]).to eq("Billy")
            expect(result[:last_name]).to eq("Bob Joe")
            expect(result[:location]).to eq("City Name, Place")
            expect(result[:birthday]).to be_blank
            expect(result[:contact]).to eq(contact_string.tr('-',''))
          end
        end
        context 'without contact' do
          let(:text_message) {"find Billy Bob Joe in City Name, Place born #{date_string}"}
          it "should return expected hash" do
            result = TextParser.send(:build_search_parameters, text_message, :en)
            expect(result[:first_name]).to eq("Billy")
            expect(result[:last_name]).to eq("Bob Joe")
            expect(result[:location]).to eq("City Name, Place")
            expect(result[:birthday]).to eq(Date.parse(date_string))
            expect(result[:contact]).to be_blank
          end
        end
        context 'without birthday or contact' do
          let(:text_message) {"find Billy Bob Joe in City Name, Place"}
          it "should return expected hash" do
            result = TextParser.send(:build_search_parameters, text_message, :en)
            expect(result[:first_name]).to eq("Billy")
            expect(result[:last_name]).to eq("Bob Joe")
            expect(result[:location]).to eq("City Name, Place")
            expect(result[:birthday]).to be_blank
            expect(result[:contact]).to be_blank
          end
        end
        context 'with invalid data' do
          context 'with blank name' do
            let(:text_message) {"find in City Name, Place born #{date_string}"}
            it "returns an empty hash" do
              result = TextParser.send(:build_search_parameters, text_message, :en)
              expect(result).to eq({})
            end
          end
          context 'with no location' do
            let(:text_message) {"find Billy Bob Joe born #{date_string}"}
            it "location should be_blank" do
              result = TextParser.send(:build_search_parameters, text_message, :en)
              expect(result).to eq({})
            end
          end

        end
      end
    end
    describe '.split_name' do
      context 'with one name' do
        let(:name_string) {"Billy"}
        it "returns empty hash" do
          expect(TextParser.split_name(name_string)).to be_empty
        end
      end
      context 'with even # names' do
        let(:name_string) {"Billy Bob Joe Bob"}
        it "splits equally between first and last names" do
          expected_hash = {:first_name => "Billy Bob", :last_name => "Joe Bob"}
          expect(TextParser.split_name(name_string)).to eq(expected_hash)
        end
      end
      context 'with odd # names' do
        let(:name_string) {"Billy Bob Joe Bob Joe"}
        it "adds extra name to last name" do
          expected_hash = {:first_name => "Billy Bob", :last_name => "Joe Bob Joe"}
          expect(TextParser.split_name(name_string)).to eq(expected_hash)
        end
      end
    end
    describe '.parse_birthday' do
      let!(:date_object) {Date.today}
      let(:date_string) {""}
      ['/','-','.'].each do |separator|
        ["%m#{separator}%d#{separator}%Y", "%m#{separator}%d#{separator}%Y"].each do |format|
          it "gets date for '#{format}'" do
            date_string = date_object.strftime(format)
            expect(TextParser.parse_birthday(date_string)).to eq(date_object)
          end
        end
      end
    end
  end  
end