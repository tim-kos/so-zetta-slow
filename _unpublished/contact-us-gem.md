- contact_us gem
- gem organization
- How Rails engines work (link to Akita's blog post, rails guides)
- HTTP verbs and actions: how the form created in the new action is doing a create action when submitted, thus calling controller#create, doing all the magic (rails basics are important!)
- ActiveMailer
- Very clever code to write email= and message=, through some metaprogramming (not very effective when there's more than :email and :message tho):
	attr_accessor :email, :message

	def initialize(attributes = {})
	  attributes.each do |key, value|
	    self.send("#{key}=", value)
	  end
	end

How it works
============

You go to the new action url (/contact_us), fill in the form, submit it - this is a HTTP POST, translated to a create action, so ContactsController#create is called.

This method creates a new Contact instance, giving it the parameters from the form (:email and :message). The 'metaprogramming trick' used enables it to saves to its instance variables the email and message. Then the save method is called, verifying it it's a valid email, proceeding to create and deliver an email through ActionMailer's subclass, ContactMailer.

If everything's ok, we are redirected to the root of the site and :notice (?) is filled. In case of error, flash[:error] receives a message and we re-render the new page (new.html.erb). And its complete!