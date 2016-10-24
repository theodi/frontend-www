class Newsletters
  include ActiveModel::Validations

  attr_accessor :email, :first_name, :last_name, :id
  validates_presence_of :first_name, :last_name, :email, :id

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def subscribe!
    return unless valid?
    subscribe = Gibbon::API.lists.subscribe({
                  id: id,
                  email: {
                    email: email
                  },
                  merge_vars: {
                    FNAME: first_name,
                    LNAME: last_name
                  }
                })

    errors.add(subscribe["name"] + "|", subscribe["error"].split(". Click here").first) if subscribe["error"]
  end

end
