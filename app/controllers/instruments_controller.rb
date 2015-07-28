class InstrumentsController < ApplicationController
  before_action :set_instrument, only: [
    :show, 
    :edit, 
    :update, 
    :destroy, 
    :questions, 
    :import_qlist, 
    :import_from_caddies, 
    :import_variables, 
    :import_map, 
    :import_dv,
    :import_linking
  ]

  add_flash_types :more_notice

  # GET /instruments
  # GET /instruments.json
  def index
    @instruments = Instrument.all
    render layout: "index"
  end

  # GET /instruments/1
  # GET /instruments/1.json
  def show
    @topics = Topic.get_in_level_order
    render layout: "show"
  end

  # GET /instruments/new
  def new
    @instrument = Instrument.new
  end

  # GET /instruments/1/edit
  def edit
  end

  # POST /instruments
  # POST /instruments.json
  def create
    @instrument = Instrument.new(instrument_params)

    respond_to do |format|
      if @instrument.save
        format.html { redirect_to @instrument, notice: 'Instrument was successfully created.' }
        format.json { render :show, status: :created, location: @instrument }
      else
        format.html { render :new }
        format.json { render json: @instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instruments/1
  # PATCH/PUT /instruments/1.json
  def update
    respond_to do |format|
      if @instrument.update(instrument_params)
        format.html { redirect_to @instrument, notice: 'Instrument was successfully updated.' }
        format.json { render :show, status: :ok, location: @instrument }
      else
        format.html { render :edit }
        format.json { render json: @instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instruments/1
  # DELETE /instruments/1.json
  def destroy
    @instrument.destroy
    respond_to do |format|
      format.html { redirect_to instruments_url, notice: 'Instrument was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_question
    respond_to do |format|
      if @instrument.questions.create(question_params)
        format.html { redirect_to @instrument, notice: 'Question was successfully added.' }
        format.json { render :show, status: :ok, location: @instrument }
      else
         format.html { render "questions/new" }
         format.json { render json: @instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  def import_qlist
    qlist_io = params[:instrument][:qlist]
    qlist = qlist_io.read
    qlist.each_line do |line|
      data = line.split("|")
      @instrument.questions.create(:qc => data[1], :literal => data[3])
    end
    respond_to do |format|
      format.html { redirect_to @instrument, notice: 'qlist imported successfully.' }
    end
  end

  def import_from_caddies
    mapper_io = params[:instrument][:mapper]
    mapper = mapper_io.read
    mapper.each_line do |line|
      data = line.split("|")
      if data[1] == "Sequence"
        parent_id = nil
        if data[2] != "none"
          parent = Sequence.find_by_URN(data[2])
          if parent.nil?
            #throw error
          end
          parent_id = parent.id
        end
        @instrument.sequences.create(name: data[3], parent_id: parent_id, URN: data[0])
      else
        parent = Sequence.find_by_URN(data[2])
        if parent.nil?
          #throw error
        end
        parent_id = parent.id
        @instrument.questions.create(qc: data[0], literal: data[3], parent_id: parent_id)
      end
    end
    respond_to do |format|
      format.html { redirect_to @instrument, notice: 'mapper.txt imported successfully.' }
    end
  end

  def import_variables
    default = 'Normal'
    var_io = params[:instrument][:variables]
    var_data = var_io.read
    var_data.force_encoding('UTF-8')
    var_data = var_data.gsub /\r\n?/, "\n"
    var_data = var_data.gsub('“','"').gsub('”', '"').gsub("‘", "'").gsub("’","'")
    first_line = var_data.lines.first
    if punc = first_line.scan(/[^\w\d_ \n\r]+/)
      if punc.length == 2 or punc.length == 4
        columns = 3
      elsif punc.length == 1 or punc.length == 3
        columns = 2
      else
        #throw error
      end
      if punc.length == 3 or punc.length == 4
        splitter = punc[1].gsub('"','').gsub("'","")
      else
        splitter = punc[0]
      end
    else
      #throw an error
    end

    var_data.each_line do |line|
      data = line.strip.split(splitter)
      data_name = data[0].chomp('"').chomp("'").reverse.chomp('"').chomp("'").reverse
      data_label = data[1].chomp('"').chomp("'").reverse.chomp('"').chomp("'").reverse
      if columns == 3
        data_var_type = data[2].chomp('"').chomp("'").reverse.chomp('"').chomp("'").reverse
      else
        data_var_type = default
      end
      @instrument.variables.create(:name => data_name, :label => data_label, :var_type => data_var_type)
    end
    respond_to do |format|
      format.html { redirect_to @instrument, notice: 'Variables imported successfully.' }
    end
  end

  def import_map
    map_io = params[:instrument][:map]
    map = map_io.read
    map.each_line do |line|
      data = line.split("\t")
      if not data[0] == '0'
        q_ref = data[0].chomp.strip.split('$')
        question = @instrument.questions.find_by_qc(q_ref.first)
        if not question.nil?
          variable = @instrument.variables.find_by_name(data[1].chomp.strip)
          if not variable.nil?
            if q_ref.length > 1
              if q_ref.second.count(';') == 1
                g_ref = q_ref.second.split(';')
                question.map.create(:variable => variable, :x => g_ref.first.to_i, :y => g_ref.second.to_i)
              else
                question.variables << variable
              end
            else
              question.variables << variable
            end
          end
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to @instrument, notice: 'mapping.txt imported successfully.' }
    end
  end

  def import_dv
    dv_io = params[:instrument][:dv]
    dv = dv_io.read
    skipped = {
      target_question_not_found: [], 
      target_variable_not_found: [], 
      dv_not_found: [], 
      too_many_target_variables: [], 
      wrong_variable_type: [],
      already_mapped: []
    }
    line_counter = 0
    dv.each_line do |line|
      line_counter += 1
      data = line.split("\t")
      
      if data[1][0...3] == 'qc_'
        question = @instrument.questions.find_by_qc(data[1].chomp.strip)
         if question.nil?
           skipped[:target_question_not_found].push({line_number: line_counter, line: line})
           next
         else
           if question.variables.length != 1
             skipped[:too_many_target_variables].push({line_number: line_counter, line: line})
             next
           end
         end 

        src = question.variables.first 
      else
        src = Variable.find_by_name(data[1].chomp.strip)
        if src.nil?
          skipped[:target_variable_not_found].push({line_number: line_counter, line: line})
          next
        end
      end

      variable = @instrument.variables.find_by_name(data[0].chomp.strip)
      if variable.nil?
        skipped[:dv_not_found].push({line_number: line_counter, line: line})
        next
      else
        if variable.questions.length > 0
          skipped[:wrong_variable_type].push({line_number: line_counter, line: line})
          next
        end
      end

      already_mapped = variable.src_variables.find_by_id(src.id)
      if not already_mapped.nil?
        skipped[:already_mapped].push({line_number: line_counter, line: line})
        next
      end

      if variable.var_type != 'Derived'
        variable.var_type = 'Derived'
        variable.save
      end

      variable.src_variables << src
    end
   
    total_skipped = 0
    pieces = []
    skipped_lines = []
    skipped.each do |key, skipped_type|
      total_skipped += skipped_type.count
      pieces << skipped_type.count.to_s + " " + key.to_s.gsub('_',' ').capitalize
      if key != :already_mapped
        skipped_type.each do |skipped_obj|
          skipped_lines << "Skipped line " + skipped_obj[:line_number].to_s + ": " + skipped_obj[:line]
        end
      end
    end    

    respond_to do |format|
      format.html { 
        redirect_to @instrument, 
        notice: 'mapping.txt imported successfully. ' + total_skipped.to_s + ' lines skipped.',
        more_notice: pieces.join('<br/>') + '<br/>' + skipped_lines.join('<br/>')
      }
    end
  end

  def import_linking
    linking_io = params[:instrument][:linking]
    linking = linking_io.read
    no_of_cols = linking.lines.first.split("\t").count
    first_id = linking.lines.first.split("\t")[0]
    s_count = @instrument.sequences.where(URN: first_id).count
    q_count = @instrument.questions.where(qc: first_id).count
    v_count = @instrument.variables.where(name: first_id).count
    if s_count + q_count + v_count == 1
      if s_count == 1
        targets = @instrument.sequences
        target_param = :URN
        topic_param = :id
      elsif q_count == 1
        targets = @instrument.questions
        target_param = :qc
        topic_param = :colectica_code
      else
        targets = @instrument.variables
        target_param = :name
        topic_param = :colectica_code
      end
      linking.each_line do |line|
        data = line.split("\t")
        target = targets.find_by(target_param => data.first)
        topic = Topic.find_by(topic_param => data.last)
        target.topic = topic
        target.save!
      end
      respond_to do |format|
        format.html { redirect_to @instrument, notice: 'Topic linking imported successfully.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to @instrument, alert: 'Topic linking failed to import.' }
      end
    end
    
  end

  def mapping
    @map = Instrument.get_mapping(params[:instrument_id])   
    respond_to do |format|
      format.text { render 'mapping.txt.erb', layout: false, content_type: 'text/plain' }
      format.json  {}
    end  
  end

  def dv
    @map = Instrument.get_dv(params[:instrument_id])
    respond_to do |format|
      format.text { render 'dv.txt.erb', layout: false, content_type: 'text/plain' }
      format.json  {}
    end
  end

  def question_topics
    @instrument = Instrument.find(params[:instrument_id])
    @linking = []
    @instrument.questions.each do |question|
      @linking.push({'object' => question.qc, 'topic' => (question.get_topic.nil? ? 0 : question.get_topic.colectica_code)})
    end
    respond_to do |format|
      format.text { render 'linking.txt.erb', layout: false, content_type: 'text/plain' }
      format.json  {}
    end
  end

  def variable_topics
    @instrument = Instrument.find(params[:instrument_id])
    @linking = []
    @instrument.variables.each do |variable|
      @linking.push({'object' => variable.name, 'topic' => (variable.get_topic.nil? ? 0 : variable.get_topic.colectica_code)})
    end
    respond_to do |format|
      format.text { render 'linking.txt.erb', layout: false, content_type: 'text/plain' }
      format.json  {}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instrument
      @instrument = Instrument.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instrument_params
      params.require(:instrument).permit(:prefix, :port)
    end
end
