# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.where(:name => 'admin').first_or_create
Role.where(:name => 'normal').first_or_create
Role.where(:name => 'siteadmin').first_or_create
Role.where(:name => 'account').first_or_create

Genre.where(:name => 'Chant').first_or_create
Genre.where(:name => 'Epos').first_or_create
Genre.where(:name => 'Folketone').first_or_create
Genre.where(:name => 'Hymne').first_or_create
Genre.where(:name => 'Irsk folketone').first_or_create
Genre.where(:name => 'Jul').first_or_create
Genre.where(:name => 'Kantate').first_or_create
Genre.where(:name => 'Koral').first_or_create
Genre.where(:name => 'Liturgi').first_or_create
Genre.where(:name => 'Madrigal').first_or_create
Genre.where(:name => 'Mag & Nunc').first_or_create
Genre.where(:name => 'Motett').first_or_create
Genre.where(:name => 'Nasjonalsang').first_or_create
Genre.where(:name => 'Oratorium').first_or_create
Genre.where(:name => 'Pop').first_or_create
Genre.where(:name => 'Preces & Responses').first_or_create
Genre.where(:name => 'Salme').first_or_create
Genre.where(:name => 'Spiritual').first_or_create
Genre.where(:name => 'Te Deum').first_or_create
Genre.where(:name => 'Verdslig').first_or_create
Genre.where(:name => 'Vise').first_or_create
Genre.where(:name => 'Kirkelig').first_or_create
Genre.where(:name => 'Anthem').first_or_create
Genre.where(:name => 'Samtid').first_or_create
