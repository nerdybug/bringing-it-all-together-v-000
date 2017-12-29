require_relative "../config/environment.rb"

class Dog
  attr_accessor :id, :name, :breed

  def initialize(id:nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    create_sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    );
    SQL
    DB[:conn].execute(create_sql)
  end

  def self.drop_table
    drop_sql = <<-SQL
    DROP TABLE dogs;
    SQL
    DB[:conn].execute(drop_sql)
  end

  def self.new_from_db(array)
    dog = self.new(array[0], array[1], array[2])
  end

end
