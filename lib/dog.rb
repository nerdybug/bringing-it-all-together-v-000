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

  def self.create(name, breed)
    dog = Dog.new(name:name, breed:breed)
    dog.save
    dog
  end

  def save
    if self.id
      self.update
    else
      save_sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
      SQL
      DB[:conn].execute(save_sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs;")[0][0]
    end
    self
  end

  def update
    update_sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?;"
    DB[:conn].execute(update_sql, self.name, self.breed, self.id)

  end

end
