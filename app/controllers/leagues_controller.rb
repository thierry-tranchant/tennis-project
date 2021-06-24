class LeaguesController < ApplicationController
  def index
    @leagues  = policy_scope(League).order(created_at: :desc)
  end

  def new
    @league = League.new
    authorize @league
  end

  def create
    cleaned_params = league_params
    cleaned_params[:password] = PasswordHasher.call(cleaned_params[:password]) unless cleaned_params[:password].empty?
    @league = League.new(cleaned_params)
    @league.users << current_user
    authorize @league
    if @league.save
      redirect_to leagues_path
    else
      render :new
    end
  end

  private

  def league_params
    params.require(:league).permit(:name, :password, :public)
  end
end
