module TransactionsHelper

  def chk_params(tea_id)
    params[:tea] && params[:tea] == tea_id ? 1 : 0
  end
end
