class AddFindInArrayFunction < ActiveRecord::Migration
  def up
    execute <<-SPROC
create or replace function find_in_array(
  needle anyelement, haystack anyarray) returns integer as $$
declare
  i integer;
begin
  for i in 1..array_upper(haystack, 1) loop
    if haystack[i] = needle then
      return i;
    end if;
  end loop;
  raise exception 'find_in_array: % not found in %', needle, haystack;
end;
$$ language 'plpgsql';
SPROC
  end

  def down
    execute "DROP FUNCTION IF EXISTS stock_hourly_performance(integer)"
  end
end
