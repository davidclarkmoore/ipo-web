class UniquenessController < ApplicationController
	def validate
		model = params[:model].classify.constantize
		unique = (model.where("#{params[:attribute]} = ?", params[:value]).count == 0)
		render text: unique
	end
end