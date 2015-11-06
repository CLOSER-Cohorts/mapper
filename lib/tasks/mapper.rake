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

  desc "Outputs list of intrument ids, prefixes and topic-question percentage"
  task tq: :environment do
    output = []
    Instrument.find_each do |i|
      output.append({prefix: i.prefix, id: i.id, count: 0, total: i.questions.count})
      i.questions.find_each do |q|
        begin
          if not q.get_topic.nil?
            output.last[:count] += 1
          end
        rescue
        end
      end
      print output.last[:id].to_s + "\t" + output.last[:prefix] + "\t" + (output.last[:count].to_f/output.last[:total].to_f).to_s + "\n"
    end
    output.each do |o|
      print o[:id].to_s + "\t" + o[:prefix] + "\t" + (o[:count].to_f/o[:total].to_f).to_s + "\n"
    end
  end

  desc "Outputs list of intrument ids, prefixes and topic-variable percentage"
  task tv: :environment do
    output = []
    Instrument.find_each do |i|
      output.append({prefix: i.prefix, id: i.id, count: 0, total: i.variables.count})
      i.variables.find_each do |v|
        begin
          if not v.get_topic.nil?
            output.last[:count] += 1
          end
        rescue
        end
      end
      print output.last[:id].to_s + "\t" + output.last[:prefix] + "\t" + (output.last[:count].to_f/output.last[:total].to_f).to_s + "\n"
    end
    output.each do |o|
      print o[:id].to_s + "\t" + o[:prefix] + "\t" + (o[:count].to_f/o[:total].to_f).to_s + "\n"
    end
  end

  desc "Outputs list of intrument ids, prefixes and variable-question percentage"
  task mapping: :environment do
    output = []
    Instrument.find_each do |i|
      output.append({prefix: i.prefix, id: i.id, qv: 0, vv: 0, mapped_q: 0, mapped_v: 0, total_v: i.variables.count, total_q: i.questions.count})
      i.variables.find_each do |v|
        begin
          output.last[:qv] += v.questions.length
          output.last[:vv] += v.src_variables.length
          if (not v.get_relations.nil?) && v.get_relations.count > 0)
            output.last[:mapped_v] += 1
          end
        rescue
        end
      end
      i.questions.find_each do |q|
        begin
          if (not q.get_relations.nil?) && q.get_relations.count > 0)
            output.last[:mapped_q] += 1
          end
        rescue
        end
      end
      print output.last[:id].to_s + "\t" + output.last[:prefix] + "\t" + output.last[:qv].to_s + "\t" + output.last[:vv].to_s + "\t" + output.last[:mapped_q].to_s + "\t" + output.last[:mapped_v].to_s + "\t" + output.last[:total_v].to_s + "\t" + output.last[:total_q].to_s + "\n"
    end
    print "id\tprefix\tqv\tvv\tmapped_q\tmapped_v\ttotal_v\ttotal_q\n"
    output.each do |o|
      print o[:id].to_s + "\t" + o[:prefix] + "\t" + o[:qv].to_s + "\t" + o[:vv].to_s + "\t" + o[:mapped_q].to_s + "\t" + o[:mapped_v].to_s + "\t" + o[:total_v].to_s + "\t" + o[:total_q].to_s + "\n"
    end
  end

  desc "This task exports the entire app for use or import. It includes a control file."
  task export: :environment do
  end

  desc "The task uses a control file to import data into the app."
  task import: :environment do
  end

end
