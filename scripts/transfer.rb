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

new.exec('TRUNCATE evensongs')

new.prepare('create_evensongs', 'INSERT INTO evensongs (id, title, psalm, composer_id, genre_id, soloists, comment, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7, now(), now())')

old.exec('SELECT id, title, psalm, composer_id, genre_id, soloists, comment FROM evensongs') do |result|
  result.each do |row|
    new.exec_prepared('create_evensongs', [row['id'], row['title'], row['psalm'], row['composer_id'], row['genre_id'], row['soloists'], row['comment']])
  end
end

new.exec('UPDATE genres SET evensongs_count=(SELECT count(*) FROM evensongs WHERE genre_id=genres.id)')
new.exec('UPDATE composers SET evensongs_count=(SELECT count(*) FROM evensongs WHERE composer_id=composers.id)')

new.exec('TRUNCATE notes')

new.prepare('create_notes', 'INSERT INTO notes (id, item, title, originals, copies, instrumental, voice, composer_id, genre_id, period_id, language_id, instrument, soloists, comment, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, now(), now())')

old.exec('SELECT id, item, title, originals, copies, instrumental, voice, composer_id, genre_id, period_id, language_id, instrument, soloists, comment FROM notes') do |result|
  result.each do |row|
    new.exec_prepared('create_notes', [row['id'], row['item'], row['title'], row['originals'], row['copies'], row['instrumental'], row['voice'], row['composer_id'], row['genre_id'], row['period_id'], row['language_id'], row['instrument'], row['soloists'], row['comment']])
  end
end

new.exec('UPDATE genres SET notes_count=(SELECT count(*) FROM notes WHERE genre_id=genres.id)')
new.exec('UPDATE composers SET notes_count=(SELECT count(*) FROM notes WHERE composer_id=composers.id)')
new.exec('UPDATE periods SET notes_count=(SELECT count(*) FROM notes WHERE period_id=periods.id)')
new.exec('UPDATE languages SET notes_count=(SELECT count(*) FROM notes WHERE language_id=languages.id)')
