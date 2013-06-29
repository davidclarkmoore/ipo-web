def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def add_apt_repo name
  run "#{sudo} add-apt-repository ppa:#{name}", :pty => true do |ch, stream, data|
    if data =~ /Press.\[ENTER\].to.continue/
      # prompt, and then send the response to the remote process
      ch.send_data(Capistrano::CLI.password_prompt("Press enter to continue:") + "\n")
    else
      # use the default handler for all other text
      Capistrano::Configuration.default_io_proc.call(ch,stream,data)
    end
  end
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install software-properties-common"
    run "#{sudo} apt-get -y install python-software-properties"
  end
end
