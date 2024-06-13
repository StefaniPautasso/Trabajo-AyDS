users = [
  { name: 'user1', password: 'password1' },
  { name: 'user2', password: 'password2' },
  { name: 'user3', password: 'password3' },
  { name: 'user4', password: 'password4' },
  { name: 'user5', password: 'password5' }
]

users.each do |user_attributes|
  User.find_or_create_by!(name: user_attributes[:name]) do |user|
    user.password = user_attributes[:password]
  end
end
