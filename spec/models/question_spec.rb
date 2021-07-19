require "rails_helper"

RSpec.describe Question, type: :model do
  describe "validation check" do
    subject { question.valid? }

    let(:question) { build(:question, body: body) }
    let(:body) { Faker::Lorem.sentence }
    context "bodyが指定されている時" do
      it "questionは作成される" do
        expect(subject).to eq true
      end
    end

    context "bodyがnilの時" do
      let(:body) { nil }
      it "エラーする" do
        subject
        expect(question.errors.messages[:body]).to include "can't be blank"
      end
    end
  end
end
