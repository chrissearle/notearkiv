# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w(admin normal siteadmin account).each do |role|
  Role.where(:name => role).first_or_create
end

['Chant', 'Epos', 'Folketone', 'Hymne', 'Irsk folketone', 'Jul', 'Kantate', 'Koral', 'Liturgi', 'Madrigal', 'Mag & Nunc',
 'Motett', 'Nasjonalsang', 'Oratorium', 'Pop', 'Preces & Responses', 'Salme', 'Spiritual', 'Te Deum', 'Verdslig', 'Vise',
 'Kirkelig', 'Anthem', 'Samtid'].each do |genre|
  Genre.where(:name => genre).first_or_create
end

%w(Dansk Engelsk Finsk Fransk Gresk Islandsk Italiensk Latin Norsk Svensk Tysk Russisk).each do |lang|
  Language.where(:name => lang).first_or_create
end