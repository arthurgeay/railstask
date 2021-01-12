prepare-dev:
		cp ${PWD}/config/database.yml.example ${PWD}/config/database.yml
		bundle install
		yarn install
		rails db:create
		rails db:migrate
		rails db:seed
		rails server