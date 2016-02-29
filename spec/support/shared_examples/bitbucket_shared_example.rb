shared_examples 'an acceptable Bitbucket instance' do |database_examples|
  include_context 'a buildable docker image', '.', Env: ["CATALINA_OPTS=-Xms64m"]

  describe 'when starting a Bitbucket instance' do
    before(:all) { @container.start! PublishAllPorts: true }

    it { is_expected.to_not be_nil }
    it { is_expected.to be_running }
    it { is_expected.to have_mapped_ports tcp: 7990 }
    it { is_expected.not_to have_mapped_ports udp: 7990 }
    it { is_expected.to have_mapped_ports tcp: 7999 }
    it { is_expected.not_to have_mapped_ports udp: 7999 }
    it { is_expected.to wait_until_output_matches REGEX_STARTUP }
  end

  describe 'Going through the setup process' do
    subject { page }

    context 'when visiting the root page' do
      before :all do
        @container.setup_capybara_url tcp: 7990
        visit '/'
      end

      it { expect(current_path).to match '/unavailable' }
      it { is_expected.to have_css ' div.progress-bar' }
    end

    context 'when waiting for the setup page to be available' do
      before :all do
        wait_for_location_change
      end

      it { expect(current_path).to match '/setup' }
      it { is_expected.to have_css 'input#internal-true' }
      it { is_expected.to have_css 'input#internal-false' }
    end

    context 'when processing database setup' do
      include_examples database_examples
    end

    context 'when processing license setup' do
      before :all do
        choose 'has-key-radio'
        fill_in 'license', with: 'AAACLg0ODAoPeNqNVEtv4jAQvudXRNpbpUSEx6FIOQBxW3ZZiCB0V1WllXEG8DbYke3A8u/XdUgVQyg9ZvLN+HuM/e1BUHdGlNvuuEHQ73X73Y4bR4nbbgU9ZwFiD2IchcPH+8T7vXzuej9eXp68YSv45UwoASYhOeYwxTsIE7RIxtNHhwh+SP3a33D0XnntuxHsIeM5CIdwtvYxUXQPoRIF6KaC0FUGVlEB3v0hOAOWYiH9abFbgZith3i34nwOO65gsAGmZBhUbNC/nIpjhBWEcefJWelzqIDPWz/OtjmXRYv2XyqwnwueFkT57x8e4cLmbCD1QnX0UoKQoRc4EUgiaK4oZ2ECUrlZeay75sLNs2JDmZtWR8oPCfWZGwHAtjzXgIo0SqmZiKYJmsfz8QI5aI+zApuq6fqJKVPAMCPnNpk4LPW6kBWgkZb+kQAzzzS2g6Dnte69Tqvsr4SOskIqEFOeggz1v4zrHbr0yLJR8rU64FpQpVtBy1mZxM4CnHC9Faf8tKMnTF1AiXORFixyQaWto3RZ+ncWLXtMg6EnKZZRpmQNb2R8tnJXFulCfXmXLry7TrHBWn2HNVyH8WYxj9AzmsxiNL/R88Xg6rA1lVs4QpO5titxhplJcCY2mFFZLutAZVhKipm15/VhJx36YVqyN8YP7IaGC1+lwnJ7Q5pJpNmxk5hP3qovutY8Pi4E2WIJ59esnr1p+T6eD67teBVCHf+ga+ho4/4D9YItZDAsAhQ5qQ6pASJ+SA7YG9zthbLxRoBBEwIURQr5Zy1B8PonepyLz3UhL7kMVEs=X02q6'
        click_button 'Next'
        wait_for_page
      end

      it { expect(current_path).to match '/setup' }
      it { is_expected.to have_field 'username' }
      it { is_expected.to have_field 'fullname' }
      it { is_expected.to have_field 'email' }
      it { is_expected.to have_field 'password' }
      it { is_expected.to have_field 'confirmPassword' }
      it { is_expected.to have_button 'Go to Bitbucket' }
    end

    context 'when processing administrative account setup' do
      before :all do
        fill_in 'username', with: 'admin'
        fill_in 'fullname', with: 'Continuous Integration Administrator'
        fill_in 'email', with: 'bitbucket@circleci.com'
        fill_in 'password', with: 'admin'
        fill_in 'confirmPassword', with: 'admin'
        click_button 'Go to Bitbucket'
        wait_for_page
      end

      it { expect(current_path).to match '/login' }
      it { is_expected.to have_field 'j_username' }
      it { is_expected.to have_field 'j_password' }
      it { is_expected.to have_button 'Log in' }
    end

    context 'when logging in' do
      before :all do
        fill_in 'j_username', with: 'admin'
        fill_in 'j_password', with: 'admin'
        click_button 'Log in'
        wait_for_page
      end

      it { expect(current_path).to match '/getting-started' }
      # The acceptance testing comes to an end here since we got to the
      # Bitbucket dashboard without any trouble through the setup.
    end
  end

  describe 'Stopping the Bitbucket instance' do
    before(:all) { @container.kill_and_wait signal: 'SIGTERM' }

    it 'should shut down successful' do
      # give the container up to 5 minutes to successfully shutdown
      # exit code: 128+n Fatal error signal "n", ie. 143 = fatal error signal
      # SIGTERM.
      #
      # The following state check has been left out 'ExitCode' => 143 to
      # suppor CircleCI as CI builder. For some reason whether you send SIGTERM
      # or SIGKILL, the exit code is always 0, perhaps it's the container
      # driver
      is_expected.to include_state 'Running' => false
    end

    include_examples 'a clean console'
  end
end
