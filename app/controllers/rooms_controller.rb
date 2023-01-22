# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!, only: %i[new next apply]
  before_action :set_room, only: %i[show edit update destroy apply cancel next]

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
    @room.user_room_authorities << UserRoomAuthority.new(room: @room, user: current_user, role: :owner)

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
      redirect_to @room, notice: '待機中の人がいません'
      return
    end
    n.destroy!
    RepositionTicketsJob.perform_later(@room)
    redirect_to @room, notice: '次の人を呼び出します'
  end

  def apply
    if current_user.tickets.where(room: @room).present?
      redirect_to @room, notice: '既に参加登録済みです'
      return
    end
    @room.tickets << Ticket.create(room: @room, user: current_user, position: @room.tickets.size + 1)
    redirect_to @room, notice: '参加登録しました'
  end

  def cancel
    unless Ticket.find_by(room: @room, user: current_user).present?
      redirect_to @room, notice: '参加登録していません'
      return
    end
    Ticket.find_by(room: @room, user: current_user).destroy!
    RepositionTicketsJob.perform_later(@room)
    redirect_to @room, notice: '参加登録を取り消しました'
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
