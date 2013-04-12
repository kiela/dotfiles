pry ()
{
  if [ -e ./config/environment.rb ]
  then
    bundle exec pry -r ./config/environment "$@"
  else
    bundle exec pry
  fi
}
