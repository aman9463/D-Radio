set :branch, 'master'
set :stage, :production
# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{165.227.225.85}
role :web, %w{165.227.225.85}
role :db,  %w{165.227.225.85}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server '165.227.225.85', user: 'deploy', roles: %w{web app db node}

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

namespace :deploy do



  task :start do
    on roles(:app) do
      execute :sudo, "start dradio"
    end
  end

  task :restart do
    on roles(:app) do
      execute :sudo, "restart dradio"
    end
  end


  # task :default do
  #   update
  #   assets.precompile
  #   restart
  #   cleanup
  #   # etc
  # end

  # namespace :assets do
  #  desc "Precompile assets locally and then rsync to deploy server"
  #   task :precompile, :only => { :primary => true } do
  #     run_locally "bundle exec rake assets:precompile"
  #     servers = find_servers :roles => [:app], :except => { :no_release => true }
  #     servers.each do |server|
  #       run_locally "rsync -av ./public/#{assets_prefix}/ #{user}@#{server}:#{current_path}/public/#{assets_prefix}/"
  #     end
  #     run_locally "rm -rf public/#{assets_prefix}"
  #   end
  # end


  task :export do
    on roles(:app) do
      execute [
        "cd #{release_path} &&",
        'export rvmsudo_secure_path=0 && ',
        "#{fetch(:rvm_path)}/bin/rvm #{fetch(:rvm_ruby_version)} do",
        'rvmsudo',
        'RAILS_ENV=staging bundle exec foreman export --app dradio --user deploy -l /var/log -f ./Procfile upstart /etc/init -c worker=1 -e environments/staging.env'
      ].join(' ')
    end
  end

  # after :finishing, :cleanup
  after :publishing, :export
  after :publishing, :start

 # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
end