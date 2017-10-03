class ConvergeObjectJob < ApplicationJob
  queue_as :default

  def perform(object:)
    Brain.converge_object object: object
  end
end
