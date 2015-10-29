namespace :mapper do
  desc "This task prints to the terminal stats about each instrument."
  task stats: :environment do
    app = ActionDispatch::Integration::Session.new(Rails.application)
    Instrument.find_each do |instrument|
      mapping = Instrument.get_mapping(instrument.id)
      dv = Instrument.get_dv(instrument.id)
      begin
        topic_q = []
        instrument.questions.each do |question|
          topic_q.push({'object' => question.qc, 'topic' => (question.get_topic.nil? ? 0 : question.get_topic.colectica_code)})
        end
        topic_v = []
        instrument.variables.each do |variable|
          topic_v.push({'object' => variable.name, 'topic' => (variable.get_topic.nil? ? 0 : variable.get_topic.colectica_code)})
        end
        print instrument.prefix + " " * (30-instrument.prefix.length) + "\tm:" + mapping.count.to_s + "\tdv:" + dv.count.to_s  + "\ttq:" + topic_q.count.to_s + "\ttv:" + topic_v.count.to_s + "\n"
      rescue Exception
      end
    end
  end

  desc "This task exports the entire app for use or import. It includes a control file."
  task export: :environment do
  end

  desc "The task uses a control file to import data into the app."
  task import: :environment do
  end

end
