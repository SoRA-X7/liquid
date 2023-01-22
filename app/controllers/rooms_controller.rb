# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!, only: %i[new next apply]
  before_action :set_room, only: %i[show edit update destroy apply next]

  # GET /rooms
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  def show
    @position = if user_signed_in?
                  @room.tickets.find_by(user: current_user)&.position || -1
                else
                  -1
                end
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit; end

  # POST /rooms
  def create
    @room = Room.new(room_params)

    if @room.save
      redirect_to @room, notice: 'Room was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rooms/1
  def update
    if @room.update(room_params)
      redirect_to @room, notice: 'Room was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/1
  def destroy
    @room.destroy
    redirect_to rooms_url, notice: 'Room was successfully destroyed.'
  end

  def next
    unless @room.moderator?(current_user)
      redirect_to @room, notice: 'Forbidden'
      return
    end
    n = @room.tickets.first
    unless n.present?
      redirect_to @room, notice: 'No tickets'
      return
    end
    n.destroy!
    redirect_to @room, notice: 'Success'
  end

  def apply
    if current_user.tickets.where(room: @room).present?
      redirect_to @room, notice: 'Already applied'
      return
    end
    @room.tickets << Ticket.create(room: @room, user: current_user, position: @room.tickets.size + 1)
    redirect_to @room, notice: 'Successfully applied'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def room_params
    params.require(:room).permit(:name, :description, :available)
  end
end
