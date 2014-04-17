#!/usr/bin/env ruby

require 'pg'

old = PG.connect( dbname: 'notearkiv2-dev' )
new = PG.connect( dbname: 'notearkiv4_development' )

def transfer_name_table(name, old, new)
  data = {}

  old.exec("SELECT id, name FROM #{name}") do |result|
    result.each do |row|
      data[row['id']] = row['name']
    end
  end

  new.exec("TRUNCATE #{name}")

  new.prepare("create_#{name}", "insert into #{name} (id, name, created_at, updated_at) values ($1, $2, now(), now())")

  data.each do |id, nme|
    new.exec_prepared("create_#{name}", [ id, nme ])
  end
end

transfer_name_table('roles', old, new)
transfer_name_table('periods', old, new)
transfer_name_table('languages', old, new)
transfer_name_table('composers', old, new)
