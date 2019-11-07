class MembersController < ApplicationController

  def index
    @members = Member.all
    output = []
    @members.each do |member|
      output.push({
        id: member.id,
        name: member.name,
        email: member.email,
        summary: member.summary,
        avatar: member.avatar.attached? ? rails_blob_url(member.avatar) : nil
      })
    end
    render json: output
  end

  def show
    @member = Member.find(params[:member_id])
    output = {
      id: @member.id,
      name: @member.name,
      email: @member.email,
      summary: @member.summary,
      avatar: @member.avatar.attached? ? rails_blob_url(@member.avatar) : nil
    }
    render json: output
  end

end
