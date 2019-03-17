class DownloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :submissions_for_user_judge_or_admin, only: [:show]
  after_action :clear_tmp

  def show
    respond_to do |format|
      format.pdf { submission_pdf }
    end
  end

  def bulk_pdf
    bulkify_pdfs
    #TODO: This needs to ajax respond
    # respond_to do |format|
    #   format.pdf { bulkify_pdfs }
    # end
  end

  private

  def submission
    Submission.find(params[:submission_id])
  end

  def download
    Download.new(submission)
  end

  def submission_pdf
    pdf = download.to_pdf
    send_file pdf, download_attributes
  end

  def bulkify_pdfs
    submissions = Submission.find(params[:submission_ids].keys)
    submissions.each do |bulk_submission|
      pdf = Download.new(bulk_submission).to_pdf
      send_file pdf, download_attributes
    end
  end

  def download_attributes
    {
        filename: download.filename,
        type: "application/pdf",
        disposition: "inline"
    }
  end

  def clear_tmp
    #TODO: run this on a delayed task, or clear the whole folder first
    #File.delete("tmp/submission_#{submission.id}.pdf")
  end
end
