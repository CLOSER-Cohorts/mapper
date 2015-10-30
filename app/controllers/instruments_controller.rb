class InstrumentsController < ApplicationController
  before_action :authenticate_user!, except: [
    :mapping,
    :dv,
    :question_topics,
    :variable_topics,
    :mapper
  ]
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
    if params.has_key?(:study) and params[:study].length > 1
      if params[:study] == "CLS"
        studies = ["BCS","MCS","NCDS"]
      elsif params[:study] == "SOTON"
        studies = ["HCS","SWS"]
      else
        studies = params[:study]
      end
      @instruments = policy_scope(Instrument.where(study: studies))
    else
      @instruments = policy_scope(Instrument)
    end
    render layout: "index"
  end

  # GET /instruments/1
  # GET /instruments/1.json
  def show
    authorize @instrument
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
    authorize @instrument
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

  #PATCH /instruments/batch
  def batch
    authorize Instrument
    logger.debug params
    if params.has_key?(:files)
      if params['files'].any? {|file| file.original_filename == 'control.txt'}
         files = {}
        params['files'].each do |file|
          files[file.original_filename] = file.read
        end
        files['control.txt'].each_line do |line|
          if line[0,1] != "#"
            pieces = line.split("\t")
            if pieces.length > 6
              instrument = Instrument.find_by_prefix pieces[0]
              if instrument.nil?
                instrument = Instrument.create({prefix: pieces[0], port: pieces[1], study: pieces[2]})
              end
              #mapper.txt
              if pieces[3] != "0" || pieces[3].length > 0
                if files.has_key? pieces[3]
                  mapper = files[pieces[3]]
                  read_mapper_txt(instrument, mapper)
                end
              end
              #variables.txt
              if pieces[4] != "0" || pieces[4].length > 0
                if files.has_key? pieces[4]
                  variables = files[pieces[4]]
                  read_variables_txt(instrument, variables)
                end
              end
              #mapping.txt
              if pieces[5] != "0" || pieces[5].length > 0
                if files.has_key? pieces[5]
                  mapping = files[pieces[5]]
                  read_mapping_txt(instrument, mapping)
                end
              end
              #dv.txt
              if pieces[6] != "0" || pieces[6].length > 0
                if files.has_key? pieces[6]
                  dv = files[pieces[6]]
                  read_dv_txt(instrument, dv)
                end
              end
            end
          end
        end
        redirect_to instruments_url, notice: 'Instruments successfully created.'
      else
        render :batch, alert: 'No control.txt file included.'
      end 
    else
      render :batch
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
    read_mapper_txt(@instrument, mapper)
    respond_to do |format|
      format.html { redirect_to @instrument, notice: 'mapper.txt imported successfully.' }
    end
  end

  def import_variables
    var_io = params[:instrument][:variables]
    read_variables_txt(@instrument, var_io.read)
    respond_to do |format|
      format.html { redirect_to @instrument, notice: 'Variables imported successfully.' }
    end
  end

  def import_map
    map_io = params[:instrument][:map]
    read_mapping_txt(@instrument,map_io.read)
    respond_to do |format|
      format.html { redirect_to @instrument, notice: 'mapping.txt imported successfully.' }
    end
  end

  def import_dv
    dv_io = params[:instrument][:dv]
    total_skipped, skipped_lines, pieces = read_dv_txt(@instrument, dv_io.read)
    respond_to do |format|
      format.html { 
        redirect_to @instrument, 
        notice: 'dv.txt imported successfully. ' + total_skipped.to_s + ' lines skipped.',
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
  
  def mapper 
    @instrument = Instrument.find(params[:instrument_id])
    respond_to do |format|
      format.text { render 'mapper.txt.erb', layout: false, content_type: 'text/plain' }
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
      params.require(:instrument).permit(:prefix, :port, :study)
    end
    
    def read_mapper_txt (instrument, mapper)
      mapper.each_line do |line|
		  data = line.split("|")
		  if data[1] == "Sequence"
			parent_id = nil
			if data[3] != "none"
			  parent = Sequence.find_by_URN(data[3])
			  if parent.nil?
				#throw error
			  end
			  parent_id = parent.id
			end
			sequence = instrument.sequences.find_by_URN data[0]
			if sequence.nil?
			  instrument.sequences.create(name: data[4], parent_id: parent_id, URN: data[0])
			end
		  else
			parent = Sequence.find_by_URN(data[3])
			if parent.nil?
			  #throw error
			end
			parent_id = parent.id
			if data[2] == '-'
			  instrument.questions.create(qc: data[0], literal: data[4], parent_id: parent_id)
			else
			  question = instrument.questions.find_by_qc data[0]
			  if question.nil?
			    grid_limits = data[2].chomp(']').reverse.chomp('[').reverse.split(',')
			    instrument.questions.create(
				  qc: data[0], 
				  literal: data[4], 
				  parent_id: parent_id, 
				  max_x: grid_limits[1].to_i - 1, 
				  max_y: grid_limits[0].to_i - 1
			    )
			  end
			end
		  end
		end
    end
    
    def read_variables_txt (instrument, var_data)
      default = 'Normal'
      var_data.force_encoding('UTF-8')
      var_data.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '?')
      var_data = var_data.gsub /\r\n?/, "\n"
      var_data = var_data.gsub('“','"').gsub('”', '"').gsub("‘", "'").gsub("’","'")
      first_line = var_data.lines.first
      logger.debug first_line.scan(/[^\w\d_ \n\r]+/)
      if punc = first_line.scan(/[^\w\d_ \n\r]+/)
        quote_cladding = ''

        if (punc[0] == '"') || (punc[0] == "'")
          if punc[0] == '"'
            quote_cladding = '"'
          else
            quote_cladding = "'"
          end
          splitter = punc[1]
        else
          splitter = punc[0]
        end
        first_line = first_line.chomp(quote_cladding).reverse.chomp(quote_cladding).reverse
        columns = first_line.split(splitter).length
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
        instrument.variables.create(:name => data_name, :label => data_label, :var_type => data_var_type)
      end
    end
    
    def read_mapping_txt (instrument, map)
      map.each_line do |line|
        data = line.split("\t")
        if not data[0] == '0'
          q_ref = data[0].chomp.strip.split('$')
          question = instrument.questions.find_by_qc(q_ref.first)
          if not question.nil?
            variable = instrument.variables.find_by_name(data[1].chomp.strip)
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
    end
    
    def read_dv_txt (instrument, dv)
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
          question = instrument.questions.find_by_qc(data[1].chomp.strip)
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

        variable = instrument.variables.find_by_name(data[0].chomp.strip)
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
      return total_skipped, skipped_lines, pieces   
    end
end
