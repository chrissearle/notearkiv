To migrate data

    bundle exec scripts/transfer.rb

To generate reset script

    psql -Atq -f reset.sql -o reset_script.sql database

To run reset script

    psql -f reset_script.sql database

To generate a list of all localized strings

    git grep '\Wt(.*)' | sed -e "s/.*t('//" | sed -e "s/'.*//" | sort -u