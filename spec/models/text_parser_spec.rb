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
          expect(result).to be_a(Hash)
          expect(result).to be_empty
        end
      end
    end
  end

  context 'private methods' do
    describe '.parse_found' do
      let(:date_string) {"01/01/1998"}
      context 'with valid text' do
        context 'with everything' do
          let(:text_message) {"report billy bob joe in city name, place born #{date_string} status pretty good 👍"}
          it "should return expected hash" do
            result = TextParser.parse_report(text_message)
            expect(result[:first_name]).to eq("billy")
            expect(result[:last_name]).to eq("bob joe")
            expect(result[:location]).to eq("city name, place")
            expect(result[:birthday]).to eq(Date.parse(date_string))
            expect(result[:status]).to eq("pretty good 👍")
          end
        end
        context 'without a birthday' do
          let(:text_message) {"report billy bob joe in city name, place status pretty good 👍"}
          it "should return expected hash" do
            result = TextParser.parse_report(text_message)
            expect(result[:first_name]).to eq("billy")
            expect(result[:last_name]).to eq("bob joe")
            expect(result[:location]).to eq("city name, place")
            expect(result[:birthday]).to be_blank
            expect(result[:status]).to eq("pretty good 👍")
          end
        end
        context 'without a status' do
          let(:text_message) {"report billy bob joe in city name, place born #{date_string}"}
          it "should return expected hash" do
            result = TextParser.parse_report(text_message)
            expect(result[:first_name]).to eq("billy")
            expect(result[:last_name]).to eq("bob joe")
            expect(result[:location]).to eq("city name, place")
            expect(result[:birthday]).to eq(Date.parse(date_string))
            expect(result[:status]).to be_blank
          end
        end
        context 'without birthday or status' do
          let(:text_message) {"report billy bob joe in city name, place"}
          it "should return expected hash" do
            result = TextParser.parse_report(text_message)
            expect(result[:first_name]).to eq("billy")
            expect(result[:last_name]).to eq("bob joe")
            expect(result[:location]).to eq("city name, place")
            expect(result[:birthday]).to be_blank
            expect(result[:status]).to be_blank
          end
        end
      end
      context 'with invalid text' do
        context 'with blank name' do
          let(:text_message) {"report in city name, place born #{date_string} status pretty good 👍"}
          it "first_name and last_name should be_blank" do
            result = TextParser.parse_report(text_message)
            expect(result[:first_name]).to be_blank
            expect(result[:last_name]).to be_blank
          end
        end
        context 'with no location' do
          let(:text_message) {"report billy bob joe born #{date_string} status pretty good 👍"}
          it "location should be_blank" do
            result = TextParser.parse_report(text_message)
            expect(result[:location]).to be_blank
          end
        end
        context 'with no birthday' do
          let(:text_message) {"report billy bob joe in city name, place status pretty good 👍"}
          it "location should be_blank" do
            result = TextParser.parse_report(text_message)
            expect(result[:birthday]).to be_blank
          end
        end
        context 'with no status' do
          let(:text_message) {"report billy bob joe in city name, place born #{date_string}"}
          it "location should be_blank" do
            result = TextParser.parse_report(text_message)
            expect(result[:status]).to be_blank
          end
        end

      end
    end
    describe '.parse_find' do
      pending 'Not Implemented Yet...'
    end
    describe '.split_name' do
      context 'with one name' do
        let(:name_string) {"billy"}
        it "returns empty hash" do
          expect(TextParser.split_name(name_string)).to be_empty
        end
      end
      context 'with even # names' do
        let(:name_string) {"billy bob joe bob"}
        it "splits equally between first and last names" do
          expected_hash = {:first_name => "billy bob", :last_name => "joe bob"}
          expect(TextParser.split_name(name_string)).to eq(expected_hash)
        end
      end
      context 'with odd # names' do
        let(:name_string) {"billy bob joe bob joe"}
        it "adds extra name to last name" do
          expected_hash = {:first_name => "billy bob", :last_name => "joe bob joe"}
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