module TransactionsHelper

  def chk_params(tea_id)
    params[:tea] && params[:tea] == tea_id ? 1 : 0
  end

  def keywords(t)
    [t.receive_name, t.receive_mobile, t.buyer_email].join(" ")
  end
end
