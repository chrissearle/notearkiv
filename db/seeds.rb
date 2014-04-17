# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

r_admin = Role.where(:name => 'admin').first_or_create
r_normal = Role.where(:name => 'admin').first_or_create
r_siteadmin = Role.where(:name => 'siteadmin').first_or_create
r_account = Role.where(:name => 'account').first_or_create

['Chant', 'Epos', 'Folketone', 'Hymne', 'Irsk folketone', 'Jul', 'Kantate', 'Koral', 'Liturgi', 'Madrigal', 'Mag & Nunc',
 'Motett', 'Nasjonalsang', 'Oratorium', 'Pop', 'Preces & Responses', 'Salme', 'Spiritual', 'Te Deum', 'Verdslig', 'Vise',
 'Kirkelig', 'Anthem', 'Samtid'].each do |genre|
  Genre.where(:name => genre).first_or_create
end

%w(Dansk Engelsk Finsk Fransk Gresk Islandsk Italiensk Latin Norsk Svensk Tysk Russisk).each do |lang|
  Language.where(:name => lang).first_or_create
end

%w(Barokk Klassisisme Nasjonalromantikk Nyere Renessanse Romantikken Trad.).each do |period|
  Period.where(:name => period).first_or_create
end

[
    {
        :username => 'eszter',
        :name => 'Ezster Horvati',
        :email => 'ehorvati@gmail.com',
    },
    {
        :username => 'marius',
        :name => 'Marius Skjølaas',
        :email => 'skjolaas@gmail.com',
    },
    {
        :username => 'admin',
        :name => 'Admin',
        :email => 'arkivkomite@ochs.no',
    },
    {
        :username => 'ochs',
        :name => 'OCHS Member',
        :email => 'ochs@ochs.no',
    },
    {
        :username => 'chris',
        :name => 'Chris Searle',
        :email => 'chris@chrissearle.org',
    },
].each do |params|
  user = User.where(:username => params[:username])

  unless user.exists?
    user = User.new({
                        username: params[:username],
                        name: params[:name],
                        email: params[:email],
                        password: 'change_me',
                        password_confirmation: 'change_me'
                    })

    user.save

    puts "ALERT - change password for #{params[:username]}"
  end
end

user = User.where(:username => 'chris').first
user.roles = [r_siteadmin, r_account, r_admin]

user = User.where(:username => 'eszter').first
user.roles = [r_siteadmin, r_account, r_admin]

user = User.where(:username => 'marius').first
user.roles = [r_account, r_admin]

user = User.where(:username => 'admin').first
user.roles = [r_account, r_admin]

user = User.where(:username => 'ochs').first
user.roles = [r_normal]
