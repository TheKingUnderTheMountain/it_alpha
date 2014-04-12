require 'spec_helper'

describe "User Pages" do
	subject { page }

	describe "profile page" do
	    let(:user) { FactoryGirl.create(:user) }
	    let!(:board1) { FactoryGirl.create(:board, user: user) }
	    let!(:board2) { FactoryGirl.create(:board, user: user) }
	    before { visit user_path(user) }

	    it { should have_content(user.first_name) }
	    it { should have_title([user.first_name, user.last_name].join(' ')) }
	    it { should have_selector('h2', text: 'Boards') }

	    describe "has a list of owned boards" do 
	    	it { should have_content(board1.name) }
      		it { should have_content(board2.name) }
      		it { should have_content(user.boards.count) }
	    end
	  end

  	describe "signup page" do
	    before { visit signup_path }

	    it { should have_content('Sign up') }
	    it { should have_title(full_title('Sign up')) }
	end

	describe "signup" do

	    before { visit signup_path }

	    let(:submit) { "Create my account" }

	    describe "with invalid information" do
	      it "should not create a user" do
	        expect { click_button submit }.not_to change(User, :count)
	      end

	      describe "after submission" do
	        before { click_button submit }

	        it { should have_title('Sign up') }
	        it { should have_content('error') }
	      end
	    end

	    describe "with valid information" do
	      before do
	        fill_in "First name",         with: "Example"
	        fill_in "Last name",         with: "User"
	        fill_in "Email",        with: "user@example.com"
	        fill_in "Password",     with: "foobar"
	        fill_in "Confirmation", with: "foobar"
	      end

	      it "should create a user" do
	        expect { click_button submit }.to change(User, :count).by(1)
	      end

	      describe "after saving the user" do
	        before { click_button submit }
	        let(:user) { User.find_by(email: 'user@example.com') }

	        it { should have_title([user.first_name, user.last_name].join(' ')) }
	        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
	      end

	      describe "after saving the user" do
	        before { click_button submit }
	        let(:user) { User.find_by(email: 'user@example.com') }

	        it { should have_link('Sign out') }
	        it { should have_title(user.first_name) }
	        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
	      end
	    end
	 end
end
