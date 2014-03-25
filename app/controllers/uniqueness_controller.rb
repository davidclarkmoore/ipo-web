class UniquenessController < ApplicationController
	def validate
		model = params[:model].classify.constantize
		unique = if params[:case_sensitive] == "true"
			model.where("lower(#{params[:attribute]}) = ?", params[:value].downcase).count == 0
		else
			model.where("#{params[:attribute]} = ?", params[:value]).count == 0
		end
		render text: unique
	end
end