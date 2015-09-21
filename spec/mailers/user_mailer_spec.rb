require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "order_placed_email" do
    let(:mail) { UserMailer.order_placed_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Order placed email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
