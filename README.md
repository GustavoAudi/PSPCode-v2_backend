# API Template

## Setup

1. Clone this repo.
2. Create your `database.yml` and `application.yml` file.
3. `bundle install`.
4. Generate a secret key with `rake secret` and paste this value into the `application.yml`.
5. `rake db:create`.
6. `rake db:migrate`.
7. `rails s`.

## Optional configuration

- Set your [frontend URL](https://github.com/cyu/rack-cors#origin) in `config/initializers/rack_cors.rb`.
- Set your mail sender in `config/initializers/devise.rb`.
- Decrease `token_lifespan` in `config/initializers/devise_token_auth.rb` if the frontend is a Web-app.
- Remove Facebook code with `git revert a8319a37ab8d038399a7a6bd74fe3869bb3f3ddc`.
- Config your timezone accordingly in `application.rb`.

## Deploy the app

- Install Docker and AWS CLI in your PC.
- Retrieve an authentication token and authenticate your Docker client to your registry.
  Use the AWS CLI:
  - `aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/m9q5t8l6`.
- Build your Docker image using the following command:
  - `docker build -t psp-code-backend .`.
- After the build completes, tag your image so you can push the image to this repository:
  - `docker tag psp-code-backend:{version} public.ecr.aws/m9q5t8l6/psp-code-backend:{version}`
- Run the following command to push this image to your newly created AWS repository:
  - `docker push public.ecr.aws/m9q5t8l6/psp-code-backend:{version}`
- Connect to de Droplet 2 on web.
- Pull image in the Droplet:
  - Modify name of backend version image in docker-compose file and save changes.
  - Run command `docker compose up -d` to deploy the last version.

## Code quality

With `rake code_analysis` you can run the code analysis tool, you can omit rules with:

- [Rubocop](https://github.com/bbatsov/rubocop/blob/master/config/default.yml) Edit `.rubocop.yml`
- [Reek](https://github.com/troessner/reek#configuration-file) Edit `config.reek`
- [Rails Best Practices](https://github.com/flyerhzm/rails_best_practices#custom-configuration) Edit `config/rails_best_practices.yml`
- [Brakeman](https://github.com/presidentbeef/brakeman) Run `brakeman -I` to generate `config/brakeman.ignore`
- [Bullet](https://github.com/flyerhzm/bullet#whitelist) You can add exceptions to a bullet initializer or in the controller
