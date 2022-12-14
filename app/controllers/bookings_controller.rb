class BookingsController < ApplicationController
  before_action :set_booking, only: [:edit, :update, :destroy, :accept, :decline]

  def new
    @booking = Booking.new
  end

  def create

    @booking = Booking.new(booking_params)

    @booking.user = current_user

    @booking.service = Service.find(params[:service_id])

    if @booking.save
      redirect_to profile_path(current_user)
      flash.alert = "Your reservation has been saved"

    else
      redirect_to service_path(@booking.service), status: :unprocessable_entity
      flash.alert = "Erreur"
    end
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      redirect_to booking_path(@booking)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_path, status: :see_other
  end

  def accept
    @booking.status = "Accepted"
    @booking.save
    flash.alert = "Great! You just accepted an offer."
    redirect_to profile_path(current_user)
  end

  def decline
    @booking.status = "Declined"
    @booking.destroy
    flash.alert = "You just declined an offer and it will be deleted from your list."
    redirect_to profile_path(current_user)
  end

private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :service_id, :user_id, :status)
  end
end
