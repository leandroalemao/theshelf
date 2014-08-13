# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Criando o usuario inicial. Utilizado o Hash Bcrypt da senha "teste"
User.create(email: 'leandro@leandro.com', encrypted_password: '$2a$10$xE14PAZDWbYP4L5x7xgWPuSnSG7TBqDAAoC36bu2ZdItHJgFH90ru', remember_token: 'nada', first_name: 'Leandro', last_name: 'Alemao', role: 'admin')
