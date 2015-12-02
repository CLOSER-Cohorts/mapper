# The sequence controller handles requests relating to the
# sequence model. It contains all the standard CRUD options
# but also several actions tolink topics.
class SequencesController < ApplicationController
  before_action :set_sequence, only: [:show, :edit, :update, :destroy, :set_topic]
  before_action :set_instrument, only: [:index, :new, :create]

  # GET /sequences
  # GET /sequences.json
  def index
    @sequences = @instrument.sequences.all
  end

  # GET /sequences/1
  # GET /sequences/1.json
  def show
  end

  # GET /sequences/new
  def new
    @sequence = @instrument.sequences.new
  end

  # GET /sequences/1/edit
  def edit
  end

  # POST /sequences
  # POST /sequences.json
  def create
    @sequence = @instrument.sequences.new(sequence_params)

    respond_to do |format|
      if @sequence.save
        format.html { redirect_to instrument_path @instrument, notice: 'Sequence was successfully created.' }
        format.json { render :show, status: :created, location: @sequence }
      else
        format.html { render :new }
        format.json { render json: @sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sequences/1
  # PATCH/PUT /sequences/1.json
  def update
    respond_to do |format|
      if @sequence.update(sequence_params)
        format.html { redirect_to instrument_path @sequence.instrument, notice: 'Sequence was successfully updated.' }
        format.json { render :show, status: :ok, location: @sequence }
      else
        format.html { render :edit }
        format.json { render json: @sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sequences/1
  # DELETE /sequences/1.json
  def destroy
    @sequence.destroy
    respond_to do |format|
      format.html { redirect_to sequences_url, notice: 'Sequence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /sequences/1/set_topic.json
  def set_topic
    if params.has_key?(:topic_id)
      @sequence.topic = Topic.find_by_id(params[:topic_id])
    end
    respond_to do |format|
      format.json { render json: true, status: :accepted }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sequence
      @sequence = Sequence.find(params[:id])
    end

    def set_instrument
      @instrument = Instrument.includes(sequences: :topic).find(params[:instrument_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sequence_params
      params.require(:sequence).permit(:name, :instrument_id, :parent_id)
    end
end
