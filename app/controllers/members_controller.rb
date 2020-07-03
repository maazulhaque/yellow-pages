class MembersController < ApplicationController
  def index
    render json: serialized("Members", Member.all), status: :ok
  end

  def show
    render json: serialized("Member", member), status: :ok
  end

  def create
    if new_member.save
      render json: serialized("Member", new_member), status: :created
    else
      render_errors(new_member.errors)
    end
  end

  def search
    return render_422("invalid query params") unless params[:heading]

    render json: serialized("Search", expert_members, { params: { member: member } })
  end

  def befriend
    return render_422("invalid query params") unless params[:friend_id]

    if member.befriend(friend)
      render :ok
    else
      render_errors(member.errors)
    end
  end

  private

  def member
    @member ||= Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:name, :url)
  end

  def friend
    Member.find(params[:friend_id])
  end

  def expert_members
    @expert_members ||= Heading.where("heading like ?", "%#{params[:heading]}%").map(&:member).reject { |m| m.friends.include? member }
  end

  def new_member
    @new_member ||= find_or_initialize_member
  end

  def find_or_initialize_member
    Member.find_or_initialize_by(name: member_params[:name], url: member_params[:url])
  end
end
