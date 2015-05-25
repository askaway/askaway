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
#  embedded_topic_id   :integer
#  comments_count :integer          default(0), not null
#  user_id        :integer          not null
#

class Question < ActiveRecord::Base
  BODY_MAX_LENGTH = 140

  include FriendlyId
  def self.slug_candidate; :body; end
  friendly_id slug_candidate, :use => [:slugged, :history]
  include FriendlyIdHelper

  include ReviewFilter

  include PgSearch
  pg_search_scope :search,
    against: [:body],
    associated_against: { answers: [:body] }

  has_many :answers, inverse_of: :question, dependent: :destroy
  has_many :comments, inverse_of: :question, dependent: :destroy
  has_many :votes, inverse_of: :question, dependent: :destroy
  belongs_to :topic, inverse_of: :questions
  belongs_to :embedded_topic, inverse_of: :questions
  belongs_to :user, inverse_of: :questions

  validates_presence_of :body, :user
  validates_length_of :body, maximum: BODY_MAX_LENGTH
  validates_numericality_of :votes_count, greater_than_or_equal_to: 0

  scope :answered, -> { joins(:answers).order('questions.answers_count DESC') }
  scope :unanswered, -> { where('questions.answers_count < 4') }
  scope :trending, -> { order('ranking(questions.created_at, questions.votes_count, questions.answers_count) DESC') }
  scope :not_anonymous, -> { where('is_anonymous IS NOT TRUE') }

  class << self
    def has_answer_from_party?(question, party)
      question.answers.joins(:rep).where("reps.party_id = ?", party.id).exists?
    end
  end

  def self.common_includes
    includes( user:[:identities, :placeholder, :selected_avatar_identity],
              answers:[
                rep:[
                  ### Why :identities and :placeholder? they're not used on the landing page -ML
                  # party: [:placeholder],
                  # user:  [:identities, :placeholder]
                  party: [:selected_avatar_identity],
                  user:  [:selected_avatar_identity]
                  # party: [:placeholder, :selected_avatar_identity],
                  # user:  [:identities, :placeholder, :selected_avatar_identity]
                ]
              ])
  end

  # TODO: replace this with real association
  def reminder_email
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
    record = ActiveRecord::Base.connection.execute("SELECT ranking(questions.created_at, questions.votes_count, questions.answers_count) FROM questions WHERE id = #{id}").first
    if record.nil?
      0
    else
      record["ranking"].to_f
    end
  end

  def accept
    self.created_at = Time.zone.now
    save! # FIXME: this isn't ideal cause save is getting called twice.
  end
end
