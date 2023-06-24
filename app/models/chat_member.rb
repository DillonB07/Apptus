class ChatMember < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  enum role: %i[basic administrator]

  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :user_id, presence: true, uniqueness: { scope: :chat_id }

  after_create do
    chat.messages.create(user_id: User.find_by(role: :system).id, content: "#{user.title_name} was added")
  end

  before_destroy do
    unless destroyed_by_association
      chat.messages.create(user_id: User.find_by(role: :system).id, content: "#{user.title_name} was removed")
    end
  end

  def role_id
    ChatMember.roles[role]
  end
end
