require 'sinatra'

set :bind, "0.0.0.0"
set :port, "4567"

get '/' do
  erb :index
end

post '/take-picture' do
  take_picture()
  redirect '/'
end

$kidpid = fork do
  exec "raspistill -o /tmp/image.jpeg -w 640 -h 480 --signal"
end

trap "EXIT" do
  Process.kill(15, $kidpid)
  Process.waitpid2($kidpid, Process::WNOHANG) rescue nil
end

def take_picture
  pre_hash = `md5sum /tmp/image.jpeg`
  puts "Sending USR1 to #{$kidpid}"
  Process.kill("USR1", $kidpid)
  while `md5sum /tmp/image.jpeg` == pre_hash
    sleep(0.01)
  end
end
