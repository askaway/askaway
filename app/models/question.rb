# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  body           :text
#  is_anonymous   :boolean
#  created_at     :datetime
#  updated_at     :datetime
#  votes_count    :integer          default(0)
#  answers_count  :integer          default(0)
#  topic_id       :integer
#  comments_count :integer          default(0), not null
#  user_id        :integer          not null
#

class Question < ActiveRecord::Base
  has_many :answers, inverse_of: :question
  has_many :comments, inverse_of: :question
  belongs_to :topic
  belongs_to :user

  validates_presence_of :body, :topic, :user
  validates_length_of :body, maximum: 140
  validates_numericality_of :votes_count, greater_than_or_equal_to: 0

  before_validation :init_topic

  scope :answered, -> { joins(:answers).order('questions.answers_count DESC') }
  scope :unanswered, -> { where('questions.answers_count < 4') }
  scope :trending, -> { order("ranking(questions.created_at, questions.votes_count) DESC") }
  scope :not_anonymous, -> { where('is_anonymous IS NOT TRUE') }

  class << self
    def has_answer_from_party?(question, party)
      question.answers.joins(:rep).where("reps.party_id = ?", party.id).exists?
    end
  end

  def name
    body
  end

  def user_name
    if is_anonymous?
      'Anonymous'
    else
      user.name
    end
  end

  def answered?
    answers.any?
  end

  def hotness
    record = ActiveRecord::Base.connection.execute("SELECT ranking(questions.created_at, questions.votes_count) FROM questions WHERE id = #{id}").first
    if record.nil?
      0
    else
      record["ranking"].to_f
    end
  end

  private

  def init_topic
    self.topic ||= Topic.find_or_create_by(name: 'General')
  end
end
