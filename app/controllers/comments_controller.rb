class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_ticket
  before_action :set_current_user
  before_action :require_permission, only: [:edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @comment = Comment.new
  end

  def edit
  end

  def create
    @comment = current_user.comments.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to ticket_comment_path(@ticket, @comment), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to ticket_comment_path(@ticket, @comment), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to ticket_comments_path(@ticket), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end
    
    def set_ticket
        @ticket = Ticket.find(params[:ticket_id])
        @incident = @ticket.incident
    end

    def set_current_user
        @current_user = current_user
    end

    def require_permission
        # prevent user from editing or deleting another user's comment
        if current_user != Comment.find(params[:id]).user
            flash[:alert] = "Cannot edit/delete comment as you did not create it"
            redirect_to ticket_comments_path(@ticket)
        end
    end

    def comment_params
      params.require(:comment).permit(:user_id, :ticket_id, :comment)
    end
end
