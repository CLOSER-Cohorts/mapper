class Instrument < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :variables, dependent: :destroy
  has_many :sequences, dependent: :destroy
  accepts_nested_attributes_for :questions
  accepts_nested_attributes_for :variables
  accepts_nested_attributes_for :sequences
  
  attr_accessor :topic_nests
  
  after_initialize do |instrument|
    instrument.topic_nests ||= [] # just in case the :topic_nests were passed to .new
  end

  def get_comma_separated_variables
    var_names = []
    variables.each do |variable|
      var_names.push(variable.name)
    end
    return var_names.join(',')
  end

  def get_comma_separated_questions
    qcs = []
    questions.each do |question|
      qcs.push(question.qc)
    end
    return qcs.join(',')
  end

  def get_comma_separated_sequences
    seq_names = []
    sequences.each do |sequence|
      seq_names.push(sequence.name)
    end
    return seq_names.join(',')
  end
  
  def mapping_connections
    count = 0
    variables.each do |v|
      count += v.out_variables.count
    end
    questions.each do |q|
      count += q.variables.count
    end
    return count
  end
  
  def topic_connections
    count = 0
    variables.each do |v|
      if not v.topic.nil?
        count += 1
      end
    end
    questions.each do |q|
      if not q.topic.nil?
        count += 1
      end
    end
    return count
  end
  
  def self.get_mapping( instrument_id )
    r = self.sanitize_sql_array(["SELECT name as variable, COALESCE(qc, '0') as qc, x, y FROM variables LEFT JOIN maps ON variables.id = variable_id LEFT JOIN questions ON mapable_id = questions.id AND mapable_type = 'Question' WHERE variables.instrument_id =? GROUP BY variable, qc, x, y ORDER BY variable", instrument_id])
    self.connection.select_all r
  end

  def self.get_dv( instrument_id )
    r = self.sanitize_sql_array(["SELECT v1.name as variable, v2.name as src FROM variables v1 INNER JOIN maps ON v1.id = variable_id INNER JOIN variables v2 ON v2.id = mapable_id AND mapable_type = 'Variable' WHERE v1.instrument_id =? GROUP BY variable, src ORDER BY variable", instrument_id])
    self.connection.select_all r
  end

  def self.get_min_linking( instrument_id )
    r = self.sanitize_sql_array(["SELECT coalesce(\"URN\", qc, variables.name) as object, topic_id as topic, target_type as type FROM links LEFT JOIN sequences ON target_id = sequences.id AND target_type = 'Sequence' LEFT JOIN questions ON target_id = questions.id AND target_type = 'Question' LEFT JOIN variables ON target_id = variables.id AND target_type = 'Variable' WHERE sequences.instrument_id = ? OR questions.instrument_id = ? OR variables.instrument_id = ? ORDER BY \"URN\", qc, variables.name", instrument_id, instrument_id, instrument_id])
    self.connection.select_all r
  end
end
