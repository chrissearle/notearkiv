#!/usr/bin/env ruby

require 'pg'

@conn_old = PG.connect(dbname: 'notearkiv-dev')
@conn_new = PG.connect(dbname: 'notearkiv2-dev')

@conn_new.prepare("add_user", "INSERT INTO users
    (id, username, email, persistence_token, crypted_password, password_salt, login_count, failed_login_count,
     last_request_at, current_login_at, last_login_at, current_login_ip, last_login_ip, onetime, name,
     created_at, updated_at)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, now(), now())")

@conn_new.prepare("add_user_role_assignment", "INSERT INTO user_role_assignments (id, user_id, role_id, created_at, updated_at)
     VALUES ($1, $2, $3, now(), now())")

@conn_new.exec("TRUNCATE TABLE users")
@conn_new.exec("TRUNCATE TABLE user_role_assignments")

def run_id_name(table)
  puts "Running for #{table}"

  @conn_new.prepare("add_#{table}", "INSERT INTO #{table} (id, name, created_at, updated_at) VALUES ($1, $2, now(), now())")

  @conn_new.exec("TRUNCATE TABLE #{table}")
  @conn_old.exec("SELECT id, name FROM #{table}") do |result|
    result.each do |row|
      @conn_new.exec_prepared("add_#{table}", [{:value => row.values[0], :format => 0}, {:value => row.values[1], :format => 0}])
    end
  end
end

run_id_name("composers")
run_id_name("genres")
run_id_name("languages")
run_id_name("periods")
run_id_name("roles")

puts "Running for users"

@conn_new.exec("TRUNCATE TABLE users")
@conn_old.exec("SELECT id, username, email, persistence_token, crypted_password, password_salt, login_count,
     failed_login_count, last_request_at, current_login_at, last_login_at, current_login_ip, last_login_ip, onetime,
     name FROM users") do |result|
  result.each do |row|
    @conn_new.exec_prepared("add_user", [{:value => row.values[0], :format => 0},
                                         {:value => row.values[1], :format => 0},
                                         {:value => row.values[2], :format => 0},
                                         {:value => row.values[3], :format => 0},
                                         {:value => row.values[4], :format => 0},
                                         {:value => row.values[5], :format => 0},
                                         {:value => row.values[6], :format => 0},
                                         {:value => row.values[7], :format => 0},
                                         {:value => row.values[8], :format => 0},
                                         {:value => row.values[9], :format => 0},
                                         {:value => row.values[10], :format => 0},
                                         {:value => row.values[11], :format => 0},
                                         {:value => row.values[12], :format => 0},
                                         {:value => row.values[13], :format => 0},
                                         {:value => row.values[14], :format => 0}])
  end
end

puts "Running for user_role_assignments"

@conn_new.exec("TRUNCATE TABLE user_role_assignments")
@conn_old.exec("SELECT id, user_id, role_id FROM user_role_assignments") do |result|
  result.each do |row|
    @conn_new.exec_prepared("add_user_role_assignment", [{:value => row.values[0], :format => 0},
                                                         {:value => row.values[1], :format => 0},
                                                         {:value => row.values[2], :format => 0}])
  end
end