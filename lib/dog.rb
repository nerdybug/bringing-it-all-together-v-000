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
    dog = self.new(id:array[0], name:array[1], breed:array[2])
  end

  # def self.find_by_name(name)
  #   find_name_sql = <<-SQL
  #   SELECT * FROM dogs
  #   WHERE name = ?;
  #   SQL
  #   DB[:conn].execute(find_name_sql, name).collect do |row|
  #     self.new_from_db(row)
  #   end.first
  # end

  def save
    save_sql = <<-SQL
    INSERT INTO dogs IF NOT EXISTS (name, breed)
    VALUES (?, ?)
    SQL
    DB[:conn].execute(save_sql, self.name, self.breed)
  end

end
