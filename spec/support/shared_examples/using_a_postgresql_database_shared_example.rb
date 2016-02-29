shared_examples 'using a PostgreSQL database' do
	describe 'selecting external database configuration' do
		before :all do
			choose 'internal-false'
			wait_for_page
		end

		it { is_expected.to have_field 'type' }
		it { is_expected.to have_field 'hostname' }
		it { is_expected.to have_field 'port' }
		it { is_expected.to have_field 'database' }
		it { is_expected.to have_field 'username' }
		it { is_expected.to have_field 'password' }
		it { is_expected.to have_button 'Next' }
	end

	describe 'setting up JDBC Configuration' do
		before :all do
			select 'PostgreSQL', from: 'type'
			fill_in 'hostname', with: $container_postgres.host
			fill_in 'port', with: '5432'
    	fill_in 'database', with: 'bitbucketdb'
    	fill_in 'username', with: 'postgres'
    	fill_in 'password', with: 'mysecretpassword'
			click_button 'Next'
			wait_for_page
		end

		it { expect(current_path).to match '/setup' }
	  it { is_expected.to have_css 'form#settings' }
	  it { is_expected.to have_css 'input#has-key-radio' }
	end
end
