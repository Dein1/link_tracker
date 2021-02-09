# frozen_string_literal: true

module Validators
  def self.visited_domains(params)
    if !params[:from] || !params[:to]
      'You have to provide FROM and TO parameters'
    elsif !valid_time?(params[:from]) || !valid_time?(params[:to])
      'You have to pass valid FROM and TO parameters'
    elsif params[:from].to_i > params[:to].to_i
      'FROM must be less than TO'
    else
      :ok
    end
  end

  def self.visited_links(params)
    if !params[:links] || params[:links].empty?
      'Links must be provided'
    else
      :ok
    end
  end

  def self.valid_time?(string)
    /\A\d+\z/.match(string) && string.size == 10
  end
end
