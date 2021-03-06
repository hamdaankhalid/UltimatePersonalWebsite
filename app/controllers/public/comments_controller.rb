# frozen_string_literal: true

module Public
  class CommentsController < Public::BaseController
    def create
      @article = Article.find(params[:article_id])
      @comment = @article.comments.create(
        commenter: comment_params['commenter'],
        body: comment_params['body'],
        status: 'private'
      )
      ModerateCommentJob.perform_later(@comment)
      redirect_to article_path(@article)
    end

    private

    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end
  end
end
