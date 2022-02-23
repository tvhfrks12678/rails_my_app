module ServiceModule
  extend ActiveSupport::Concern

  class_methods do
    def call(*args)
      new(*args).send(:call)
    end
  end
end
