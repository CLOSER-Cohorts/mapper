class InstrumentsController < ApplicationController
  before_action :set_instrument, only: [:show, :edit, :update, :destroy, :questions, :import_qlist, :import_variables]

  # GET /instruments
  # GET /instruments.json
  def index
    @instruments = Instrument.all
    render layout: "index"
  end

  # GET /instruments/1
  # GET /instruments/1.json
  def show
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

  def import_variables
    default = 'Normal'
    var_io = params[:instrument][:qlist]
    var_data = var_io.read
    var_data.force_encoding('UTF-8')
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
