# frozen_string_literal: true

class SchedulePostJob < ApplicationJob
  queue_as :default

  def perform(id)
    linkedin_schedule = Internal::LinkedinScheduler.find(id)
    url = build_url(linkedin_schedule.article.id)
    li_client = Internal::LinkedinClientService.new(ENV['LI_TOKEN'])
    li_client.share_article(linkedin_schedule.article.title, linkedin_schedule.post_body, url)
    linkedin_schedule.update(sent: true)
  rescue ActiveRecord::RecordNotFound
    # this means the schedule was cancelled or edited, we just want this to finish and not throw errors
  end

  private

  def build_url(id)
    "https://hamdaan-rails-personal.herokuapp.com/articles/#{id}"
  end
end
