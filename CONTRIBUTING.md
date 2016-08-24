Do the following before creating a merge request:

1. stop the rails server
2. rake db:drop db:create db:migrate db:seed
3. rake test
