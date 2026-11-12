module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[edit update destroy]

    def index
      authorize User
      @users = User.order(:email)
    end

    def new
      @user = User.new
      authorize @user
    end

    def create
      @user = User.new(user_params)
      authorize @user
      if @user.save
        redirect_to admin_users_path, notice: "Пользователь создан"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @user
    end

    def update
      authorize @user
      attrs = user_params
      attrs = attrs.except(:password, :password_confirmation) if attrs[:password].blank?
      if @user.update(attrs)
        redirect_to admin_users_path, notice: "Пользователь обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @user
      @user.destroy!
      redirect_to admin_users_path, notice: "Пользователь удалён"
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :name, :role, :active, :password, :password_confirmation)
    end
  end
end
