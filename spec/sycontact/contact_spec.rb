require 'sycontact/contact'

module Sycontact

  describe Contact do

    it "should respond to default attributes"

    context "with ad-hoc attributes" do
      before do
        attributes = { cn: :name, sn: :first_name, c: :country, l: :city, st: :state,
                       street: :street, o: :organization, ou: :department, title: :title,
                       description: :description, telephone: :telephone, mobile: :mobile,
                       mail: :email }
        @contact = Contact.new attributes
      end

    end

  end
end
