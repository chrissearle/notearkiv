To migrate data

    bundle exec scripts/transfer.rb

To generate reset script

    psql -Atq -f reset.sql -o reset_script.sql database

To run reset script

    psql -f reset_script.sql database

To generate a list of all localized strings

    git grep '\Wt(.*)' | sed -e "s/.*t('//" | sed -e "s/'.*//" | sort -u

Index deletion

    client = Elasticsearch::Client.new host: 'localhost:9200'
    client.indices.delete index: 'notearkiv'

Index population

    Note.preloaded.import
    Evensong.preloaded.import
