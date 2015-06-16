class InstrumentsController < ApplicationController
  before_action :set_instrument, only: [:show, :edit, :update, :destroy, :questions, :import_qlist]

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
    format.html { redirect_to @instrument, notice: 'qlist imported successfully.' }
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
