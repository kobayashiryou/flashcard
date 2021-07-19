require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validation check" do
    subject{ user.valid? }
    let(:user){ build(:user, uid: uid) }
    let(:uid){ Faker::Alphanumeric }
    context "uidが指定されている時" do
      it "userは作成される" do
        expect(subject).to eq true
      end
    end
    context "uidが指定されていない時" do
      let(:uid){ nil }
      it "エラーする" do
        subject
        expect(user.errors.messages[:uid]).to include "can't be blank"
      end
    end
  end
end
